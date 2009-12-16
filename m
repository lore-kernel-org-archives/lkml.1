Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbZLPTNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbZLPTNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762968AbZLPTNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:13:20 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:49666
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762929AbZLPTNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:13:17 -0500
Date: Wed, 16 Dec 2009 11:12:50 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Stefan Seyfried <stefan.seyfried@googlemail.com>,
       Josua Dietze <digidietze@draisberghof.de>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Message-ID: <20091216191250.GH16426@one-eyed-alien.net>
Mail-Followup-To: Dan Williams <dcbw@redhat.com>,
	Stefan Seyfried <stefan.seyfried@googlemail.com>,
	Josua Dietze <digidietze@draisberghof.de>,
	Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <4B278191.1010009@draisberghof.de> <200912151611.08576.oliver@neukum.org> <20091215180300.GF16426@one-eyed-alien.net> <20091216114932.4bede511@strolchi.home.s3e.de> <4B28C2F7.7040207@draisberghof.de> <20091216131452.49ad183b@strolchi.home.s3e.de> <1260982037.2179.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ndw/alBWmZEhfcZ"
Content-Disposition: inline
In-Reply-To: <1260982037.2179.5.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2009 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Wed, 16 Dec 2009 11:12:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4ndw/alBWmZEhfcZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 16, 2009 at 08:47:17AM -0800, Dan Williams wrote:
> On Wed, 2009-12-16 at 13:14 +0100, Stefan Seyfried wrote:
> > On Wed, 16 Dec 2009 12:22:31 +0100
> > Josua Dietze <digidietze@draisberghof.de> wrote:
> >=20
> > > Stefan Seyfried schrieb:
> > > > Preferably some code that can be built actually?
> > >=20
> > > If the "eject" from SCSI tools does not work, "usb_modeswitch" can=20
> > > send customized bulk messages to devices.
> >=20
> > for my device, eject seems to be enough, so I'll be trying to get
> > this into udev.
> >=20
> > > http://www.draisberghof.de/usb_modeswitch/
> >=20
> > Unfortunately it cannot be built with current libusb and once you
> > compile it without warnings turned off (which is the default!), you
> > probably don't want to run it anymore ;)
>=20
> At this point, however, usb_modeswitch is the correct place to put eject
> code for all devices.  I wouldn't put this code into udev; I'd put it
> into usb_modeswitch instead, since usb_modeswitch is (a) the de-facto
> standard, (b) has the most users, and (c) has the most devices.  Yes, it
> has problems, but at this point we should fix those problems instead of
> creating 5 different eject tools.

udev just calls either usb_modeswitch or eject at the hotplug event.  So,
you always need an update to the udev database, regardless.

The choice between using usb_modeswitch or eject is really one of "does the
standard eject work properly" or not.  If not, add the code to
usb_modeswitch.  Tho, if the usb_modeswitch maintainers want to carry
around a duplicate set of 'eject' code, that's really up to them.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Would you mind not using our Web server? We're trying to have a game of=20
Quake here.
					-- Greg
User Friendly, 5/11/1998

--4ndw/alBWmZEhfcZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFLKTExHL9iwnUZqnkRAhVIAKCvZxA7Yu3ptFqeAtFwR/NU910bwgCfSetb
Hx+wGUr6qwBpUL97M3CtIhA=
=BQc/
-----END PGP SIGNATURE-----

--4ndw/alBWmZEhfcZ--
