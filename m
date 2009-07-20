Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZGTRiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZGTRiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZGTRiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:38:18 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:7042 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZGTRiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:38:17 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
 breakpoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <1248109687-7808-6-git-send-email-fweisbec@gmail.com>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
	 <1248109687-7808-6-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 19:38:55 +0200
Message-Id: <1248111535.15751.9339.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 13:08 -0400, Frederic Weisbecker wrote:
> This adds the support for kernel hardware breakpoints in perfcounter.
> It is added as a new type of software counter and can be defined by
> using the counter number 5 and by passsing the address of the
> breakpoint to set through the config attribute.


> +void bp_perf_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
> +{
> +	unsigned long target = hw_breakpoint_addr(bp);
> +
> +	struct perf_sample_data data = {
> +		.regs = regs,
> +		.addr = instruction_pointer(regs),
> +	};
> +
> +	do_perf_swcounter_event(PERF_TYPE_BREAKPOINT, target, 1, 0, &data);
> +}

.addr would be an associated data address, like for pagefaults and
cache-misses have, its not the RIP of the faulting ins.

