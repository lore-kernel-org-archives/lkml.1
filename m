Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbZABWu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbZABWu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbZABWuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:50:18 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:50800 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073AbZABWuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:50:17 -0500
Subject: Re: 2.6.28-git3 and i915 Kconfig new dependency on framebuffer
From: Eric Anholt <eric@anholt.net>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <5a4c581d0812311055m5f9f395ci331457f9ed1d1a7f@mail.gmail.com>
References: <5a4c581d0812311055m5f9f395ci331457f9ed1d1a7f@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0rVThM0Ngy/h1F5bcZ0Y"
Date: Fri, 02 Jan 2009 14:50:08 -0800
Message-Id: <1230936608.6095.2.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0rVThM0Ngy/h1F5bcZ0Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-31 at 19:55 +0100, Alessandro Suardi wrote:
> make oldconfig from -git2 to -git3 doesn't build i915.ko unless
>  one has CONFIG_FB enabled; this causes /dev/dri/card0 to
>  be missing, and DRI disabled from within X.
>=20
> Do I now (2.6.28-git3+) need CONFIG_FB to enable i915 DRM ?

Yes, the i915 driver now relies on fb code, though the new features are
runtime optional.  I may have noviced the Kconfig bits -- my intention
was "If you select I915, you also get all the CONFIG_FB-related bits
necessary".

config DRM_I915
        select FB_CFB_FILLRECT
        select FB_CFB_COPYAREA
        select FB_CFB_IMAGEBLIT
        depends on FB
        tristate "i915 driver"

I'm guessing that that "depends on FB" wants to be "select FB".

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-0rVThM0Ngy/h1F5bcZ0Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklemh0ACgkQHUdvYGzw6vfV/wCfTfKyj3Cl/5ATYIwX4dbduwLx
UhgAn3xYEX4pJi/B26exWo00Zdkz6h8Y
=6ww8
-----END PGP SIGNATURE-----

--=-0rVThM0Ngy/h1F5bcZ0Y--

