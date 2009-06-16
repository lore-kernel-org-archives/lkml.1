Return-Path: <linux-kernel-owner+w=401wt.eu-S1760481AbZFPT7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481AbZFPT7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbZFPT7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:59:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55631 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbZFPT7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:59:00 -0400
Date: Tue, 16 Jun 2009 21:58:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIT PULL] tracing/filters/ringbuffer: updates for
	2.6.31
Message-ID: <20090616195851.GA6802@elte.hu>
References: <20090616175133.317996432@goodmis.org> <20090616192821.GA12699@elte.hu> <20090616193621.GA21246@elte.hu> <alpine.DEB.2.00.0906161548110.26673@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906161548110.26673@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 16 Jun 2009, Ingo Molnar wrote:
> 
> > 
> > hm, there's a new build failure with this lot:
> > 
> > kernel/trace/ring_buffer.c:1298: error: ?event? undeclared (first use in this function)
> > kernel/trace/ring_buffer.c:1298: error: (Each undeclared identifier is reported only once
> > kernel/trace/ring_buffer.c:1298: error: for each function it appears in.)
> 
> Strange, I have a blank line at line 1298:
> 
> 1294                 cpu_buffer->tail_page->page->time_stamp = *ts;
> 1295         }
> 1296 
> 1297         rb_reset_tail(cpu_buffer, tail_page, tail, length);
> 1298 
> 1299         __raw_spin_unlock(&cpu_buffer->lock);
> 1300         local_irq_restore(flags);
> 1301 

ah. git auto-merge getting confused:

        }

                kmemcheck_annotate_bitfield(event, bitfield);
        rb_reset_tail(cpu_buffer, tail_page, tail, length);

it's rare that we see something like that.

	Ingo
