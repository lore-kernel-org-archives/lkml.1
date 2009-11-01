Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbZKARwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbZKARwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 12:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZKARwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 12:52:41 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:40430
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044AbZKARwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 12:52:40 -0500
Date: Sun, 1 Nov 2009 09:52:16 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, nut-upsuser@lists.alioth.debian.org,
       bruce.w.allan@intel.com, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.31.4: Intel P55 Chipset BUG [usbhid-raw/devices/broken?] [tested 3 different UPS']
Message-ID: <20091101175216.GA24436@one-eyed-alien.net>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	nut-upsuser@lists.alioth.debian.org, bruce.w.allan@intel.com,
	Alan Piszcz <ap@solarrain.com>
References: <alpine.DEB.2.00.0910311847530.5522@p34.internal.lan> <Pine.LNX.4.44L0.0911011151270.399-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0911011151270.399-100000@netrider.rowland.org>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2009 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Sun, 01 Nov 2009 09:52:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 01, 2009 at 12:11:44PM -0500, Alan Stern wrote:
> On Sat, 31 Oct 2009, Justin Piszcz wrote:
>=20
> > 1. 5 minutes of usbmon output on via chipset [working]
> > 2. 5 minutes of usbmon output on intel p55 usb chipset [ehci/not workin=
g]
>=20
> To summarize the differences between the logs, the Intel controller=20
> shows occasional instances of failed transfers like this:
>=20
> ffff8802138c8500 3487005687 S Ci:2:004:0 s 81 06 2100 0000 0009 9 <
> ffff8802138c8500 3487006051 C Ci:2:004:0 -32 0
>=20
> while the corresponding transfers worked with the VIA controller:
>=20
> ffff88020c46dd40 1774844264 S Ci:4:002:0 s 81 06 2100 0000 0009 9 <
> ffff88020c46dd40 1774855248 C Ci:4:002:0 0 9 =3D 09211001 21012237 04
>=20
> and indeed they worked in the other Intel logs (the failures appeared
> to be more or less at random).
>=20
> This does indeed look like a low-level hardware problem, but I'm
> hesitant to blame it on the chipset.  For example, the problem might
> lie in the hub you've got between the UPS and the computer.  I know,
> this doesn't explain why everything works okay with the VIA controller.
> Probably the only way to tell for sure what's really happening is by=20
> using an expensive bus analyzer.
>=20
> Have you tried bypassing that hub, and plugging the UPS directly into=20
> the computer?

I think P55 chipset has an integrated hub, which is not removeable.  The
only USB controller is EHCI, and that is connected directly to a hub in the
silicon which provides multiple downstream ports and does the translation
to 1.0 speeds.  So the hub cannot be bypassed.

Two things to note:

1) Not all ports on that silicon are the same.  Specifically, ports 1 and 9
have special properties (related to USB-based debugging).  You should try
other ports (note that I count ports starting at 0).

2) I noticed this article:
http://www.theregister.co.uk/2009/10/30/iphone_p55_problems/ -- this may
suggest that there are other issues with P55 chipset and USB.  According to
this article, as with this reported issue, adding an external USB hub
doesn't help, but an add-in PCI USB card does.  We may have to consider a
P55 issue as a possibility here.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I say, what are all those naked people doing?
					-- Big client to Stef
User Friendly, 12/14/1997

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFK7crQHL9iwnUZqnkRAvM8AJ9BFPMSndGiqpYT/gFGGz5iKi1pswCfUE2t
dTOyGYocn5JgMhHnPV39XiU=
=JCur
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
