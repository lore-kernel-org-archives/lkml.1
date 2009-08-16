Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbZHPJTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbZHPJTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZHPJTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:19:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56210 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZHPJTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:19:07 -0400
Date: Sun, 16 Aug 2009 10:18:59 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Felipe Balbi <me@felipebalbi.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Message-ID: <20090816091858.GB12567@sirena.org.uk>
References: <20090810200553.GB4652@gandalf>
 <20090810215800.GB4528@sirena.org.uk>
 <20090811054438.GA7176@gandalf>
 <20090811094020.GA6762@rakim.wolfsonmicro.main>
 <1249986616.5807.28.camel@odin>
 <20090811204914.GB13969@gandalf>
 <20090811223645.GA4691@sirena.org.uk>
 <20090814163201.GB1626@ucw.cz>
 <20090815164324.GA4252@sirena.org.uk>
 <20090815223434.GB27637@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090815223434.GB27637@elf.ucw.cz>
X-Cookie: (null cookie
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

On Sun, Aug 16, 2009 at 12:34:34AM +0200, Pavel Machek wrote:
> On Sat 2009-08-15 17:43:24, Mark Brown wrote:

> > > * you want to fastcharge while machine is in s2ram. See spitz. Doing
> > >   that with userspace would be quite tricky.

> > Depending on the technologies involved and how well integrated the power
> > path management is with the battery charger fast charge during suspend
> > may not actually be desirable.  Some systems need or desire active
> > thermal management of the system from the CPU during fast charge.

> Do you have example of some system?

I don't know why any of these are charging while active but things like
the Nokia internet tablets and the smartphones I've used recently all
keep the phone active while charging.  Quite a few PMICs will refuse to
charge when suspended.

> Ok, well... anyway many machines _want_ fastcharge while suspended,
> and putting charging into userland would break them (or make that
> fairly difficult).

Are you sure that's a real need?  Disabling user interaction I can see
but forcing the system into sleep doesn't seem to be any particular
benefit - devices like this tend to be designed to appear to be always
on and clearly when fast charging there's no need to save power which is
the main motiviation for going into suspend.  Also bear in mind that a
soft SBS system requires constant activity from the CPU for basic
management of the charge cycle so suspend isn't going to be a real
option anyway, you'd be suspending for seconds at a time.
