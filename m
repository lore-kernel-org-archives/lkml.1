Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYG3UBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYG3UBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbYG3UAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:00:51 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:54797
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117AbYG3UAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:00:50 -0400
Date: Wed, 30 Jul 2008 13:00:33 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       usb-storage@lists.one-eyed-alien.net, Tomas Styblo <tripie@cpan.org>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [usb-storage] [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device 152d:2338
Message-ID: <20080730200033.GD7578@one-eyed-alien.net>
Mail-Followup-To: Robert Hancock <hancockr@shaw.ca>,
	Alan Stern <stern@rowland.harvard.edu>,
	usb-storage@lists.one-eyed-alien.net,
	Tomas Styblo <tripie@cpan.org>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0807232337110.25883-100000@netrider.rowland.org> <4890C72D.7040604@shaw.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <4890C72D.7040604@shaw.ca>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Wed, 30 Jul 2008 13:00:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2008 at 01:55:25PM -0600, Robert Hancock wrote:
> Alan Stern wrote:
> > On Wed, 23 Jul 2008, Robert Hancock wrote:
> >=20
> >> It remains an issue, though, that if there's no underflow, if the devi=
ce=20
> >> reports an error in the CSW but doesn't provide sense data, we assume=
=20
> >> nothing bad happened and don't retry. That definitely does not seem=20
> >> correct. The device is not supposed to do this, but with how crappily=
=20
> >> some of these devices are designed we should be more defensive.
> >=20
> > The problem is, what can you do?  The device has said that something=20
> > was wrong, but it hasn't told you what.  Without knowing what went=20
> > wrong, you can't know how to recover.

Yes and no.  If ASC/ASCQ is clear, then it's telling you that nothing is
wrong.  The device is contradicting itself. That doesn't really help us
here, but it's a point I like to be clear on.

> > I suppose in such cases we could simply report that the command failed
> > completely.
>=20
> I think that is what we need to do. The SCSI/block layers should retry=20
> the command or report a failure to userspace. Above all else we can't=20
> just continue on our merry way and assume success, otherwise data will=20
> get silently corrupted.

The code path to supress the reporting of an error when auto-sense shows no
ASC/ASCQ was added for a reason.  That reason has likely been lost to time,
but I worry about devices that are out there that rely on the current
behavior to function properly....

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

A:  The most ironic oxymoron wins ...
DP: "Microsoft Works"
A:  Uh, okay, you win.
					-- A.J. & Dust Puppy
User Friendly, 1/18/1998

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIkMhhHL9iwnUZqnkRAhupAKCaoSoLn6vlwakvkODfvnHP3iynbACgkSyO
xXOV9y4/nOQoW1BW6MrhG6c=
=8g2Z
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
