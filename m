Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbYEIEkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbYEIEkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 00:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYEIEkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 00:40:10 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:45360 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbYEIEkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 00:40:08 -0400
Date: Fri, 9 May 2008 06:37:08 +0200
From: Harald Welte <laforge@gnumonks.org>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 0/13] Updated V4  - Regulator Framework
Message-ID: <20080509043708.GG4961@prithivi.gnumonks.org>
References: <1209742841.12502.40.camel@odin> <20080508063538.GC6105@prithivi.gnumonks.org> <1210279887.20475.79.camel@odin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F8dlzb82+Fcn6AgP"
Content-Disposition: inline
In-Reply-To: <1210279887.20475.79.camel@odin>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F8dlzb82+Fcn6AgP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2008 at 09:51:27PM +0100, Liam Girdwood wrote:
> > Do you think it would be worth to export something like this in the
> > generic API, too?  It's probably quite hard, since there are devices
> > that actually use the PCF506xx STANDBY state during suspend-to-ram, but
> > other devices leave the PCF506xx in the ON state and just disable the
> > individual regulators using I2C register writes.
>=20
> Yes I think it would be worthwhile adding this sort of functionality. I
> had considered this earlier on in development but it was lower priority
> for me then.

ok. I also believe it is much lower priority. No disagreement here :)

> This would mean some additions to the regulator machine interface (to be
> used during machine regulator setup) and regulator driver interface (to
> set the values). I could add some 'standby_uV' and 'standby_mode' fields
> (one for each standby state) to struct regulation_constraints. This
> would define the desired voltage and regulator operating mode to be used
> during the regulators STANDBY/HIBERNATE states. Hence the correct
> regulator output state would be selected when the PMIC enters it's
> STANDBY/HIBERNATE state (via either a I2C write or hardware signal).=20
>=20
> Would this suffice for your PMIC (sorry I don't have the datasheet) ?

basically the pcf506xx cannot support a different voltage in standby
mode than in active mode.  They just simply have something like a
bitmaks where you define which regulator is still running in standby,
and which don't.

You can change the bits via I2C, and you can enter STANDBY via either
GPIO or I2C command.

As per the data sheet: If you really want to dig in to that, the
PCF50633 is publicly available at
http://people.openmoko.org/tony_tu/GTA02/datasheet/PMU/PCF50633UM_6.pdf
and the PCF50606 is available at
http://www.rockbox.org/twiki/pub/Main/DataSheets/pcf50606.pdf

> Entering the PMICs global STANDBY/HIBERNATE state usually either comes
> from the hardware (e.g. button press, low battery, over temp) or a
> software user request. The constraints would be set at machine init time
> (along with the runtime constraints). This would work well for WM8350,
> but I'm not sure for PCF506xx.=20

it's pretty much the same.

> However, entering individual regulator STANDBY/HIBERNATE states can be
> more difficult and as it is quite tightly coupled to the machine (and
> it's current use case or use case transition). Do you need per regulator
> STANDBY/HIBERNATE control ?=20

No!

Cheers,
--=20
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)

--F8dlzb82+Fcn6AgP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFII9T0XaXGVTD0i/8RAn4PAJ9jpIj7cK1LOqGgVVKjZNTX2gKSLgCgpl3X
r2iCfp+FGdy5F4Fl+US5qEo=
=mEfw
-----END PGP SIGNATURE-----

--F8dlzb82+Fcn6AgP--
