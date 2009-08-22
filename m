Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZHVKQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZHVKQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 06:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbZHVKQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 06:16:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53961 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbZHVKQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 06:16:51 -0400
Date: Sat, 22 Aug 2009 11:16:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Felipe Balbi <me@felipebalbi.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Message-ID: <20090822101641.GC4344@sirena.org.uk>
References: <20090811054438.GA7176@gandalf>
 <20090811094020.GA6762@rakim.wolfsonmicro.main>
 <1249986616.5807.28.camel@odin>
 <20090811204914.GB13969@gandalf>
 <20090811223645.GA4691@sirena.org.uk>
 <20090814163201.GB1626@ucw.cz>
 <20090815164324.GA4252@sirena.org.uk>
 <20090815223434.GB27637@elf.ucw.cz>
 <20090816091858.GB12567@sirena.org.uk>
 <20090822092845.GE11448@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090822092845.GE11448@elf.ucw.cz>
X-Cookie: You have a truly strong individuality.
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

On Sat, Aug 22, 2009 at 11:28:45AM +0200, Pavel Machek wrote:

> At least zaurus sl-3000c is designed like a notebook -- inactive in
> s2ram. It is quite old design.

> Charging while suspended is preffered, because it allows faster
> charge. The machine eats non-trivial power while active, charger is
> only 1A, and there's not enough current left for a charge with machine
> active.

Like you say this is a very old design but even there I'm fairly
surprised it's causing issues when charging from a wall supply.  If
you're charging from USB then there is obviously a constraint on the
power draw but normally a modern system has sufficiently low power draw
when idle that it's not actually a big deal - runtime power management
facilities have improved greatly.

Some integrated PMICs will even refuse to do a fast charge when the
system is fully suspended, if only because the suspend mode of the PMIC
is intended to drive the power consumption from the PMIC itself down to
the very lowest level possible.

> > the main motiviation for going into suspend.  Also bear in mind that a
> > soft SBS system requires constant activity from the CPU for basic
> > management of the charge cycle so suspend isn't going to be a real
> > option anyway, you'd be suspending for seconds at a time.

> Well, if the code is to be useful for something else than SBS... (And
> suspending for seconds at a time is okay on zaurus type machines).

It's not too bad but it's not great either - without the ability to do
things like per-device suspend during runtime (which I see is coming
along but it's not there yet) some systems end up spending a lot of the
time on bouncing the power.

There's also the fact that if you're completely reliant on the CPU to
control the charger you have to be very sure that the system will come
back from suspend reliably due to the risk of hardware damage.  The
hardware should have safety features to prevent serious problems but
it's a consideration.
