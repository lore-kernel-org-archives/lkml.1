Return-Path: <linux-kernel-owner+w=401wt.eu-S1423269AbXBPFUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423269AbXBPFUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 00:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423268AbXBPFUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 00:20:14 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:47033 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423270AbXBPFUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 00:20:12 -0500
Date: Fri, 16 Feb 2007 10:48:23 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Antoine Martin <antoine@nagafix.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: warning at kernel/cpu.c:51/unlock_cpu_hotplug() - 2.6.18.6
Message-ID: <20070216051823.GA9195@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <45D4C999.4080507@nagafix.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D4C999.4080507@nagafix.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antoine,

On Thu, Feb 15, 2007 at 08:59:05PM +0000, Antoine Martin wrote:
> I just caught this in the log whilst running some unit tests.
> (the test was in the process of starting 900 Java threads)
> 
> audit(1171565587.887:96): enforcing=0 old_enforcing=1 auid=4294967295
> BUG: warning at kernel/cpu.c:51/unlock_cpu_hotplug()
> 
> Call Trace:
>  [<ffffffff80269c98>] dump_stack+0x12/0x17
>  [<ffffffff8029dfe6>] unlock_cpu_hotplug+0x3f/0x6c
>  [<ffffffff802876b6>] sched_getaffinity+0x7d/0xa2
>  [<ffffffff80287701>] sys_sched_getaffinity+0x26/0x55
>  [<ffffffff8025cb0e>] system_call+0x7e/0x83

Looks like one of those spurious unlock_cpu_hotplug warnings.

Let me know if this fix works for you or not. 

regards
gautham.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>

 kernel/cpu.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.18/kernel/cpu.c
===================================================================
--- linux-2.6.18.orig/kernel/cpu.c
+++ linux-2.6.18/kernel/cpu.c
@@ -53,8 +53,8 @@ void unlock_cpu_hotplug(void)
 		recursive_depth--;
 		return;
 	}
-	mutex_unlock(&cpu_bitmask_lock);
 	recursive = NULL;
+	mutex_unlock(&cpu_bitmask_lock);
 }
 EXPORT_SYMBOL_GPL(unlock_cpu_hotplug);
 
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
