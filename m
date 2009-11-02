Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbZKBUBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbZKBUBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234AbZKBUBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:01:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38533 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231AbZKBUBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:01:39 -0500
Date: Mon, 2 Nov 2009 21:01:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [patch] Re: [regression bisect -next] BUG: using
	smp_processor_id() in preemptible [00000000] code: rmmod
Message-ID: <20091102200133.GB4682@elte.hu>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com> <1256805552.7158.22.camel@marge.simson.net> <20091029091411.GE22963@elte.hu> <1256807967.7158.58.camel@marge.simson.net> <1256813310.7574.3.camel@marge.simson.net> <20091102182808.GA8950@elte.hu> <1257190811.19608.2.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257190811.19608.2.camel@marge.simson.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Mon, 2009-11-02 at 19:28 +0100, Ingo Molnar wrote:
> > FYI, non-SMP builds broke:
> > 
> > kernel/built-in.o: In function `kthread_bind':
> > (.text+0x1d328): undefined reference to `sched_kthread_bind'
> > make: *** [.tmp_vmlinux1] Error 1
> 
> Oops.  Outside the SMP block might work a little better.
> 
> sched: Move the body of kthread_bind() to sched.c.

Check the -tip commit notification, i did a somewhat cleaner approach by 
moving all of kthread_bind() into sched.c. No need to keep that small 
wrapper in kthread.c.

Thanks,

	Ingo
