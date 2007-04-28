Return-Path: <linux-kernel-owner+w=401wt.eu-S1163291AbXD1Rwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163291AbXD1Rwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163289AbXD1Rwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:52:33 -0400
Received: from ns.suse.de ([195.135.220.2]:34397 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163287AbXD1Rwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:32 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Andrew Morton <akpm@osdl.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <ak@suse.de>, "Li, Shaohua" <shaohua.li@intel.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [2/35] x86_64: revert x86_64-mm-add-genapic_force
Message-Id: <20070428175225.E8441151EA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@osdl.org>

This is obsoleted by new Ingo genapic patches.

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/genapic.c |    9 +--------
 include/asm-x86_64/genapic.h |    2 +-
 2 files changed, 2 insertions(+), 9 deletions(-)

Index: linux/arch/x86_64/kernel/genapic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/genapic.c
+++ linux/arch/x86_64/kernel/genapic.c
@@ -33,7 +33,7 @@ extern struct genapic apic_flat;
 extern struct genapic apic_physflat;
 
 struct genapic *genapic = &apic_flat;
-struct genapic *genapic_force;
+
 
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
@@ -46,13 +46,6 @@ void __init clustered_apic_check(void)
 	u8 cluster_cnt[NUM_APIC_CLUSTERS];
 	int max_apic = 0;
 
-	/* genapic selection can be forced because of certain quirks.
-	 */
-	if (genapic_force) {
-		genapic = genapic_force;
-		goto print;
-	}
-
 #if defined(CONFIG_ACPI)
 	/*
 	 * Some x86_64 machines use physical APIC mode regardless of how many
Index: linux/include/asm-x86_64/genapic.h
===================================================================
--- linux.orig/include/asm-x86_64/genapic.h
+++ linux/include/asm-x86_64/genapic.h
@@ -30,6 +30,6 @@ struct genapic {
 };
 
 
-extern struct genapic *genapic, *genapic_force, apic_flat;
+extern struct genapic *genapic;
 
 #endif
