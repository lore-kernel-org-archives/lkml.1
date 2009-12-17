Return-Path: <linux-kernel-owner+w=401wt.eu-S1763565AbZLQBEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763565AbZLQBEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763482AbZLQBEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:04:34 -0500
Received: from gold.linx.net ([195.66.232.40]:43064 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761952AbZLQBEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:04:33 -0500
Subject: Re: [git pull] VFS stuff, part 1
From: Tony Vroon <tony@linx.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091217004003.GQ14381@ZenIV.linux.org.uk>
References: <20091216185157.GL14381@ZenIV.linux.org.uk>
	 <a4423d670912161441v12bfa53dj7cf2cca6247dd290@mail.gmail.com>
	 <1261004048.3154.2.camel@localhost>
	 <20091216230711.GN14381@ZenIV.linux.org.uk>
	 <1261005194.3154.4.camel@localhost>
	 <20091216232729.GO14381@ZenIV.linux.org.uk>
	 <1261008131.3026.0.camel@localhost>
	 <20091217004003.GQ14381@ZenIV.linux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4Ixr1sJOU9pnVtY4ZBGg"
Organization: London Internet Exchange (LINX; AS5459)
Date: Thu, 17 Dec 2009 01:05:06 +0000
Message-ID: <1261011906.3183.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4Ixr1sJOU9pnVtY4ZBGg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-12-17 at 00:40 +0000, Al Viro wrote:
> In the meanwhile, see if this fixes it
> 8f4cb3a4252a053d2c7299d7d251389bddf0bcd4
> diff --git a/mm/shmem.c b/mm/shmem.c

I can confirm that this fixes the problem. (When applied to a virgin
linux-2.6 checkout, without reverting anything)

Thank you :)

> index f848506..eef4ebe 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1830,6 +1830,8 @@ shmem_mknod(struct inode *dir, struct dentry *dentr=
y, int mode, dev_t dev)
>  			iput(inode);
>  			return error;
>  		}
> +#else
> +		error =3D 0;
>  #endif
>  		if (dir->i_mode & S_ISGID) {
>  			inode->i_gid =3D dir->i_gid;

Regards,
Tony V.

--=-4Ixr1sJOU9pnVtY4ZBGg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEABECAAYFAkspg8IACgkQp5vW4rUFj5ohXwCfV58+bv4DbwBzhT5ZiE0m2oxf
kncAoJhhSPt+4FCqgcG0cmnnTo94+slz
=RW7x
-----END PGP SIGNATURE-----

--=-4Ixr1sJOU9pnVtY4ZBGg--

