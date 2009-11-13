Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbZKMWig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbZKMWig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757160AbZKMWie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:38:34 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:57537 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760AbZKMWie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:38:34 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEtv/UqrRN+K/2dsb2JhbAC+GJgbhDwE
X-IronPort-AV: E=Sophos;i="4.44,739,1249257600"; 
   d="scan'208";a="432206819"
From: Roland Dreier <rdreier@cisco.com>
To: Dave Jones <davej@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yinghai@kernel.org>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Remove CPU cache size output for non-Intel too
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
	<20091023233746.128967000@alcatraz.americas.sgi.com>
	<87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com>
	<20091026215544.GA3355@basil.fritz.box> <4AEB3D95.50300@sgi.com>
	<4AEEBE65.3070202@linux.intel.com> <4AEF3143.2030701@sgi.com>
	<20091112222200.GA19109@redhat.com> <4AFC92DD.3020105@zytor.com>
	<20091112231542.GA7129@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 13 Nov 2009 14:38:26 -0800
In-Reply-To: <20091112231542.GA7129@redhat.com> (Dave Jones's message of "Thu,
	12 Nov 2009 18:15:43 -0500")
Message-ID: <adaocn6dp99.fsf_-_@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Nov 2009 22:38:26.0973 (UTC) FILETIME=[042154D0:01CA64B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Dave Jones said about the output in intel_cacheinfo.c: "They aren't
useful, and pollute the dmesg output a lot (especially on machines with
many cores).  Also the same information can be trivially found out from
userspace."  Give the generic display_cacheinfo() function the same
treatment.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 arch/x86/kernel/cpu/common.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cc25c2b..5f8f420 100644
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
