Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbXKPGNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbXKPGNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 01:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXKPGNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 01:13:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbXKPGNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 01:13:44 -0500
Date: Fri, 16 Nov 2007 07:13:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: disable preemption in delay_tsc()
Message-ID: <20071116061332.GF16273@elte.hu>
References: <200711150400.lAF40lIr020160@hera.kernel.org> <20071115194116.12c7a0f6@laptopd505.fenrus.org> <20071115195234.2dc8406d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115195234.2dc8406d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > >     x86: disable preemption in delay_tsc()
> > >     
> > >     Marin Mitov points out that delay_tsc() can misbehave if it is 
> > > preempted and rescheduled on a different CPU which has a skewed 
> > > TSC. Fix it by disabling preemption.
> > >  
> > 
> > this worries me.. this appears to effectively disable preemption 
> > during udelay() and mdelay() loops... which are very obvious latency 
> > inducers.
> > 
> > Now you can argue that if you're preemptible you should have used 
> > msleep() and co, and I'll totally buy that.
> > 
> > 
> > Maybe we should just check if we're still on the same cpu or 
> > something, or have a cheap way to pin a process to a cpu.... but 
> > both are longer term solutions.
> 
> Yes, we can do better.
> 
> But this bug can cause very rare failures in probably a large number 
> of device drivers on a minorty of machines.  Ugly.  So I felt it best 
> to plug it fast while people think about more sophisticated fixes.

how about using usleep() transparently if high-res timers are active and 
we have !preempt_count()? That would be a sufficient solution and would 
avoid all the calibration and per-cpu-ness problems.

	Ingo
