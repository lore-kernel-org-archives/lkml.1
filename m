Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYCKS3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYCKS3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYCKS3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:29:42 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:52829
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbYCKS3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:29:41 -0400
Date: Tue, 11 Mar 2008 11:29:33 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Constantin Baranov <const@const.mimas.ru>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       USB Storage List <usb-storage@lists.one-eyed-alien.net>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2.6.25-rc4] usb: add support for Motorola ROKR Z6 cellphone in mass storage mode
Message-ID: <20080311182933.GL2820@one-eyed-alien.net>
Mail-Followup-To: Constantin Baranov <const@const.mimas.ru>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	USB Storage List <usb-storage@lists.one-eyed-alien.net>,
	Greg KH <greg@kroah.com>
References: <47D5804A.2020000@const.mimas.ru> <20080310190158.GI2820@one-eyed-alien.net> <47D59173.9000902@const.mimas.ru> <20080311063019.GA1756@one-eyed-alien.net> <47D62E8B.1060504@const.mimas.ru> <20080311150040.GB1756@one-eyed-alien.net> <47D6CEF7.10608@const.mimas.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OOq1TgGhe8eTwFBO"
Content-Disposition: inline
In-Reply-To: <47D6CEF7.10608@const.mimas.ru>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 11 Mar 2008 11:29:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OOq1TgGhe8eTwFBO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Matthew Dharm <mdharm-usb@one-eyed-alien.net>

Greg, please apply.

Matt

On Tue, Mar 11, 2008 at 10:27:03PM +0400, Constantin Baranov wrote:
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
>  drivers/usb/storage/unusual_devs.h |   11 +++++++++++
>  include/linux/usb_usual.h          |    4 +++-
>  3 files changed, 16 insertions(+), 2 deletions(-)
>=20
> diff -upr linux-2.6.25-rc4/drivers/usb/storage/transport.c
> linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/transport.c
> --- linux-2.6.25-rc4/drivers/usb/storage/transport.c	2008-03-11
> 22:08:20.000000000 +0400
> +++ linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/transport.c
> 2008-03-11 22:09:42.000000000 +0400
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
> --- linux-2.6.25-rc4/drivers/usb/storage/unusual_devs.h	2008-03-11
> 22:08:20.000000000 +0400
> +++ linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/unusual_devs.h
> 2008-03-11 22:14:59.000000000 +0400
> @@ -1589,6 +1589,17 @@ UNUSUAL_DEV(  0x22b8, 0x4810, 0x0001, 0x
>  		US_SC_DEVICE, US_PR_DEVICE, NULL,
>  		US_FL_FIX_CAPACITY),
>=20
> +/*
> + * Patch by Constantin Baranov <const@tltsu.ru>
> + * Report by Andreas Koenecke.
> + * Motorola ROKR Z6.
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
> --- linux-2.6.25-rc4/include/linux/usb_usual.h	2008-03-11
> 22:08:21.000000000 +0400
> +++ linux-2.6.25-rc4-motorokr_z6/include/linux/usb_usual.h	2008-03-11
> 22:09:42.000000000 +0400
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

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

C:  Like the Furby?
DP: He gives me the creeps.  Think the SPCA will take him?
					-- Cobb and Dust Puppy
User Friendly, 1/2/1999

--OOq1TgGhe8eTwFBO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH1s+NHL9iwnUZqnkRAgwVAJ47HNC0VU9JUBNa/DaY6IjjtI3IAACdH/oB
qRK03FVK6GEC/Z0mz9125Vc=
=QbJL
-----END PGP SIGNATURE-----

--OOq1TgGhe8eTwFBO--
