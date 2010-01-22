Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106Ab0AVH0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab0AVH0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 02:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999Ab0AVH0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 02:26:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51107 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab0AVH0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 02:26:08 -0500
Date: Fri, 22 Jan 2010 08:25:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Anton Blanchard <anton@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf: Fix inconsistency between IP and callchain sampling
Message-ID: <20100122072547.GB9599@elte.hu>
References: <20100118054707.GT12666@kryten>
 <20100118104305.GA5256@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118104305.GA5256@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Concerning interrupts that happen in idle, I think we should filter these if 
> exclude_idle = 1. That looks more something a user may want: if we don't 
> want to profile idle, neither do we want to encumber with interrupts that 
> occur inside. On the opposite, if someone wants a finegrained profile, let's 
> get idle and its interrupts.
> 
> What do you guys think about that?

Another, related thing i'd _love_ to see implemented is per IRQ level 
filtering of both samples and statistics.

This would allow two nice things:

 - the reporting of IRQ (and softirq/tasklet) contexts as separate entites by
   perf report

 - a 'no IRQ related noise' mode for perf task perf stat, like the
   user/kernel/hypervisor bits already do, just extended to irqs as well. This 
   would make 'perf stat --repeat 10 /bin/true' _much_ less noisy, and could 
   be used even more to assess the performance impact of kernel patches. 
   Currently IRQs that hit task execution get added to the task's overhead, 
   which makes the numbers both skewed and noisier.

(The do_IRQ() callbacks are needed because most PMUs cannot stop counters when 
we enter/exit IRQ/softirq state, so we have to turn counter off/on on irq 
entries.)

	Ingo
