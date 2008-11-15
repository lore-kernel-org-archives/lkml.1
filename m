Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYKOSDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYKOSDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 13:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYKOSDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 13:03:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:32972 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbYKOSDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 13:03:37 -0500
Date: Sat, 15 Nov 2008 10:04:04 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, corsac@debian.org, auke.kok@intel.com
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Message-ID: <20081115100404.6ab1f31d@infradead.org>
In-Reply-To: <200811151816.33209.elendil@planet.nl>
References: <20081104173300.GF6134@ics.muni.cz>
	<alpine.LFD.2.00.0811092226050.12263@localhost.localdomain>
	<200811140245.40505.elendil@planet.nl>
	<200811151816.33209.elendil@planet.nl>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2008 18:16:31 +0100
Frans Pop <elendil@planet.nl> wrote:

> On Friday 14 November 2008, Frans Pop wrote:
> > > Find below the lineup of the timers-fixes-for-linus branch of the
> > > tip tree (the same as Arjan posted minus the irq fixes)
> >
> > Could either of you maybe give a status update on this patch set and
> > the remaining issues with it that were reported (especially the
> > high C0 reported by powertop)?
> 
> I guess part of the answer is:
> commit ae99286b4f1be7788f2d6947c66a91dbd6351eec
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon Nov 10 13:20:23 2008 +0100
>     nohz: disable tick_nohz_kick_tick() for now
> 
> I've just done some testing using v2.6.28-rc4-322-g58e20d8 which
> includes this patch.
> 
> CPU usage reported by powertop is now normal again (close to 100% in 
> lowest C state), but I'm still getting high counts for:
> - <kernel IPI> : Rescheduling interrupts
>   Typically 3-5 on .26/.27; 15-17 on .28.

these are caused by the scheduler, not by the timer code.
(And sometimes they're caused by the scheduler on behalf of something
else even)

> - <interrupt>  : extra timer interrupt
>   Consistently more prominent for .28 (though not with high values)

if it's less than 5 total, don't worry about it, some of that can well
be rounding/measurement effects
(powertop has to make a few approximations around the edges of the
measurement interval because things don't always line up perfectly)

>   than for .27, but way better than for .26.
> 
> 
> powertop questions
> ------------------
> - What's with this change from "polling" to "C0" for the 2nd C state?

that sounds like an interesting bug...

>   After boot I always (both when booted on mains and on battery) get
>   "polling", but after inserting or removing mains it will continue to
>   show "C0" independent of any further power state changes.
> - After switching to battery the first time I get something like:
>   C1                0.0ms (614891469122.
>   This is reproducible. I guess a rounding error due to the change in
>   the number of C states. Later updates clear this.

yeah it's annoying but it is only for one display period

> - Looks like someone could not make up his mind between comma and
> slash here: "(long term: 26.2W,/1.6h)"

that sounds easy to fix ;-)

Thanks for the bugreports; either me or Auke will take a look at these
shortly.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
