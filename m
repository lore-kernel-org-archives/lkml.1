Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbXFLFkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbXFLFkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXFLFkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:40:37 -0400
Received: from spock.bluecherry.net ([66.138.159.248]:2377 "EHLO
	spock.bluecherry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbXFLFkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:40:36 -0400
Date: Tue, 12 Jun 2007 01:40:31 -0400
From: "Zephaniah E. Hull" <warp@aehallh.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Message-ID: <20070612054031.GY6362@aehallh.com>
Mail-Followup-To: Dmitry Torokhov <dtor@insightbb.com>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070609084800.GR6362@aehallh.com> <200706120120.00494.dtor@insightbb.com> <20070612052316.GX6362@aehallh.com> <200706120135.06428.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cbvl/UgeRTPlujdB"
Content-Disposition: inline
In-Reply-To: <200706120135.06428.dtor@insightbb.com>
X-Notice-1: Unsolicited Commercial Email (Aka SPAM) to ANY systems under
X-Notice-2: our control constitutes a $US500 Administrative Fee, payable
X-Notice-3: immediately.  By sending us mail, you hereby acknowledge that
X-Notice-4: policy and agree to the fee.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Cbvl/UgeRTPlujdB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 12, 2007 at 01:35:05AM -0400, Dmitry Torokhov wrote:
> On Tuesday 12 June 2007 01:23, Zephaniah E. Hull wrote:
> > On Tue, Jun 12, 2007 at 01:19:59AM -0400, Dmitry Torokhov wrote:
> > > 
> > > Like I said I would love if xf86-input-evdev did not grab the
> > > device at all.
> > 
> > We have to disable the legacy input handlers somehow, not doing so
> > simply isn't an option.
> 
> I do not follow. If user's xorg.conf does not use /dev/input/mice and
> does not use "kbd" driver then grabbing is not required, is it? Now,
> as far as I understand, lack of hotplug support in X is the main
> obstacle for removing "mouse" and "kbd" drivers, correct?

Sadly, not quite.

The problem is that if the user is not using the mouse and kbd drivers
at all, but is instead using xf86-input-evdev, and no grabbing is done,
then all key presses end up going to the console.

Consider the effects of this when using things like alt-f1 or ctrl-c in
a program in X.

We have to keep the console itself from getting the events in question,
which means either unbinding the kbd interface, or some other sort of
grab, otherwise xf86-input-evdev is completely unusable for keyboards.

Grab support was my initial approach to the problem, in hindsight it
wasn't the right one, but it worked, and it's still needed for the
multi-seat people.
>  
> > > 
> > > But rfkill-input is not a legacy handler. My objection is that with your
> > > solution you still will rob handlers such rfkill-input of events.
> > 
> > Urgh.
> > 
> > So, any thoughts on how to identify legacy input handlers in the input
> > system?
> 
> I guess keyboard and mousedev will have to be flagged as such in kernel.

Ugly, but it works.
> 
> -- 
> Dmitry
> 

-- 
	  1024D/E65A7801 Zephaniah E. Hull <warp@aehallh.com>
	   92ED 94E4 B1E6 3624 226D  5727 4453 008B E65A 7801
	    CCs of replies from mailing lists are requested.

"Microsoft is a cross between the Borg and the Ferengi.  Unfortunately,
they use Borg to do their marketing and Ferengi to do their
programming."
  -- Simon Slavin in asr

--Cbvl/UgeRTPlujdB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGbjHORFMAi+ZaeAERApTsAJ0brF1W1vIjQfIrZS12VzdBIlqwnQCgn6y6
vzw/YFSeER/CseCWH6lNEvw=
=zMIY
-----END PGP SIGNATURE-----

--Cbvl/UgeRTPlujdB--
