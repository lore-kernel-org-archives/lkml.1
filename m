Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbYESPrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbYESPrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYESPqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:46:53 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:41266 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751391AbYESPqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:46:53 -0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86: move pic_mode to apic_32.c
Date: Mon, 19 May 2008 19:46:57 +0400
Message-ID: <20080519154656.15071.96979.stgit@thinkpad>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 arch/x86/kernel/apic_32.c     |    2 ++
 arch/x86/kernel/mpparse.c     |    4 +---
 arch/x86/mach-visws/mpparse.c |    2 --
 3 files changed, 3 insertions(+), 5 deletions(-)


diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 6b2c2cf..c0dd696 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -77,6 +77,8 @@ char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
  */
 int apic_verbosity;
 
+int pic_mode;
+
 static unsigned int calibration_result;
 
 static int lapic_next_event(unsigned long delta,
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 59f051d..b72c046 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -48,8 +48,6 @@ int mp_bus_id_to_pci_bus[MAX_MP_BUSSES] = {[0 ... MAX_MP_BUSSES - 1] = -1 };
 
 static int mp_current_pci_id;
 
-int pic_mode;
-
 /*
  * Intel MP BIOS table parsing routines:
  */
@@ -609,7 +607,7 @@ static void __init __get_smp_config(unsigned early)
 
 	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
 	       mpf->mpf_specification);
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
 	if (mpf->mpf_feature2 & (1 << 7)) {
 		printk(KERN_INFO "    IMCR and PIC compatibility mode.\n");
 		pic_mode = 1;
diff --git a/arch/x86/mach-visws/mpparse.c b/arch/x86/mach-visws/mpparse.c
index 57484e9..b7d063e 100644
--- a/arch/x86/mach-visws/mpparse.c
+++ b/arch/x86/mach-visws/mpparse.c
@@ -11,8 +11,6 @@
 /* Have we found an MP table */
 int smp_found_config;
 
-int pic_mode;
-
 extern unsigned int __cpuinitdata maxcpus;
 
 /*

