Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbYCHCLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbYCHCLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 21:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYCHCLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 21:11:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265AbYCHCLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 21:11:02 -0500
Date: Fri, 7 Mar 2008 18:09:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, dmitry.adamushko@gmail.com,
       ego@in.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, yi.y.yang@intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
 dealocked when cpu is set to offline
Message-Id: <20080307180959.41498329.akpm@linux-foundation.org>
In-Reply-To: <20080308015045.GB15909@linux-os.sc.intel.com>
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com>
	<20080307230126.GA15909@linux-os.sc.intel.com>
	<20080307152934.5c4052db.akpm@linux-foundation.org>
	<200803080043.16817.rjw@sisk.pl>
	<20080308015045.GB15909@linux-os.sc.intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 17:50:45 -0800 Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Andrew, Can you please try one more patch(appended) to see if it helps?
> 

Not until Monday, sorry - the offending machine is at work and (due to
this bug) cannot be woken via LAN.

> ---
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 0a6d2e5..8cb707c 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -597,7 +597,7 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
>  	int       count       = 0;
>  	int       cpu;
>  
> -	cpus_and(*lowest_mask, task_rq(task)->rd->online, task->cpus_allowed);
> +	cpus_and(*lowest_mask, task->cpus_allowed, cpu_online_map);
