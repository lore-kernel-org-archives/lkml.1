Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbZKMITh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbZKMITh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbZKMITb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:19:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:44188 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbZKMITa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:19:30 -0500
Date: Fri, 13 Nov 2009 08:18:47 GMT
From: tip-bot for Dave Jones <davej@redhat.com>
Cc: mingo@redhat.com, rusty@rustcorp.com.au, fweisbec@gmail.com,
       rostedt@goodmis.org, gregkh@suse.de, ak@linux.intel.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, rientjes@google.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, yinghai@kernel.org,
       travis@sgi.com, seto.hidetoshi@jp.fujitsu.com, davej@redhat.com,
       rdunlap@xenotime.net, steiner@sgi.com, rdreier@cisco.com, tj@kernel.org,
       mingo@elte.hu
Reply-To: mingo@redhat.com, rusty@rustcorp.com.au, fweisbec@gmail.com,
       rostedt@goodmis.org, gregkh@suse.de, ak@linux.intel.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, rientjes@google.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, yinghai@kernel.org,
       travis@sgi.com, seto.hidetoshi@jp.fujitsu.com, davej@redhat.com,
       rdunlap@xenotime.net, rdreier@cisco.com, steiner@sgi.com, tj@kernel.org,
       mingo@elte.hu
In-Reply-To: <20091112231542.GA7129@redhat.com>
References: <20091112231542.GA7129@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Remove the CPU cache size printk's
Message-ID: <tip-15cd8812ab2ce62a2f779e93a8398bdad752291a@git.kernel.org>
Git-Commit-ID: 15cd8812ab2ce62a2f779e93a8398bdad752291a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15cd8812ab2ce62a2f779e93a8398bdad752291a
Gitweb:     http://git.kernel.org/tip/15cd8812ab2ce62a2f779e93a8398bdad752291a
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Thu, 12 Nov 2009 18:15:43 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Nov 2009 09:14:55 +0100

x86: Remove the CPU cache size printk's

They aren't really useful, and they pollute the dmesg output a lot
(especially on machines with many cores).

Also the same information can be trivially found out from
userspace.

Reported-by: Mike Travis <travis@sgi.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091112231542.GA7129@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 804c40e..0df4c2b 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -488,22 +488,6 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 #endif
 	}
 
-	if (trace)
-		printk(KERN_INFO "CPU: Trace cache: %dK uops", trace);
-	else if (l1i)
-		printk(KERN_INFO "CPU: L1 I cache: %dK", l1i);
-
-	if (l1d)
-		printk(KERN_CONT ", L1 D cache: %dK\n", l1d);
-	else
-		printk(KERN_CONT "\n");
-
-	if (l2)
-		printk(KERN_INFO "CPU: L2 cache: %dK\n", l2);
-
-	if (l3)
-		printk(KERN_INFO "CPU: L3 cache: %dK\n", l3);
-
 	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
 
 	return l2;
