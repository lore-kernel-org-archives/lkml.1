Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbYGAIQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbYGAIQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbYGAIPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:15:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57958 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbYGAIPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:15:50 -0400
Date: Tue, 1 Jul 2008 10:15:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>, proski@gnu.org
Subject: Re: mmiotrace broken in linux-next (8-bit writes only)
Message-ID: <20080701081516.GA3473@elte.hu>
References: <20080628214626.5f9199d7@daedalus.pq.iki.fi> <20080630123736.GA4011@elte.hu> <20080630234837.118fff8c@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630234837.118fff8c@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> The moment mmiotrace is enabled, I hit a NULL deref in:
> 
> IP: [<ffffffff80256e71>] __trace_special+0x17c/0x23a
> Call Trace:
>  [<ffffffff802573cc>] ftrace_special+0x6f/0x9a
>  [<ffffffff8023e3e4>] down+0x19/0x4a
>  [<ffffffff80228adc>] acquire_console_sem+0x42/0x58
>  [<ffffffff8035d273>] con_flush_chars+0x28/0x43
>  [<ffffffff80354a70>] write_chan+0x22e/0x334
>  [<ffffffff802244e9>] ? default_wake_function+0x0/0xf
>  [<ffffffff8035236d>] tty_write+0x195/0x228
>  [<ffffffff80354842>] ? write_chan+0x0/0x334
>  [<ffffffff8027c23a>] vfs_write+0xae/0x137
>  [<ffffffff8027c6e3>] sys_write+0x47/0x70
>  [<ffffffff8020b1db>] system_call_after_swapgs+0x7b/0x80
> 
> which means 'entry' in __trace_special() is NULL.

>  
> -	ftrace_special(sem->count, 0, __LINE__);
>  	spin_lock_irqsave(&sem->lock, flags);

applied to tip/tracing/ftrace - thanks Pekka. This was a leftover line 
from semaphore debugging.

	Ingo
