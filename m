Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbZHYTwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbZHYTwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbZHYTwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:52:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:60000 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061AbZHYTwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:52:10 -0400
Message-ID: <4A9440AC.6000102@kernel.org>
Date: Tue, 25 Aug 2009 12:51:08 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: [PATCH] x86: use c->apicid directly in srat_detect_node
References: <4A9391CD.5020804@kernel.org>
In-Reply-To: <4A9391CD.5020804@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


need applied after 
|  [PATCH] x86: use hard_smp_processor_id to get apic id in identify_cpu

don't need to read it again, just use stored value.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/amd.c   |    2 +-
 arch/x86/kernel/cpu/intel.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -277,7 +277,7 @@ static void __cpuinit srat_detect_node(s
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	int cpu = smp_processor_id();
 	int node;
-	unsigned apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
+	unsigned apicid = c->apicid;
 
 	node = c->phys_proc_id;
 	if (apicid_to_node[apicid] != NUMA_NO_NODE)
Index: linux-2.6/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6/arch/x86/kernel/cpu/intel.c
@@ -258,7 +258,7 @@ static void __cpuinit srat_detect_node(s
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	unsigned node;
 	int cpu = smp_processor_id();
-	int apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
+	int apicid = c->apicid;
 
 	/* Don't do the funky fallback heuristics the AMD version employs
 	   for now. */
