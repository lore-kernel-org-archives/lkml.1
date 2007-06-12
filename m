Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbXFLCRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbXFLCRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 22:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbXFLCRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 22:17:01 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:51666 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbXFLCRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 22:17:00 -0400
Message-ID: <466E01DF.6080500@linux.vnet.ibm.com>
Date: Tue, 12 Jun 2007 07:45:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       wli@holomorphy.com, ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       efault@gmx.de, pwil3058@bigpond.net.au, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, dmitry.adamushko@gmail.com,
       tingy@cs.umass.edu, tong.n.li@intel.com, containers@lists.osdl.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [ckrm-tech] [RFC][PATCH 1/6] Introduce struct sched_entity and
 struct lrq
References: <20070611154724.GA32435@in.ibm.com> <20070611155046.GA2109@in.ibm.com>
In-Reply-To: <20070611155046.GA2109@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> This patch introduces two new structures:
> 
> struct sched_entity
>         stores essential attributes/execution-history used by CFS core
>         to drive fairness between 'schedulable entities' (tasks, users etc)
> 
> struct lrq
>         runqueue used to hold ready-to-run entities
> 
> These new structures are formed by grouping together existing fields in
> existing structures (task_struct and rq) and hence represents rework
> with zero functionality change.
> 
> Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
[snip]

> 
> +/* CFS-related fields in a runqueue */
> +struct lrq {
> +	unsigned long raw_weighted_load;
> +	#define CPU_LOAD_IDX_MAX 5
> +	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
> +	unsigned long nr_load_updates;
> +
> +	u64 fair_clock, delta_fair_clock;
> +	u64 exec_clock, delta_exec_clock;
> +	s64 wait_runtime;
> +	unsigned long wait_runtime_overruns, wait_runtime_underruns;
> +
> +	struct rb_root tasks_timeline;
> +	struct rb_node *rb_leftmost;
> +	struct rb_node *rb_load_balance_curr;
> +};
> +

Shouldn't the rq->lock move into lrq?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
