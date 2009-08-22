Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZHVOQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZHVOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 10:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZHVOQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 10:16:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34574 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbZHVOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 10:16:56 -0400
Date: Sat, 22 Aug 2009 15:16:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Felipe Balbi <me@felipebalbi.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Message-ID: <20090822141646.GA5812@sirena.org.uk>
References: <1249986616.5807.28.camel@odin>
 <20090811204914.GB13969@gandalf>
 <20090811223645.GA4691@sirena.org.uk>
 <20090814163201.GB1626@ucw.cz>
 <20090815164324.GA4252@sirena.org.uk>
 <20090815223434.GB27637@elf.ucw.cz>
 <20090816091858.GB12567@sirena.org.uk>
 <20090822092845.GE11448@elf.ucw.cz>
 <20090822101641.GC4344@sirena.org.uk>
 <20090821140126.GA1328@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821140126.GA1328@ucw.cz>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Smart Battery System Design (was: Re: Question about
 userspace-consumer)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 04:01:26PM +0200, Pavel Machek wrote:
> On Sat 2009-08-22 11:16:42, Mark Brown wrote:

> > Like you say this is a very old design but even there I'm fairly
> > surprised it's causing issues when charging from a wall supply.  If
> > you're charging from USB then there is obviously a constraint on the
> > power draw but normally a modern system has sufficiently low power draw
> > when idle that it's not actually a big deal - runtime power management
> > facilities have improved greatly.

> Well... all the hardware I have here (zaurus, openmoko, htc dream) has
> issues with power consumption while charging... so I do not think
> runtime pm is solved problem.

The Zaurus and OpenMoko aren't exactly modern designs.  The Dream does
surprise me, though.  I can't find any references to issues with this -
any pointers?  If the phone were actually in use I'd expect it to have
trouble charging off USB but sitting idle it's a lot more surprising,
especially running Android.

> While crashes during suspend/resume are common on pcs, embedded
> systens do better. And crashes during runtime happen, too.

Not really; the situation is similar in both cases - if your hardware is
well supported then everything will generally run smoothly.  If your
hardware is not so well supported then things get more interesting.
It's probably fair to say that it's easier to fix embedded systems that
don't work (and as a result to find existing ones that work well) but
it's not massively different, especially if you're working with things
like reference hardware for new devices.

> First, I can't imagine system where you can damage the battery by just
> crashing sw. 4.2 per cell voltage limit is just too easy to do in
> hw. Maybe if you crash the sw then bring the machine outside while its
> stil on charger and theres 110F outside...

Remember that the goal here is to pull the charging algorithm out of the
charger where it currently is and base it on data supplied by the
battery instead.  If SBS is implemented in software it's not clear that
the charger is going to be able to do anything for itself except
possibly shut off if it or the battery goes over temperature (since SBS
does require NTC those should both be possible).

> And yes it should have safety features, and if they are not there its
> broken hw.

That's not unambiguously clear.  Even with current charger designs some
of the safety comes from appropriate configuration being provided to the
hardware by software - things like the maximum charging current which
the design can sustain.  The unavoidable safety limits provided by the
components tend to be high and while they should prevent catastrophic
issues you normally don't want to be relying on them during normal
operation.
