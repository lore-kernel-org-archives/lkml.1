Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbYJ0SAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbYJ0SAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYJ0SAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:00:22 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:50710 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbYJ0SAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:00:21 -0400
Subject: Re: 2.6.28-rc1: [drm:i915] *ERROR* ... Disabling tiling
From: Eric Anholt <eric@anholt.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: dri-devel@lists.sourceforge.net,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4905CFC3.1060907@tuffmail.co.uk>
References: <4905CFC3.1060907@tuffmail.co.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/62sOKFmvuQ/K+Lrjgu5"
Date: Mon, 27 Oct 2008 11:00:22 -0700
Message-Id: <1225130422.4845.35.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/62sOKFmvuQ/K+Lrjgu5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 14:27 +0000, Alan Jenkins wrote:
> What does this mean, should I do anything about it?  Is tiling nice to ha=
ve?
>=20
> It sounds like GEM broke something - though maybe it just added a more=20
> verbose error report.
>=20
> System: EeePC 701
> Kernel: v2.6.36-rc1-5-g23cf24c
> Chipset: Intel mobile 915G-something
> Regretably necessary kernel boot option: noapic
>=20
>=20
> [    1.438441] Linux agpgart interface v0.103
> [    1.438441] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
> [    1.438441] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
> [    1.443353] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000=
000
> [    1.443353] [drm] Initialized drm 1.1.0 20060810
> [    1.443353] pci 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 5=20
> (level, low) -> IRQ 5
> [    1.443353] pci 0000:00:02.0: setting latency timer to 64
> [    1.443353] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read=20
> from MCHBAR.  Disabling
> tiling.

This means that something went wrong with our detection of the
CPU-versus-GPU tiling swizzling mode, and object tiling under GEM will
be disabled as a result.  I should get access to an eee 7xx on Thursday
to see what's up with it -- it's supposed to be just a normal 915gm as
far as I know.

> [    1.443353] [drm:i915_driver_load]o  *ERROR* failed to enable MSI

Looks like we emit the error message even if your chipset doesn't
support MSI.  That's a mistake, I'll get it cleaned up.

(MSI didn't actually get supported for integrated graphics until the
G965 for the desktop and GM45 for mobile, though it got supported for
ethernet and PEG earlier than that)

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-/62sOKFmvuQ/K+Lrjgu5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkGAbYACgkQHUdvYGzw6vcElwCdGnROr7hWRAs1sO1J9mRzDqaO
TIcAnjZ7XMKvMn0WPNB+HIjvyBRv6tcw
=dlbC
-----END PGP SIGNATURE-----

--=-/62sOKFmvuQ/K+Lrjgu5--

