Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbYFIOWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbYFIOWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760625AbYFIOS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:18:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760516AbYFIOS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:18:57 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 10/15] x86: provide connect_bsp_APIC for x86_64
Date: Mon,  9 Jun 2008 11:16:53 -0300
Message-Id: <1213021018-14159-11-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-10-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
 <1213021018-14159-5-git-send-email-gcosta@redhat.com>
 <1213021018-14159-6-git-send-email-gcosta@redhat.com>
 <1213021018-14159-7-git-send-email-gcosta@redhat.com>
 <1213021018-14159-8-git-send-email-gcosta@redhat.com>
 <1213021018-14159-9-git-send-email-gcosta@redhat.com>
 <1213021018-14159-10-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although it is not really needed, we provide it to get
closer to i386. ifdefs around it are removed in smpboot.c

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/apic_64.c |   10 ++++++++++
 arch/x86/kernel/smpboot.c |    5 +----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 310bec1..8d62387 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -942,6 +942,8 @@ int __init APIC_init_uniprocessor(void)
 
 	verify_local_APIC();
 
+	connect_bsp_APIC();
+
 	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
 	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
 
@@ -1023,6 +1025,14 @@ asmlinkage void smp_error_interrupt(void)
 	irq_exit();
 }
 
+/**
+ *  * connect_bsp_APIC - attach the APIC to the interrupt system
+ *   */
+void __init connect_bsp_APIC(void)
+{
+	enable_apic_mode();
+}
+
 void disconnect_bsp_APIC(int virt_wire_setup)
 {
 	/* Go back to Virtual Wire compatibility mode */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9d8dfec..c4bb997 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1117,9 +1117,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 
 		localise_nmi_watchdog();
 
-#ifdef CONFIG_X86_32
 		connect_bsp_APIC();
-#endif
 		setup_local_APIC();
 		end_local_APIC_setup();
 		return -1;
@@ -1174,9 +1172,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	}
 	preempt_enable();
 
-#ifdef CONFIG_X86_32
 	connect_bsp_APIC();
-#endif
+
 	/*
 	 * Switch from PIC to APIC mode.
 	 */
-- 
1.5.4.5

