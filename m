Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYLDHKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYLDHKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 02:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYLDHKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 02:10:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36941 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbYLDHKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 02:10:18 -0500
Date: Thu, 4 Dec 2008 18:10:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: Conflict resolved in the security-testing tree
Message-Id: <20081204181008.8a5c0f91.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LRH.1.10.0812041731280.6279@tundra.namei.org>
References: <alpine.LRH.1.10.0812041731280.6279@tundra.namei.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Dec_2008_18_10_08_+1100_ezNMzr4ghSikG2FO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Dec_2008_18_10_08_+1100_ezNMzr4ghSikG2FO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Thu, 4 Dec 2008 17:33:39 +1100 (EST) James Morris <jmorris@namei.org> wr=
ote:
>
> I resolved a conflict between the new creds API and the nfs4 server code=
=20
> in=20
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.=
6#next
>=20
> per the patch below.  Please check.
>=20
>=20
> diff --cc fs/nfsd/nfs4recover.c
> index 9371ea1,b79ec93..0000000
> --- a/fs/nfsd/nfs4recover.c
> +++ b/fs/nfsd/nfs4recover.c
> @@@ -230,12 -224,10 +230,13 @@@ nfsd4_list_rec_dir(struct dentry *dir,=20
>   	if (!rec_dir_init)
>   		return 0;
>  =20
>  -	nfs4_save_user(&uid, &gid);
>  +	status =3D nfs4_save_creds(&original_cred);
>  +	if (status < 0)
>  +		return status;
> + 	INIT_LIST_HEAD(dentries);
>  =20
>  -	filp =3D dentry_open(dget(dir), mntget(rec_dir.mnt), O_RDONLY);
>  +	filp =3D dentry_open(dget(dir), mntget(rec_dir.mnt), O_RDONLY,
>  +			   current_cred());
>   	status =3D PTR_ERR(filp);
>   	if (IS_ERR(filp))
>   		goto out;

That is exactly what I did in linux-next in Nov 25 and got no screams
then.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Dec_2008_18_10_08_+1100_ezNMzr4ghSikG2FO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk3glAACgkQjjKRsyhoI8zmgwCfSh+x2AfCDHceR0ZzbOO8ZoI9
kb8AniVDiMbYSuXFzeESK05U0VGB61m/
=pSCp
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Dec_2008_18_10_08_+1100_ezNMzr4ghSikG2FO--
