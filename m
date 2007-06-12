Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbXFLFM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbXFLFM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXFLFMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:12:19 -0400
Received: from spock.bluecherry.net ([66.138.159.248]:1561 "EHLO
	spock.bluecherry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbXFLFMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:12:18 -0400
Date: Tue, 12 Jun 2007 01:12:10 -0400
From: "Zephaniah E. Hull" <warp@aehallh.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Message-ID: <20070612051210.GW6362@aehallh.com>
Mail-Followup-To: Dmitry Torokhov <dtor@insightbb.com>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070609084800.GR6362@aehallh.com> <200706120107.13655.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7a4X6VOqfbl9xMrG"
Content-Disposition: inline
In-Reply-To: <200706120107.13655.dtor@insightbb.com>
X-Notice-1: Unsolicited Commercial Email (Aka SPAM) to ANY systems under
X-Notice-2: our control constitutes a $US500 Administrative Fee, payable
X-Notice-3: immediately.  By sending us mail, you hereby acknowledge that
X-Notice-4: policy and agree to the fee.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--7a4X6VOqfbl9xMrG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 12, 2007 at 01:07:13AM -0400, Dmitry Torokhov wrote:
> Hi Zephaniah,
>=20
> On Saturday 09 June 2007 04:48, Zephaniah E. Hull wrote:
> > EVIOCGRAB is nice and very useful, however over time I've gotten
> > multiple requests to make it possible for applications to get events
> > straight from the event device while xf86-input-evdev is getting events
> > from the same device.
> >=20
> > Here is the least invasive patch I could think of, it changes the
> > behavior of EVIOCGRAB in some cases, specificly behavior is identical if
> > the argument is 0 or 1, however if the argument is true and !=3D 1, then
> > it does a 'non exclusive grab', a better name might be handy.
> >=20
> > What this does is allow the events to go to everything that's using
> > evdev to get events, but grabs it from anything else. =A0About as close=
 to
> > what people want as I can get, and fairly non-invasive.
>=20
> Unfortunately this also robs non-legacy input handlers (such as
> rfkill-input) of input events. Does xf86-input-evdev really needs to
> grab devices exclusively? I guess we can't abandon the standard
> keyboard driver until X supports hotplugging. How close is it to
> support devices coming and going?

Er, to explain.

The current EVIOCGRAB does an exclusive grab that prohibits rfkill-input
and friends from working.

As it is the only way to disable the legacy input handlers,
xf86-input-evdev has been using it since we added it.

The patch is to let us cause only things that use /dev/input/event<n> to
get events, thus, a non-exclusive grab.

This basicly disables the legacy input handlers, and it's the least
invasive patch I could think of.

Going for a separate ioctl would also work, but in some ways it would
make supporting it more of a pain.

I don't care _that_ much either way, as long as we can get a way to
disable the legacy events while allowing other things to get the events
too.

Zephaniah E. Hull.
> =20
> If we can't remain as is until X hotplug is ready then I'd rather had
> a separate ioctl that disables legacy input handlers (keyboard, mousedev)
> for a given input device.
>=20
> --=20
> Dmitry
>=20

--=20
	  1024D/E65A7801 Zephaniah E. Hull <warp@aehallh.com>
	   92ED 94E4 B1E6 3624 226D  5727 4453 008B E65A 7801
	    CCs of replies from mailing lists are requested.

Welcome to [telco] hell. [...] You are in a maze of twisty little PVC's,
all alike.  A switching engineer throws a dart at you!
    -- Chris Saunderson <saundo@idx.com.au> in the scary.devil.monastery

--7a4X6VOqfbl9xMrG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGbispRFMAi+ZaeAERAtJgAKDMeJrSesiOx9RcVJ17Hfz9N0ehEwCgrkR1
6M9S5wA3MjWJojxYEx4JwMQ=
=p+PJ
-----END PGP SIGNATURE-----

--7a4X6VOqfbl9xMrG--
