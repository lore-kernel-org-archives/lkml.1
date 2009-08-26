Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbZHZOWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbZHZOWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbZHZOWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:22:46 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:34492 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821AbZHZOWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:22:45 -0400
Subject: Re: PPC driver - generic bus width
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Alemao <xcarandiru@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <d970ff420908260625q2d34bc10p62241218f022b5c2@mail.gmail.com>
References: <d970ff420908260625q2d34bc10p62241218f022b5c2@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-R7omrj8J5QJYbrTxDnX1"
Date: Thu, 27 Aug 2009 00:22:45 +1000
Message-Id: <1251296565.7492.7.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-R7omrj8J5QJYbrTxDnX1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-26 at 10:25 -0300, Alemao wrote:
> Hi all,
>=20
> Im trying to develop a driver for my device, and its data bus can be 8, 1=
6
> or 32 bits. This information is passed through the device tree source.
> My code is like this:
>=20
> struct device_info_t {
> 	void (*read)();
> 	void (*write)();
> };
>=20
> static int __devinit device_probe()
> {
> 	prop =3D of_get_property(ofdev->node, "bus-width", &size);
>=20
> 	device->bus_width =3D *prop;
>=20
> 	switch (device->bus_width) {
> 	case 8:
> 		device->read  =3D in_8;
> 		device->write =3D out_8;
> 		break;
> 	case 16:
> 		device->read  =3D in_be16;
> 		device->write =3D out_be16;
> 		break;
> 	case 32:
> 		device->read  =3D in_be32;
> 		device->write =3D out_be32;
> 		break;
> 	default:
> 		break;
> 	}
> }
>=20
> Can someone point me some driver that is doing something similar to the
> ideia shown above?
>=20
> Or what Im doing wrong in my code? Cause Im getting erros (warnings) like=
:
>=20
> cc1: warnings being treated as errors
> drivers/dev_test.c:37: warning: function declaration isn't a prototype
> drivers/dev_test.c:38: warning: function declaration isn't a prototype
> drivers/dev_test.c: In function 'device_probe':
> drivers/dev_test.c:113: warning: assignment from incompatible pointer
> type

I'm not sure about the first two, you don't seem to have pasted all the
source, and you haven't given the line numbers.

The 3rd is probably because the prototype for in_8 etc. doesn't match
your structure.

cheers

--=-R7omrj8J5QJYbrTxDnX1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqVRTUACgkQdSjSd0sB4dJ88QCeKagn2D+/4kU4qf8u/g0Wsm8T
nnIAnjWR0rqgFiO+T23O91XEc07kFQbI
=/i3Y
-----END PGP SIGNATURE-----

--=-R7omrj8J5QJYbrTxDnX1--

