Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYDMXf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYDMXf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYDMXfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:35:21 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:36246 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbYDMXfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:35:20 -0400
Date: Sun, 13 Apr 2008 18:09:47 -0500
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 34/35] W1: Documentation/w1/masters/ds2490 update
Message-ID: <20080413230947.GA14049@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net> <20080328122758.GI3613@spacedout.fries.net> <20080330114335.GM15122@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20080330114335.GM15122@2ka.mipt.ru>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 13 Apr 2008 18:35:15 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 30, 2008 at 03:43:35PM +0400, Evgeniy Polyakov wrote:
> On Fri, Mar 28, 2008 at 07:27:59AM -0500, David Fries (david@fries.net) w=
rote:
> > +Notes and limitations.
> > +- The 5V strong pullup is supported.
> > +- While the ds2490 supports a hardware search the code doesn't take
> > +  advantage of it.
>=20
> It does not actually - at least my hardware can only find first device
> on the bus, so I dropped the implementation.

ds_search, ds_match_access, and ds_set_path need a comment to that
effect then.

> I generally ack whe whole ds2490 changes except pullup one - it has
> to be turned off by default, presumably tested with multiple devices on
> the same wire.

The second set of patches include a module parameter for both the
w1_therm where a 5V strong pullup is requested and the one wire core
w1_io.c where the request makes calls into the master driver.  This
way there is also a sysfs file to enable and disable the 5V strong
pullup per master.

I have tested the 5V strong pullup with five devices on the bus.  It
works fine.  Two ds18b20 temperature sensors and two thermochron
iButton sensors.  I have maybe 20 feet of wire with a fork near the
ds2490.

It is the 12V programming pulse that is limited to one device and a
shorter wire.  This is the 5V strong pullup, and it doesn't have any
cautions.  The data wire is already working at 5V, it is just the
amount of current that can be supplied increases.

While I agree it is good to have an option to disable it, as it is
optional, what is your reasoning to opposed it?  The ds2490
specification describes in the active pullup section that when the bus
is low and the desired state is high it will start first by the weak
pullup, then when the voltage reaches 0.25V it will switch on the
strong pullup, and VD-1.75V to VDD -0.3V it will set a timer to
disable the strong pullup.  So it is already being used on the bus.

> David, thanks a lot for your work on w1 drivers.
>=20
> --=20
> 	Evgeniy Polyakov

--=20
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIApK7AI852cse6PARApvxAKCuvk6W6k7p4oqsHil/F4udi1iLaQCgvwQV
qdwF+CBtoFdXbBtbF9nPNeU=
=sYiX
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
