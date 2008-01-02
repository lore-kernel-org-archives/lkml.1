Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYABNK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYABNK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbYABNKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:10:50 -0500
Received: from mx40.mail.ru ([194.67.23.36]:65505 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbYABNKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:10:49 -0500
X-Greylist: delayed 12110 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jan 2008 08:10:48 EST
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: hal@lists.freedesktop.org
Subject: Re: kpowersave stuck at battery charging
Date: Wed, 2 Jan 2008 16:10:40 +0300
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Alexey Starikovskiy <aystarik@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200801021248.55844.arvidjaar@mail.ru> <477B6AA5.5020803@gmail.com>
In-Reply-To: <477B6AA5.5020803@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart63125426.BmrP7KHJX4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801021610.45582.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart63125426.BmrP7KHJX4
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 02 January 2008, Alexey Starikovskiy wrote:
> Andrey Borzenkov wrote:
> > This is did not happen before; I am not sure right now what caused this=
=20
(i.e.=20
> > battery aging or some software change) nor whether this is=20
kernel/HAL/kpowersave=20
> > issue.
> >
> > kpowersave is stuck at assuming battery is loading and at 94%. Sysfs=20
displays=20
> > battery state as Full:
> >
> >  =20
> Frequent battery charging shortens lifetime of the battery, so some (may=
=20
> be all now)
> notebook manufacturers do not start charging  battery until it discharge=
=20
> to some degree (~90%).

I thought Li-Ion batteries do not have memory effect. Actually I remember t=
o=20
have read recommendation to avoid deep discharges of Li-Ion battery, it was=
=20
adviced to charge it as often as possible.

> It could be your case. Please try to discharge battery to, say, 89% and=20
> then check if it charges to the
> 100%.

That is exactly the question - how do you compute 100%? As far as I can tel=
l the=20
only possibility is - when battery stops charging. At this point you have t=
o=20
assume battery is fully charged.

I tried to discharge battery (it was around 78%) and plug AC in again. It w=
ent=20
on Charging until the same limit after that state changed to Full (well, in=
 case=20
of ACPI battery we really only can state - not (dis-)charging, there is no=
=20
special Full state flag); kpowersave still believes battery is not fully=20
charged. Main interface shows 84% (no Charging) - tooltip states it is bein=
g=20
charged.

POWER_SUPPLY_NAME=3DBAT1
POWER_SUPPLY_TYPE=3DBattery
POWER_SUPPLY_STATUS=3DFull
POWER_SUPPLY_PRESENT=3D1
POWER_SUPPLY_TECHNOLOGY=3DLi-ion
POWER_SUPPLY_VOLTAGE_MIN_DESIGN=3D10800000
POWER_SUPPLY_VOLTAGE_NOW=3D11340000
POWER_SUPPLY_CURRENT_NOW=3D0
POWER_SUPPLY_ENERGY_FULL_DESIGN=3D38880000
POWER_SUPPLY_ENERGY_FULL=3D37530000
POWER_SUPPLY_ENERGY_NOW=3D35640000
POWER_SUPPLY_MODEL_NAME=3DXM2038P04
POWER_SUPPLY_MANUFACTURER=3D

This would indicate that my battery lost 6% of capacity in new year, but=20
question still remains - how should user tools properly calculate charge le=
vel?

> > - does ACPI battery code misuse POWER_SUPPLY_PROP_ENERGY_FULL?
> > - does HAL misuse .../energy_full?
> > - does kpowersave misuse battery.charge_level.last_full?
> >  =20
>=20
>=20



--nextPart63125426.BmrP7KHJX4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHe41RR6LMutpd94wRAsYyAJ9lw7Gp5k6E454vQn5deW0SKekUPwCgyvo0
BmDstblKaMT4ypzqD4wcVss=
=YF22
-----END PGP SIGNATURE-----

--nextPart63125426.BmrP7KHJX4--
