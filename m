Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYKLWQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYKLWQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYKLWQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:16:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35293 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbYKLWQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:16:07 -0500
Date: Wed, 12 Nov 2008 23:15:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function
	return tracer lockless
Message-ID: <20081112221552.GA6125@elte.hu>
References: <491B4F0A.3080901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491B4F0A.3080901@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: remove spinlocks and irq disabling in function return tracer.
> 
> I've tried to figure out all of the race condition that could happen when
> the tracer pushes or pops a return address trace to/from the current
> thread_info.
> 
> Theory:
> 
> _ One thread can only execute on one cpu at a time. So this code doesn't need
>   to be SMP-safe. Just drop the spinlock.
> _ The only race could happen between the current thread and an interrupt. If an
>   interrupt is raised, it will increase the index of the return stack storage and
>   then execute until the end of the tracing to finally free the index it used.
>   We don't need to disable irqs.
> 
> This is theorical. In practice, I've tested it with a two-core SMP 
> and had no problem at all. Perhaps -tip testing could confirm it.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

applied to tip/tracing/function-return-tracer, thanks Frederic!

	Ingo
