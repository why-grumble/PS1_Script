$AD_Users = Import-csv C:\users.csv -Delimiter  ';'
$AD_racine = 'DC=hugo,DC=local'

foreach ($User in $AD_Users)
{

       $User_password       = $User.mdp
       $User_nom            = $User.nom
       $User_prenom         = $User.prenom
       $User_OU             = 'OU='+ $User.unite+',OU=personnel,'+$AD_racine
       $User_name           = $User_prenom.ToLower().Substring(0, 1) +'.'+ $User_nom.ToLower()


       if (Get-ADUser -F {SamAccountName -eq $User_name})
       {
               #Will output a warning message if user exist.
               Write-Warning "A user $User_name has already existed in Active Directory."
       }
       else
       {
            New-ADUser `
            -Name "$User_prenom $User_nom" `
            -SamAccountName $User_name `
            -GivenName "$User_prenom" `
            -Surname "$User_nom" `
            -UserPrincipalName "$User_name@hugo.local" `
            -AccountPassword (convertto-securestring $User_Password -AsPlainText -Force) `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -DisplayName "$User_prenom $User_nom" `
            -Path $User_OU
       }
}
