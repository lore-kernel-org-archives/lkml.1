Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbXL0Kx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbXL0Kx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 05:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbXL0KxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 05:53:20 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:58180 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbXL0KxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 05:53:19 -0500
Date: Thu, 27 Dec 2007 11:53:15 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: "raki john" <raki4652@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Order of Loading mmc driver modules.
Message-ID: <20071227115315.460d8827@poseidon.drzeus.cx>
In-Reply-To: <d2a348dd0712261040w402d6390o1b4f2abd83959c86@mail.gmail.com>
References: <d2a348dd0712261040w402d6390o1b4f2abd83959c86@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-24618-1198752797-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-24618-1198752797-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Dec 2007 10:40:22 -0800
"raki john" <raki4652@gmail.com> wrote:

> Hi All,
>=20
> I am working with pxamci driver(2.6.22.1). I have made , core and host
> as  separate modules.
>=20
> what is the correct order of loading the modules
>=20
> i am doing in this order first core (mmc_core.ko), then card(mmc_block.ko)
> after that host driver ( pxamci.ko). Is this correct.
>=20

If you're using just insmod, then yes, this is a valid order. The only thin=
g that is crucial is that mmc_core is loaded before any of the other. If yo=
u use modprobe that will happen automatically.

> I do not know much about Linux device model.
>=20

There's lots of info on the web and in the Documentation/ directory of the =
kernel source if you want to indulge yourself.

> i saw that pxamci.ko driver registers it self as platform_driver. When
> does its probe function is called. Is it called immediately  after
> platform_driver_register(&pxamci_driver) is called.
>=20

For pxamci, yes. More specifically, the probe function is called when there=
 is both a driver (created by platform_driver_register()) and a device (pla=
tform_device_register()) available. But since the device is added very earl=
y in the pxamci case, the magic will happen when the driver registers.

> also in card driver (mmc_block.ko) in block.c  file i saw a probe
> function(mmc_blk_probe). How does it is invoked .
>=20

When the corresponding device is registered. In this case it is whenever a =
card is detected and initialized.

Rgds
Pierre

--=_hera.drzeus.cx-24618-1198752797-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEARECAAYFAkdzhBsACgkQ7b8eESbyJLjsxwCeLFtgpI9DGwKRQdUwmVScFGLr
20gAnReIUctTmRw1MYeO4L4REZPPaf30
=7CO1
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-24618-1198752797-0001-2--
