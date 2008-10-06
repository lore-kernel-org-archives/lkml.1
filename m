Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYJFKfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYJFKfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 06:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYJFKfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 06:35:42 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:46836 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbYJFKfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 06:35:42 -0400
Date: Mon, 6 Oct 2008 12:35:40 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 36/76] tty: Make get_current_tty use a kref
Message-ID: <20081006103540.GC29198@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <20081005160231.1997.10462.stgit@localhost.localdomain> <20081005161021.1997.38953.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-6063-1223289199-0001-2"
Content-Disposition: inline
In-Reply-To: <20081005161021.1997.38953.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-6063-1223289199-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 05, 2008 at 05:10:42PM +0100, Alan Cox wrote:
> We now return a kref covered tty reference. That ensures the tty structure
> doesn't go away when you have a return from get_current_tty. This is not
> enough to protect you from most of the resources being freed behind your
> back - yet.
>=20
> [Updated to include fixes for SELinux problems found by Andrew Morton and
>  an s390 leak found while debugging the former]
>=20

[...]

> diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
> index d18e6d2..3ef5425 100644
> --- a/drivers/s390/char/fs3270.c
> +++ b/drivers/s390/char/fs3270.c
> @@ -430,11 +430,12 @@ fs3270_open(struct inode *inode, struct file *filp)
>  		mutex_lock(&tty_mutex);
>  		tty =3D get_current_tty();
>  		if (!tty || tty->driver->major !=3D IBM_TTY3270_MAJOR) {
> -			mutex_unlock(&tty_mutex);
> +			tty_kref_put(tty);

Should'nt mutex_unlock() be kept?

Louis

>  			rc =3D -ENODEV;
>  			goto out;
>  		}
>  		minor =3D tty->index + RAW3270_FIRSTMINOR;
> +		tty_kref_put(tty);
>  		mutex_unlock(&tty_mutex);
>  	}
>  	/* Check if some other program is already using fullscreen mode. */

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-6063-1223289199-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFI6en8VKcRuvQ9Q1QRAnYDAJ4kdcq8pv8rtVOnFBmMhz7xvDLrTACZAW4o
/vxwGLHhNQknNiFQvj/6s+c=
=lvbc
-----END PGP SIGNATURE-----

--=_bohort-6063-1223289199-0001-2--
