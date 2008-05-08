Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbYEHSBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbYEHSBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759309AbYEHSBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:01:08 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:58497 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbYEHSBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:01:06 -0400
X-Greylist: delayed 1855 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2008 14:01:06 EDT
Date: Thu, 8 May 2008 08:35:38 +0200
From: Harald Welte <laforge@gnumonks.org>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 0/13] Updated V4  - Regulator Framework
Message-ID: <20080508063538.GC6105@prithivi.gnumonks.org>
References: <1209742841.12502.40.camel@odin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <1209742841.12502.40.camel@odin>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2008 at 04:40:41PM +0100, Liam Girdwood wrote:
> This is an updated version of the kernel voltage & current regulator
> framework based on comments received from version 3 of the patch series.
>=20
> The regulator framework is designed to provide a standard kernel
> interface to control voltage and current regulators on SoC based
> systems.

Dear Liam,

I have reviewed your regulator framework from the point of view of the
Openmoko GTA01 and GTA02 devices, based on members of the NXP PCF506xx
PMU(PMIC) devices (for which I wrote the drivers).=20

I believe it would fit quite nice onto this PMIC family from a different
manufacturer.

There is one aspects of the PCF506xx that I think the current regulator
framework doesn't (yet) cover.  I'm not sure if it was worth to add
support for this, but let me explain:

The PCF506xx have a concept of global power management states,
particularly important are the ON and STANDBY states in this context.
Every regulator has a property whether it is enabled in none, one or
both of the global power management states.

Do you think it would be worth to export something like this in the
generic API, too?  It's probably quite hard, since there are devices
that actually use the PCF506xx STANDBY state during suspend-to-ram, but
other devices leave the PCF506xx in the ON state and just disable the
individual regulators using I2C register writes.

I think there's probably no clean way how to integrate this, since the
question remains: who makes the decision (and manages the contraints) of
when to transition into the STANDBY state.   Nevertheless a read-only
sysfs attribute might still be interesting.

Cheers,
--=20
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIIp86XaXGVTD0i/8RAuXXAJ9bt14Vhf6GYdcBj1Fy1CxEaupVawCgiJ25
0Na2YrY2tX+sXU75GHdiRbs=
=QS9S
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
