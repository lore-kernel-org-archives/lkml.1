Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbXK1M3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbXK1M3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbXK1M31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:29:27 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:37250 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbXK1M30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:29:26 -0500
Date: Wed, 28 Nov 2007 13:29:16 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org
Subject: Re: m68k build failure
Message-ID: <20071128132916.125e72ec@poseidon.drzeus.cx>
In-Reply-To: <20071128092856.GV8181@ftp.linux.org.uk>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
	<20071128094856.056c0a3f@poseidon.drzeus.cx>
	<20071128010056.85703a34.akpm@linux-foundation.org>
	<20071128092856.GV8181@ftp.linux.org.uk>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-29526-1196252964-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-29526-1196252964-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Nov 2007 09:28:56 +0000
Al Viro <viro@ftp.linux.org.uk> wrote:

>=20
> Eh...  m68k has 16bit alignment for unsigned long. =20
>=20
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_deviceta=
ble.h
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -343,7 +343,8 @@ struct sdio_device_id {
>  	__u8	class;			/* Standard interface or SDIO_ANY_ID */
>  	__u16	vendor;			/* Vendor or SDIO_ANY_ID */
>  	__u16	device;			/* Device ID or SDIO_ANY_ID */
> -	kernel_ulong_t driver_data;	/* Data private to the driver */
> +	kernel_ulong_t driver_data	/* Data private to the driver */
> +		__attribute__((aligned(sizeof(kernel_ulong_t))));
>  };
> =20
>  /* SSB core, see drivers/ssb/ */

Unfortunately, that just papers over the symptom and doesn't solve the unde=
rlying issue. If you cross-compile on/for an arch with byte alignment, then=
 the issue is back. Or one that uses 4-byte alignment even for u16.

Is there no directive we can stick in there that forces a reasonable alignm=
ent (e.g. alignment =3D=3D sizeof(type)) independently of arch?

Rgds
Pierre

--=_hera.drzeus.cx-29526-1196252964-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHTV8c7b8eESbyJLgRAsTfAKCZUNtZStWBTsusyN7cWBlghP/v8QCg6NZH
g9xsS7bKyJJn4Bc3HKVF7aQ=
=VON8
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-29526-1196252964-0001-2--
