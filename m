Return-Path: <linux-kernel-owner+w=401wt.eu-S1761555AbYB2Ujk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761555AbYB2Ujk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYB2Ujb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:39:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43274 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbYB2Uja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:39:30 -0500
Date: Fri, 29 Feb 2008 21:39:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Simon Huggins <huggie@earth.li>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080229203914.GD27212@elte.hu>
References: <20080229115256.GG24533@paranoidfreak.co.uk> <20080229133433.GA15532@elte.hu> <20080229135137.GA23781@elte.hu> <20080229140024.GA26342@elte.hu> <20080229115256.GG24533@paranoidfreak.co.uk> <20080229133433.GA15532@elte.hu> <20080229193951.GI24533@paranoidfreak.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229193951.GI24533@paranoidfreak.co.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Huggins <huggie@earth.li> wrote:

> Hi Ingo,
> 
> (please cc me again)
> 
> On Fri, Feb 29, 2008 at 02:34:33PM +0100, Ingo Molnar wrote:
> > * Simon Huggins <huggie@earth.li> wrote:
> > > [ Please Cc me on replies ]
> > > I had a bug with sdhci which Pierre Ossman looked at for me.
> > > In the end essentially the fix was to use HZ=1000 and nothing else. 
> > > Pierre seemed to think that this was a bug in the scheduler.
> > does the patch below help, even if you keep HZ=100? This doesnt look 
> > like a scheduler issue, it's more of a timer/timing issue. Different HZ 
> > means different msleep() results - and the mmc code does a loop of small 
> > msleep delays.
> 
> Thanks for looking at it.
> 
> I did tests with 2.6.24.3 with HZ=1000 and HZ=100 and as expected the
> latter didn't work.
> 
> > -------------->
> > ---
> >  drivers/mmc/core/core.h |    7 +------
> >  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> > Index: linux/drivers/mmc/core/core.h
> > ===================================================================
> > --- linux.orig/drivers/mmc/core/core.h
> > +++ linux/drivers/mmc/core/core.h
> > @@ -36,12 +36,7 @@ void mmc_set_timing(struct mmc_host *hos
> 
> >  static inline void mmc_delay(unsigned int ms)
> >  {
> > -	if (ms < 1000 / HZ) {
> > -		cond_resched();
> > -		mdelay(ms);
> > -	} else {
> > -		msleep(ms);
> > -	}
> > +	mdelay(ms);
> >  }
> 
> >  void mmc_rescan(struct work_struct *work);
> 
> That doesn't work.  I did a test with HZ=100 and this patch.  I've 
> attached the log as patch1-log.

> Anything else I can try?

so neither precise, nor imprecise timings help??

	Ingo
