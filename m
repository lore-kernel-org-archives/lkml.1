Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYLVUHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYLVUHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 15:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYLVUGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 15:06:54 -0500
Received: from adelie.canonical.com ([91.189.90.139]:45783 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYLVUGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 15:06:53 -0500
Subject: Re: [PATCH, v5] eCryptfs: check readlink result was not an error
 before using it
From: Dustin Kirkland <kirkland@canonical.com>
Reply-To: kirkland@canonical.com
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       ecryptfs-devel@lists.launchpad.net
In-Reply-To: <1229719638-6982-3-git-send-email-duaneg@dghda.com>
References: <1229719638-6982-1-git-send-email-duaneg@dghda.com>
	 <1229719638-6982-2-git-send-email-duaneg@dghda.com>
	 <1229719638-6982-3-git-send-email-duaneg@dghda.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ORcslCwtHsBIZLzeYBv/"
Organization: Canonical
Date: Mon, 22 Dec 2008 14:06:43 -0600
Message-Id: <1229976403.8252.169.camel@t61p>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ORcslCwtHsBIZLzeYBv/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-19 at 20:47 +0000, Duane Griffin wrote:
> The result from readlink is being used to index into the link name
> buffer without checking whether it is a valid length. If readlink
> returns an error this will fault or cause memory corruption.
>=20
> Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
> Cc: Dustin Kirkland <kirkland@canonical.com>

Acked-by: Dustin Kirkland <kirkland@canonical.com>

> Cc: ecryptfs-devel@lists.launchpad.net
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
> ---
>=20
> Unchanged from original version.
>=20
>  fs/ecryptfs/inode.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 89209f0..5e78fc1 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -673,10 +673,11 @@ static void *ecryptfs_follow_link(struct dentry *de=
ntry, struct nameidata *nd)
>  	ecryptfs_printk(KERN_DEBUG, "Calling readlink w/ "
>  			"dentry->d_name.name =3D [%s]\n", dentry->d_name.name);
>  	rc =3D dentry->d_inode->i_op->readlink(dentry, (char __user *)buf, len)=
;
> -	buf[rc] =3D '\0';
>  	set_fs(old_fs);
>  	if (rc < 0)
>  		goto out_free;
> +	else
> +		buf[rc] =3D '\0';
>  	rc =3D 0;
>  	nd_set_link(nd, buf);
>  	goto out;

--=-ORcslCwtHsBIZLzeYBv/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklP81MACgkQs7pNXIOmEZRlTgCeP9xH4hNIzwoW63zsLaxROY+z
mDoAn3oNWiqNfBtsaXduoSuZbaZ3R9Ep
=lLBu
-----END PGP SIGNATURE-----

--=-ORcslCwtHsBIZLzeYBv/--

