Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbZG2Iim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbZG2Iim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 04:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZG2Iim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 04:38:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60806 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZG2Iil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 04:38:41 -0400
Subject: Re: [PATCH 1/2] sched: check for pushing rt tasks after all
 scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090729042526.205923666@goodmis.org>
References: <20090729042121.727652581@goodmis.org>
	 <20090729042526.205923666@goodmis.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Jul 2009 10:41:24 +0200
Message-Id: <1248856884.6987.3043.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 00:21 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0001-sched-check-for-pushing-rt-tasks-after-all-schedulin.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The current method for pushing RT tasks after scheduling only
> happens after a context switch. But we found cases where a task
> is set up on a run queue to be pushed but the push never happens
> because the schedule chooses the same task.
> 
> This bug was found with the help of Gregory Haskins and the use of
> ftrace (trace_printk). It tooks several days for both of us analyzing
> the code and the trace output to find this.


> +               if (current->sched_class->needs_post_schedule)
> +                       post_schedule = current->sched_class->needs_post_schedule(rq);


> +       if (post_schedule)
> +               current->sched_class->post_schedule(rq);


Why can't we omit that first call, and do the second unconditionally,
using storage in the class rq to save state?
