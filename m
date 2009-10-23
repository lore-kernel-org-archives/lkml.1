Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbZJWXh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbZJWXh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZJWXh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:37:58 -0400
Received: from relay2.sgi.com ([192.48.179.30]:54779 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752553AbZJWXh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:37:56 -0400
Message-Id: <20091023233800.970856000@alcatraz.americas.sgi.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 23 Oct 2009 18:37:51 -0500
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Shane Wang <shane.wang@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] SGI x86_64 UV: Limit the number of cpu is down messages
Content-Disposition: inline; filename=limit_cpu_offline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit number of "CPUx is down" messages when system is shutting down.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Shane Wang <shane.wang@intel.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/cpu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux.orig/kernel/cpu.c
+++ linux/kernel/cpu.c
@@ -394,7 +394,9 @@
 		error = _cpu_down(cpu, 1);
 		if (!error) {
 			cpumask_set_cpu(cpu, frozen_cpus);
-			printk("CPU%d is down\n", cpu);
+			if (cpu < 4 || system_state == SYSTEM_RUNNING ||
+				!limit_console_output(false))
+				printk(KERN_INFO "CPU%d is down\n", cpu);
 		} else {
 			printk(KERN_ERR "Error taking CPU%d down: %d\n",
 				cpu, error);

-- 
