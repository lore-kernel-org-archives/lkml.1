Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbXDONEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbXDONEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 09:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXDONEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 09:04:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60386 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbXDONEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 09:04:37 -0400
Date: Sun, 15 Apr 2007 15:04:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Esben Nielsen <nielsen.esben@googlemail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415130416.GA4312@elte.hu>
References: <20070413202100.GA9957@elte.hu> <Pine.LNX.4.64.0704151419140.11750@frodo.shire>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704151419140.11750@frodo.shire>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Esben Nielsen <nielsen.esben@googlemail.com> wrote:

> I took a brief look at it. Have you tested priority inheritance?

yeah, you are right, it's broken at the moment, i'll fix it. But the 
good news is that i think PI could become cleaner via scheduling 
classes.

> As far as I can see rt_mutex_setprio doesn't have much effect on 
> SCHED_FAIR/SCHED_BATCH. I am looking for a place where such a task 
> change scheduler class when boosted in rt_mutex_setprio().

i think via scheduling classes we dont have to do the p->policy and 
p->prio based gymnastics anymore, we can just have a clean look at 
p->sched_class and stack the original scheduling class into 
p->real_sched_class. It would probably also make sense to 'privatize' 
p->prio into the scheduling class. That way PI would be a pure property 
of sched_rt, and the PI scheduler would be driven purely by 
p->rt_priority, not by p->prio. That way all the normal_prio() kind of 
complications and interactions with SCHED_OTHER/SCHED_FAIR would be 
eliminated as well. What do you think?

	Ingo
