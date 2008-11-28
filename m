Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbYK1Oky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbYK1Oky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 09:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYK1Okq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 09:40:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54498 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYK1Okp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 09:40:45 -0500
Date: Fri, 28 Nov 2008 15:40:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ron <ron@debian.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [patch] fix for sched_clock() when using jiffies
Message-ID: <20081128144039.GG28138@elte.hu>
References: <20081126150645.GA28153@homer.shelbyville.oz> <1227712598.4454.199.camel@twins> <20081126153152.GB28153@homer.shelbyville.oz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126153152.GB28153@homer.shelbyville.oz>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

* Ron <ron@debian.org> wrote:

> On Wed, Nov 26, 2008 at 04:16:38PM +0100, Peter Zijlstra wrote:
> > On Thu, 2008-11-27 at 01:36 +1030, Ron wrote:
> > > Hi,
> > > 
> > > I'm in the process of updating a port for an ARM based chip we've been
> > > working on, from 2.6.22-rc4'ish to the current HEAD of Linus' tree, and
> > > I started seeing the following:
> > > 
> > > [    0.000000] PID hash table entries: 512 (order: 9, 2048 bytes)
> > > [42949372.970000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> > > 
> > > The reason appears to be that printk_clock() has been replaced with a
> > > call to cpu_clock, which in our case currently falls back to the default
> > > (weak) implementation of sched_clock() that uses jiffies -- but doesn't
> > > account for the initial offset of the jiffy count.  The following simple
> > > patch fixes it for me, in line with what printk_clock used to do.
> > > 
> > 
> > Looks good, except I suspect this line will now be longer than 80
> > characters and you forgot to provide your signed-off-by line.
> 
> diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
> index 8178724..1ce2e53 100644
> --- a/kernel/sched_clock.c
> +++ b/kernel/sched_clock.c
> @@ -37,7 +37,8 @@
>   */
>  unsigned long long __attribute__((weak)) sched_clock(void)
>  {
> -       return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
> +       return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> +                                  * (NSEC_PER_SEC / HZ);
>  }
>  
>  static __read_mostly int sched_clock_running;
> 
> 
>  Signed-off-by: Ron Lee <ron@debian.org>

whitespace damage: all tabs are space.

please see Documentation/email-clients.txt for how to send patches.

Also, when you resend a patch, do it without quotes and by including the 
fill commit log again - to make it easier to apply it. (and not forcing 
me to cut&paste various emails - it's fundamentall error-prone)

	Ingo
