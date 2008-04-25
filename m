Return-Path: <linux-kernel-owner+w=401wt.eu-S1761532AbYDYJ3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbYDYJ3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 05:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759150AbYDYJ3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 05:29:21 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:4066 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759088AbYDYJ3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:29:21 -0400
Message-ID: <4811A464.4070203@imap.cc>
Date: Fri, 25 Apr 2008 11:29:08 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: hjlipp@web.de, gigaset307x-common@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gigaset: gigaset_isowbuf_getbytes() may return signed
 unnoticed
References: <480FA9BC.7070205@tiscali.nl>
In-Reply-To: <480FA9BC.7070205@tiscali.nl>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig41FAD5A0D46B415FD5F346BA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig41FAD5A0D46B415FD5F346BA
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 23.04.2008 23:27 schrieb Roel Kluin:
> ifd->offset is unsigned. gigaset_isowbuf_getbytes() may return signed u=
nnoticed

Thanks, good catch. I wonder why neither sparse nor gcc emitted
a warning for that.

> --- a/drivers/isdn/gigaset/bas-gigaset.c
> +++ b/drivers/isdn/gigaset/bas-gigaset.c
> @@ -1050,9 +1050,9 @@ static int submit_iso_write_urb(struct isow_urbct=
x_t *ucx)
>  		}
> =20
>  		/* retrieve block of data to send */
> -		ifd->offset =3D gigaset_isowbuf_getbytes(ubc->isooutbuf,
> -						       ifd->length);
> -		if (ifd->offset < 0) {
> +		rc =3D gigaset_isowbuf_getbytes(ubc->isooutbuf, ifd->length);
> +		ifd->offset =3D rc;
> +		if (rc < 0) {
>  			if (ifd->offset =3D=3D -EBUSY) {
>  				gig_dbg(DEBUG_ISO,
>  					"%s: buffer busy at frame %d",

Please, also replace ifd->offset by rc in the body of the "if (rc < 0)"
and put the assignment to ifd->offset behind it so that it is only done
if rc >=3D 0. (Frame *ifd is not used in the < 0 case.)

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig41FAD5A0D46B415FD5F346BA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIEaRkQ3+did9BuFsRAtEpAJ4hk/NrAMldANVglDl9tZPZmM0pAwCfTPll
v821vauA/NKQCnTUSBFSvmA=
=K/Tl
-----END PGP SIGNATURE-----

--------------enig41FAD5A0D46B415FD5F346BA--
