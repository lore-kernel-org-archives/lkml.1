Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbZKNA4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbZKNA4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZKNA4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:56:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:42024 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbZKNA4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:56:50 -0500
Date: Sat, 14 Nov 2009 00:54:37 GMT
From: tip-bot for Roland Dreier <rdreier@cisco.com>
Cc: mingo@redhat.com, rusty@rustcorp.com.au, fweisbec@gmail.com,
       rostedt@goodmis.org, gregkh@suse.de, ak@linux.intel.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, rientjes@google.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, yinghai@kernel.org,
       seto.hidetoshi@jp.fujitsu.com, travis@sgi.com, davej@redhat.com,
       rdunlap@xenotime.net, steiner@sgi.com, rdreier@cisco.com, tj@kernel.org,
       rolandd@cisco.com, mingo@elte.hu
Reply-To: mingo@redhat.com, rusty@rustcorp.com.au, fweisbec@gmail.com,
       rostedt@goodmis.org, gregkh@suse.de, ak@linux.intel.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, rientjes@google.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, yinghai@kernel.org,
       seto.hidetoshi@jp.fujitsu.com, travis@sgi.com, davej@redhat.com,
       rdunlap@xenotime.net, rdreier@cisco.com, steiner@sgi.com, tj@kernel.org,
       rolandd@cisco.com, mingo@elte.hu
In-Reply-To: <adaocn6dp99.fsf_-_@roland-alpha.cisco.com>
References: <adaocn6dp99.fsf_-_@roland-alpha.cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Remove CPU cache size output for non-Intel too
Message-ID: <tip-b01c845f0f2e3f9e54e6a78d5d56895f5b95e818@git.kernel.org>
Git-Commit-ID: b01c845f0f2e3f9e54e6a78d5d56895f5b95e818
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b01c845f0f2e3f9e54e6a78d5d56895f5b95e818
Gitweb:     http://git.kernel.org/tip/b01c845f0f2e3f9e54e6a78d5d56895f5b95e818
Author:     Roland Dreier <rdreier@cisco.com>
AuthorDate: Fri, 13 Nov 2009 14:38:26 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Nov 2009 01:51:18 +0100

x86: Remove CPU cache size output for non-Intel too

As Dave Jones said about the output in intel_cacheinfo.c: "They
aren't useful, and pollute the dmesg output a lot (especially on
machines with many cores).  Also the same information can be
trivially found out from userspace."

Give the generic display_cacheinfo() function the same treatment.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Acked-by: Dave Jones <davej@redhat.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
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
LKML-Reference: <adaocn6dp99.fsf_-_@roland-alpha.cisco.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 617a29f..9db1e24 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -391,8 +391,6 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 
 	if (n >= 0x80000005) {
 		cpuid(0x80000005, &dummy, &ebx, &ecx, &edx);
-		printk(KERN_INFO "CPU: L1 I Cache: %dK (%d bytes/line), D cache %dK (%d bytes/line)\n",
-				edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
 		c->x86_cache_size = (ecx>>24) + (edx>>24);
 #ifdef CONFIG_X86_64
 		/* On K8 L1 TLB is inclusive, so don't count it */
@@ -422,9 +420,6 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 #endif
 
 	c->x86_cache_size = l2size;
-
-	printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
-			l2size, ecx & 0xFF);
 }
 
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
