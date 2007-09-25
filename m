Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbXIYIdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbXIYIdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbXIYIdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:33:07 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37073 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbXIYIdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:33:04 -0400
Date: Tue, 25 Sep 2007 14:13:27 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925084327.GI26289@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070924214537.GA18980@elte.hu> <20070925004120.3650c9c1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925004120.3650c9c1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 12:41:20AM -0700, Andrew Morton wrote:
> This doornails the Vaio.  After grub handover the screen remains black
> and the fan goes whir.
> 
> http://userweb.kernel.org/~akpm/config-sony.txt

This seems to be UP regression. Sorry abt that. I could recreate 
the problem very easily with CONFIG_SMP turned off.

Can you check if this patch works? Works for me here.

--

Fix UP breakage.

Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -1029,8 +1029,8 @@ static inline void __set_task_cpu(struct
 {
 #ifdef CONFIG_SMP
 	task_thread_info(p)->cpu = cpu;
-	set_task_cfs_rq(p);
 #endif
+	set_task_cfs_rq(p);
 }
 
 #ifdef CONFIG_SMP

-- 
Regards,
vatsa
