Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbYLPVUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbYLPVUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 16:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYLPVUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:20:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35274 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbYLPVUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:20:37 -0500
Date: Tue, 16 Dec 2008 22:20:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: use preempt_enable_no_resched_notrace
	in ring_buffer_time_stamp()
Message-ID: <20081216212028.GP14787@elte.hu>
References: <494818EA.7080807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494818EA.7080807@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: prevent a trace recursion
> 
> After some tests with function graph tracer under x86-32, I saw some recursions
> caused by ring_buffer_time_stamp() that calls preempt_enable_no_notrace() which
> calls preempt_schedule() which is traced itself.
> 
> This patch re-enables preemption without rescheduling.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/ring_buffer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/tracing/ftrace, thanks Frederic!

Does this explain+fix the weird crashes/reboots you were seeing?

	Ingo
