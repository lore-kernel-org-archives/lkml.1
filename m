Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYHRTwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYHRTwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763391AbYHRTt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:49:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933477AbYHRTtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:49:25 -0400
Date: Mon, 18 Aug 2008 12:47:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       johnstul@us.ibm.com, hirofumi@mail.parknet.co.jp,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, andi@lisas.de
Subject: Re: [git pull?] clocksource: ACPI pmtmr bugfixes [Was: Re: ACPI
 PM-Timer on K6-3 SiS5591: Houston...]
Message-Id: <20080818124755.162f24d1.akpm@linux-foundation.org>
In-Reply-To: <20080818193517.GA22097@isilmar.linta.de>
References: <20080810101730.GA10024@rhlx01.hs-esslingen.de>
	<20080810162920.GA9860@comet.dominikbrodowski.net>
	<20080810190759.GA1879@rhlx01.hs-esslingen.de>
	<20080818190325.GA12581@comet.dominikbrodowski.net>
	<20080818121924.6b61f7af.akpm@linux-foundation.org>
	<20080818193517.GA22097@isilmar.linta.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 21:35:17 +0200
Dominik Brodowski <linux@dominikbrodowski.net> wrote:

> Hi Andrew,
> 
> On Mon, Aug 18, 2008 at 12:19:24PM -0700, Andrew Morton wrote:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git clocksource
> > > 
> > > Dominik Brodowski (2):
> > >       acpi_pm.c: use proper read function also in errata mode.
> > >       acpi_pm.c: check for monotonicity
> > > 
> > >  drivers/clocksource/acpi_pm.c |   50 +++++++++++++++++++++++-----------------
> > >  1 files changed, 29 insertions(+), 21 deletions(-)
> > 
> > A bare git URL is somewhat user-unfriendly.
> 
> uh, sorry about that.
> 
> > : commit b985f0517e31c1204b5aafb94f86202948f00e16
> > : Author: Dominik Brodowski <linux@dominikbrodowski.net>
> > : Date:   Sun Aug 10 21:24:21 2008 +0200
> > : 
> > :     acpi_pm.c: use proper read function also in errata mode.
> > :     
> > :     When acpi_pm is used in errata mode (three reads instead of one), also the
> > :     acpi_pm init functions need to use three reads instead of just one.
> > 
> > hm, why?  Was there some observeable problem which this change improved?
> 
> Indeed: on all affected hardware (some Intel ICH4, PIIX4 and PIIX4E chipsets)
> there's about a 4.2% chance that initialization of the ACPI PMTMR fails. On
> those chipsets, we need to read out the timer value at least three times to
> get a correct result, for every once in a while (i.e. within a 3 ns window
> every 69.8 ns) the read returns a bogus result. During normal operation we
> work around this issue, but during initialization reading a bogus value may
> lead to -EINVAL even though the hardware is usable.

That would be useful stuff for the changelog.

> > :     acpi_pm.c: check for monotonicity
> > :     
> > :     Expand the check for monotonicity by doing ten tests instead of one.
> > 
> > Why?
> 
> Indeed: http://lkml.org/lkml/2008/8/10/77 -- quote:
> "Result: catastrophic timer behaviour (a large backwards skip is possible),"
> 
> The current check for monotonicity is way too weak. And at least on one
> system out there PMTMR is unuseable, but the current check fails.

yeah, that does look like 2.6.27 material.  And possibly 2.6.26.x and
2.6.25.x?

> > I guess this file falls under Thomas's git-hrt tree.  I can queue the
> > patches up and spam Thomas with them, but I'm at a bit of a loss
> > regarding their priority due to the above questions.
> 
> That would be great, thanks.

Could I trouble you to resend them as plain-old-patches, with full
changelogs along with your thoughts about the suitablity for
2.6.2[5678].x please?

I could attempt to put all that together here, but I'd probably end up
with something inappropriate.

Thanks.
