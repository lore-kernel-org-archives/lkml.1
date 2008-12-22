Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYLVT71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYLVT71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 14:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYLVT7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 14:59:16 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:55304 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYLVT7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 14:59:15 -0500
Message-ID: <494FF180.5040804@linux.vnet.ibm.com>
Date: Mon, 22 Dec 2008 13:58:56 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Duane Griffin <duaneg@dghda.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dustin Kirkland <kirkland@canonical.com>,
       ecryptfs-devel@lists.launchpad.net
Subject: Re: [PATCH, v5] eCryptfs: check readlink result was not an error
 before using it
References: <1229719638-6982-1-git-send-email-duaneg@dghda.com> <1229719638-6982-2-git-send-email-duaneg@dghda.com> <1229719638-6982-3-git-send-email-duaneg@dghda.com>
In-Reply-To: <1229719638-6982-3-git-send-email-duaneg@dghda.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=5D35E502
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF0DE05031335DE3E2DE5D548"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF0DE05031335DE3E2DE5D548
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Duane Griffin wrote:
> The result from readlink is being used to index into the link name
> buffer without checking whether it is a valid length. If readlink
> returns an error this will fault or cause memory corruption.
>=20
> Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

Acked-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

> Cc: Dustin Kirkland <kirkland@canonical.com>
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
> @@ -673,10 +673,11 @@ static void *ecryptfs_follow_link(struct dentry *=
dentry, struct nameidata *nd)
>  	ecryptfs_printk(KERN_DEBUG, "Calling readlink w/ "
>  			"dentry->d_name.name =3D [%s]\n", dentry->d_name.name);
>  	rc =3D dentry->d_inode->i_op->readlink(dentry, (char __user *)buf, le=
n);
> -	buf[rc] =3D '\0';
>  	set_fs(old_fs);
>  	if (rc < 0)
>  		goto out_free;
> +	else
> +		buf[rc] =3D '\0';
>  	rc =3D 0;
>  	nd_set_link(nd, buf);
>  	goto out;



--------------enigF0DE05031335DE3E2DE5D548
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAklP8YcACgkQqDCb9l015QLirACeI2lIZBWErKCRTW9ZlXk5zkYn
tmIAnil67/ufYa4EqgIU7IdX2gPJt9YO
=MwEO
-----END PGP SIGNATURE-----

--------------enigF0DE05031335DE3E2DE5D548--
