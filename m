Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZHYH0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZHYH0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbZHYH0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:26:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:33421 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbZHYH0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:26:08 -0400
Message-ID: <4A9391CD.5020804@kernel.org>
Date: Tue, 25 Aug 2009 00:25:01 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: use hard_smp_processor_id to get apic id in identify_cpu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


and leave phys_proc_id to use initial apic id.

otherwise, system with apci id lifting will have wrong apicid in
/proc/cpuinfo

for 2.6.31 ?

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -715,7 +715,7 @@ static void __cpuinit generic_identify(s
 		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
 #ifdef CONFIG_X86_32
 # ifdef CONFIG_X86_HT
-		c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
+		c->apicid = hard_smp_processor_id();
 # else
 		c->apicid = c->initial_apicid;
 # endif
@@ -772,7 +772,7 @@ static void __cpuinit identify_cpu(struc
 	}
 
 #ifdef CONFIG_X86_64
-	c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
+	c->apicid = hard_smp_processor_id();
 #endif
 
 	/*
