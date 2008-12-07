Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYLGJa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYLGJa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 04:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYLGJaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 04:30:13 -0500
Received: from balanced.mail.policyd.dreamhost.com ([208.97.132.119]:55720
	"EHLO spunkymail-a12.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752443AbYLGJaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 04:30:11 -0500
From: Yuval Hager <yuval@avramzon.net>
To: Peter Stuge <peter@stuge.se>
Subject: Re: BCM4312 Fails when xdm is started
Date: Sun, 7 Dec 2008 11:29:27 +0200
User-Agent: KMail/1.9.9
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Michael Buesch <mb@bu3sch.de>,
       bcm43xx-dev@lists.berlios.de
References: <200811151801.02369.yuval@avramzon.net> <200811250745.22487.yuval@avramzon.net> <20081125071818.9256.qmail@stuge.se>
In-Reply-To: <20081125071818.9256.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4664892.LXOuEnOpdx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812071129.32113.yuval@avramzon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4664892.LXOuEnOpdx
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 25 November 2008, Peter Stuge wrote:
> Yuval Hager wrote:
> > I played around with different video drivers and the results are:
> > * If using the 'via' driver, I lose the PCIe card immediately upon
> >   initialization
> > * Using the 'openchrome' (trunk version), It works well in the
> >   beginning.
> >   After first blanking the register reads are all 1's, and then
> >   when the screen is blank I get a different read (some registers
> >   are correct, some are wrong), and when the screen is unblanked, I
> >   get 0xff's again. Very consistent and predictabe (same read every
> >   time).
> > * Using the 'vesa' driver I could not recreate the problem. I could
> >   not get the screen to blank for some reason, but closing the lid,
> >   going on standby/hibernate, restarting X - all didn't matter much
> >   to the PCI and the wireless card kept on working.
>
> Good work! You have beyond any doubt established that the X graphics
> driver can cause this problem.
>

This issue has been tracked down to be at the openchrome driver. It appears=
=20
that somehow it corrupted the PCI bus, and damaged the device right after t=
he=20
video card - the wireless card.=20

The current workaround for this is here -=20
http://wiki.openchrome.org/pipermail/openchrome-devel/2008-November/000139.=
html -=20
but this is just a quick hack, not a fix, although it works great for me. T=
he=20
openchrome team is working on a patch based on this.

Thanks for all the help - I am a very happy HP2133 user, and a very happy=20
community member. This was an amazing opensource support experience, which=
=20
I'll remember for a long time. Thank you all!

Cheers,

=2D-=20
Yuval Hager
[@] yuval@avramzon.net

--nextPart4664892.LXOuEnOpdx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk7l3wACgkQl7qmwPqEj9/YZgCaA52S5eURCyNoRQZWKSgL4dXD
1M4AnR1Dcr/XB0c2qfLRZR0anmb9r7K4
=Y056
-----END PGP SIGNATURE-----

--nextPart4664892.LXOuEnOpdx--
