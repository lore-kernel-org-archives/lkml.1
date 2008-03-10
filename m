Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYCJTCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYCJTCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYCJTCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:02:13 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:49764
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbYCJTCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:02:11 -0400
Date: Mon, 10 Mar 2008 12:01:58 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Constantin Baranov <const@const.mimas.ru>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc4] usb: add support for Motorola ROKR Z6 cellphone in mass storage mode
Message-ID: <20080310190158.GI2820@one-eyed-alien.net>
Mail-Followup-To: Constantin Baranov <const@const.mimas.ru>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <47D5804A.2020000@const.mimas.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6lXr1rPCNTf1w0X8"
Content-Disposition: inline
In-Reply-To: <47D5804A.2020000@const.mimas.ru>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Mon, 10 Mar 2008 12:02:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6lXr1rPCNTf1w0X8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Are all 3 flags truly needed?

Matt

On Mon, Mar 10, 2008 at 10:39:06PM +0400, Constantin Baranov wrote:
> From: Constantin Baranov <const@tltsu.ru>
>=20
> Motorola ROKR Z6 cellphone has bugs in its USB, so it is impossible to use
> it as mass storage. Patch describes new "unusual" USB device for it with
> FIX_INQUIRY and FIX_CAPACITY flags and new BULK_IGNORE_TAG flag.
> Last flag relaxes check for equality of bcs->Tag and us->tag in
> usb_stor_Bulk_transport routine.
>=20
> Signed-off-by: Constantin Baranov <const@tltsu.ru>
> ---
>  drivers/usb/storage/transport.c    |    3 ++-
>  drivers/usb/storage/unusual_devs.h |   10 ++++++++++
>  include/linux/usb_usual.h          |    4 +++-
>  3 files changed, 15 insertions(+), 2 deletions(-)
>=20
> diff -upr linux-2.6.25-rc4/drivers/usb/storage/transport.c
> linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/transport.c
> --- linux-2.6.25-rc4/drivers/usb/storage/transport.c	2008-03-10
> 22:09:11.000000000 +0400
> +++ linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/transport.c
> 2008-03-10 22:11:24.000000000 +0400
> @@ -1009,7 +1009,8 @@ int usb_stor_Bulk_transport(struct scsi_
>  	US_DEBUGP("Bulk Status S 0x%x T 0x%x R %u Stat 0x%x\n",
>  			le32_to_cpu(bcs->Signature), bcs->Tag,
>  			residue, bcs->Status);
> -	if (bcs->Tag !=3D us->tag || bcs->Status > US_BULK_STAT_PHASE) {
> +	if (!(bcs->Tag =3D=3D us->tag || (us->flags & US_FL_BULK_IGNORE_TAG)) ||
> +		bcs->Status > US_BULK_STAT_PHASE) {
>  		US_DEBUGP("Bulk logical error\n");
>  		return USB_STOR_TRANSPORT_ERROR;
>  	}
> diff -upr linux-2.6.25-rc4/drivers/usb/storage/unusual_devs.h
> linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/unusual_devs.h
> --- linux-2.6.25-rc4/drivers/usb/storage/unusual_devs.h	2008-03-10
> 22:09:11.000000000 +0400
> +++ linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/unusual_devs.h
> 2008-03-10 22:10:40.000000000 +0400
> @@ -1589,6 +1589,16 @@ UNUSUAL_DEV(  0x22b8, 0x4810, 0x0001, 0x
>  		US_SC_DEVICE, US_PR_DEVICE, NULL,
>  		US_FL_FIX_CAPACITY),
>=20
> +/*
> + * Patch by Constantin Baranov <const@tltsu.ru>
> + * Report by Andreas Koenecke
> + */
> +UNUSUAL_DEV(  0x22b8, 0x6426, 0x0101, 0x0101,
> +		"Motorola",
> +		"MSnc.",
> +		US_SC_DEVICE, US_PR_DEVICE, NULL,
> +		US_FL_FIX_INQUIRY | US_FL_FIX_CAPACITY | US_FL_BULK_IGNORE_TAG),
> +
>  /* Reported by Radovan Garabik <garabik@kassiopeia.juls.savba.sk> */
>  UNUSUAL_DEV(  0x2735, 0x100b, 0x0000, 0x9999,
>  		"MPIO",
> diff -upr linux-2.6.25-rc4/include/linux/usb_usual.h
> linux-2.6.25-rc4-motorokr_z6/include/linux/usb_usual.h
> --- linux-2.6.25-rc4/include/linux/usb_usual.h	2008-03-10
> 22:09:12.000000000 +0400
> +++ linux-2.6.25-rc4-motorokr_z6/include/linux/usb_usual.h	2008-03-10
> 22:10:40.000000000 +0400
> @@ -50,7 +50,9 @@
>  	US_FLAG(CAPACITY_HEURISTICS,	0x00001000)		\
>  		/* sometimes sizes is too big */		\
>  	US_FLAG(MAX_SECTORS_MIN,0x00002000)			\
> -		/* Sets max_sectors to arch min */
> +		/* Sets max_sectors to arch min */		\
> +	US_FLAG(BULK_IGNORE_TAG,0x00004000)			\
> +		/* Ignore tag mismatch in bulk operations */
>=20
>=20
>  #define US_FLAG(name, value)	US_FL_##name =3D value ,
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

You were using cheat codes too.  You guys suck.
					-- Greg to General Studebaker
User Friendly, 12/16/1997

--6lXr1rPCNTf1w0X8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH1YWmHL9iwnUZqnkRAk54AJ9FdKsFFwXId5aWgeFX1846EofUSQCgqgCW
a6HebHPRT/lQluS/XLUNxIU=
=7RgY
-----END PGP SIGNATURE-----

--6lXr1rPCNTf1w0X8--
