Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbZCMFVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbZCMFVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbZCMFVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:21:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560AbZCMFVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:21:32 -0400
Date: Thu, 12 Mar 2009 22:17:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] softirq: no need to have SOFTIRQ in softirq name
Message-Id: <20090312221738.43006805.akpm@linux-foundation.org>
In-Reply-To: <20090313050521.766183674@goodmis.org>
References: <20090313050446.277065036@goodmis.org>
	<20090313050521.766183674@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009 01:04:50 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: clean up
> 
> It is redundant to have 'SOFTIRQ' in the softirq names.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/softirq.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index a5e8123..65ff3e3 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -55,9 +55,8 @@ static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp
>  static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
>  
>  char *softirq_to_name[NR_SOFTIRQS] = {
> -	"HI_SOFTIRQ", "TIMER_SOFTIRQ", "NET_TX_SOFTIRQ", "NET_RX_SOFTIRQ",
> -	"BLOCK_SOFTIRQ", "TASKLET_SOFTIRQ", "SCHED_SOFTIRQ", "HRTIMER_SOFTIRQ",
> -	"RCU_SOFTIRQ"
> +	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK",
> +	"TASKLET", "SCHED", "HRTIMER",	"RCU"
>  };
>  

hm, I was thinking that you'd also do

	printk("%s_SOFTIRQ", ...)

but whatever.
