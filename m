Return-Path: <linux-kernel-owner+w=401wt.eu-S1765498AbYD1HC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765498AbYD1HC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932199AbYD1HB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:01:59 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:51370 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204AbYD1HB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:01:58 -0400
Message-ID: <48157664.2060302@isomerica.net>
Date: Mon, 28 Apr 2008 03:01:56 -0400
From: Dan Noe <dpn@isomerica.net>
Reply-To: dpn@isomerica.net
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: NULL dereference OOPS on SysRq-w
References: <48141EFA.6080700@isomerica.net> <20080428065736.GA2714@darkstar.te-china.tietoenator.com>
In-Reply-To: <20080428065736.GA2714@darkstar.te-china.tietoenator.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> [snip]
> 
> I have a fix for the NULL pointer reference BUG, tested on my pc.
> ---
> 
> "m" will be NULL if seq_printf & seq_puts is called from sched_debug_show
> Use SEQ_* macros to fix it 
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

There is actually already a patch out for this which simply hasn't made 
it upstream yet - Mike Galbraith emailed me with it and it indeed fixes 
the problem.  I hadn't realized his email didn't go to lkml.. otherwise 
I would have echoed that here to avoid wasting people's time.  My apologies.

Cheers,
Dan

===

Here is his message:

From: efault@gmx.de

Peter's fix didn't make it up-stream.

Subject: sched: fix oops

sched_debug uses SEQ_printf to use printk when the seqfile 'm' is NULL.
Instead of doing that here too; choose to not output the weight tree
to cut back on output.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 89fa32b..353a481 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1643,8 +1643,10 @@ static void print_cfs_stats(struct seq_file *m, 
int cpu)
  	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
  		print_cfs_rq(m, cpu, cfs_rq);

-	seq_printf(m, "\nWeight tree:\n");
-	print_cfs_rq_tasks(m, &cpu_rq(cpu)->cfs, 1);
+	if (m) {
+		seq_printf(m, "\nWeight tree:\n");
+		print_cfs_rq_tasks(m, &cpu_rq(cpu)->cfs, 1);
+	}
  	rcu_read_unlock();
  }
  #endif


-- 
                     /--------------- - -  -  -   -   -
                     |  Dan Noe
                     |  http://isomerica.net/~dpn/
