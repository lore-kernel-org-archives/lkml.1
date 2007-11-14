Return-Path: <linux-kernel-owner+w=401wt.eu-S1762103AbXKNEji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103AbXKNEji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbXKNEj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:39:29 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:38405
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754534AbXKNEj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:39:28 -0500
Date: Tue, 13 Nov 2007 20:39:23 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Greg KH <greg@kroah.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bk@suse.de, khali@linux-fr.org
Subject: Re: 2.6.24-rc2-mm1
Message-ID: <20071114043923.GK6089@one-eyed-alien.net>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Gabriel C <nix.or.die@googlemail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, bk@suse.de, khali@linux-fr.org
References: <473A678C.2020507@googlemail.com> <20071114034924.GA26048@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wIc/V6YLA2QdyfT4"
Content-Disposition: inline
In-Reply-To: <20071114034924.GA26048@kroah.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2007 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 13 Nov 2007 20:39:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--wIc/V6YLA2QdyfT4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13, 2007 at 07:49:24PM -0800, Greg KH wrote:
>=20
> Matt, are these the errors you were worried about with the patch we were
> just talking about tha tis in my tree?

I can't tell from these logs.

The key question (in relation to the allow_restart patch) is this:  Was
everything working fine until a START_STOP was sent to the device?

The SCSI layers used to send devices START_STOP to almost every device as
part of initialization.  I think we switched all of that to use
TEST_UNIT_READY instead.

The patch you've got should re-enable START_STOP to be sent.  The SCSI
layers (I'm told, but haven't verified myself) only send START_STOP if the
device reports that it needs a startup command.

CONFIG_USB_STORAGE_DEBUG will generate a *lot* of debug output.  But, it
should be pretty easy to see if START_STOP was sent at all, and if it
caused the problems.

Matt

P.S. Worst case, the issue we're talking about here would only cause the
device firmware to crash, which would eventually lead to a disconnect.
That shouldn't have caused the much more severe problems shown in the log
you sent.

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

DP: And judging from the scores, Stef has the sma... =20
T:  LET'S NOT GO THERE!
					-- Dust Puppy and Tanya
User Friendly, 12/11/1997

--wIc/V6YLA2QdyfT4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHOnv7HL9iwnUZqnkRAtobAKCei6IOdRUhI+raOAxlH0J0+uCwkgCfS70a
x0BIH8kdm6sMKVVCoec8V/s=
=ZvFb
-----END PGP SIGNATURE-----

--wIc/V6YLA2QdyfT4--
