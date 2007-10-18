Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbXJRHKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbXJRHKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 03:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbXJRHKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 03:10:33 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:38575 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762228AbXJRHKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 03:10:31 -0400
Subject: Re: + reiserfs-fix-up-lockdep-warnings.patch added to -mm tree
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: akpm@linux-foundation.org
Cc: jeffm@suse.com, hch@lst.de, mason@suse.com, vs@namesys.com,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200710172211.l9HMBnCr010855@imap1.linux-foundation.org>
References: <200710172211.l9HMBnCr010855@imap1.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dBFNV3VczgtiShL98nDu"
Date: Thu, 18 Oct 2007 09:10:25 +0200
Message-Id: <1192691425.27435.159.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dBFNV3VczgtiShL98nDu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-17 at 15:11 -0700, akpm@linux-foundation.org wrote:

> Subject: reiserfs: fix up lockdep warnings
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> Add I_MUTEX_XATTR annotations to the inode locking in the reiserfs xattr =
code.
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Chris Mason <mason@suse.com>
> Cc: "Vladimir V. Saveliev" <vs@namesys.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

Yep looks good,

want me to push this through the lockdep tree, or will you forward it?

In which case:

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  fs/reiserfs/xattr.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff -puN fs/reiserfs/xattr.c~reiserfs-fix-up-lockdep-warnings fs/reiserf=
s/xattr.c
> --- a/fs/reiserfs/xattr.c~reiserfs-fix-up-lockdep-warnings
> +++ a/fs/reiserfs/xattr.c
> @@ -484,7 +484,7 @@ reiserfs_xattr_set(struct inode *inode,=20
>  	/* Resize it so we're ok to write there */
>  	newattrs.ia_size =3D buffer_size;
>  	newattrs.ia_valid =3D ATTR_SIZE | ATTR_CTIME;
> -	mutex_lock(&xinode->i_mutex);
> +	mutex_lock_nested(&xinode->i_mutex, I_MUTEX_XATTR);
>  	err =3D notify_change(fp->f_path.dentry, &newattrs);
>  	if (err)
>  		goto out_filp;
> @@ -1223,7 +1223,8 @@ int reiserfs_xattr_init(struct super_blo
>  		if (!IS_ERR(dentry)) {
>  			if (!(mount_flags & MS_RDONLY) && !dentry->d_inode) {
>  				struct inode *inode =3D dentry->d_parent->d_inode;
> -				mutex_lock(&inode->i_mutex);
> +				mutex_lock_nested(&inode->i_mutex,
> +				                  I_MUTEX_XATTR);
>  				err =3D inode->i_op->mkdir(inode, dentry, 0700);
>  				mutex_unlock(&inode->i_mutex);
>  				if (err) {


--=-dBFNV3VczgtiShL98nDu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHFwbhXA2jU0ANEf4RAjNAAJ9eI2zE237nPLxACod4eBMSuROV4wCdEwDq
4Q8juFe8tkAJITLqsP4nut8=
=TmJv
-----END PGP SIGNATURE-----

--=-dBFNV3VczgtiShL98nDu--

