Return-Path: <linux-kernel-owner+w=401wt.eu-S935555AbXJPTPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935555AbXJPTPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764395AbXJPTPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:15:46 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:39297
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765124AbXJPTPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:15:45 -0400
Date: Tue, 16 Oct 2007 12:13:23 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Dave Young <hidave.darkstar@gmail.com>,
       bbpetkov@yahoo.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] usb+sysfs: duplicate filename 'bInterfaceNumber'
Message-ID: <20071016191323.GC24082@one-eyed-alien.net>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Greg KH <greg@kroah.com>, Dave Young <hidave.darkstar@gmail.com>,
	bbpetkov@yahoo.de,
	Kernel development list <linux-kernel@vger.kernel.org>,
	USB development list <linux-usb-devel@lists.sourceforge.net>
References: <20071016163348.GB24082@one-eyed-alien.net> <Pine.LNX.4.44L0.0710161355150.9662-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0710161355150.9662-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2007 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 16 Oct 2007 12:13:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 16, 2007 at 02:04:43PM -0400, Alan Stern wrote:
> On Tue, 16 Oct 2007, Matthew Dharm wrote:
>=20
> > I haven't looked at this code at all, but neither approach feels right =
to
> > me.
> >=20
> > How does this work at all?  Even if you load a driver later, wouldn't it
> > call usb_set_interface(), which would call usb_create_sysfs_intf_files()
> > and hit the same issue?
>=20
> usb_set_interface() is smart enough to remove the old interface files
> before creating new ones, since it expects them to exist already. =20
> Hence there's no problem in that scenario.
>=20
> But usb_set_configuration doesn't expect there to be any pre-existing
> interface files, because there isn't even an interface until the
> registration is performed.

And I'm guessing that you can't call usb_create_sysfs_intf_files() until
registration is performed, right?

> The most important reason has to do with the endpoint pseudo-devices. =20
> Different altsettings can have different endpoints, so those have to be
> removed and re-created whenever the altsetting changes.

Right, altsettings.  I forgot about those.  I only ever think in terms of
multiple configurations.

*grumble*

If usb_set_interface() has to be smart enough to remove existing files
first already, then I guess it's reasonably symmetric to have
usb_set_configuration() have the same smarts.  Maybe they can share some
common code, even.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

C:  Why are you upgrading to NT?
AJ: It must be the sick, sadistic streak that runs through me.
					-- Chief and A.J.
User Friendly, 5/12/1998

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHFQ1THL9iwnUZqnkRAlQ5AKClGtzLNuHpy7uYWq+qXunNhwi3fQCfQrOd
RzharJABp+pgciis5sO3RZA=
=2jfu
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--
