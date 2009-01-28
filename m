Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbZA1Xqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbZA1Xqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbZA1Xne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:43:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:37372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085AbZA1Xnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:43:33 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 005/114] x86, genapic: cleanups
Date: Wed, 28 Jan 2009 23:41:11 +0000
Message-Id: <1233186180-29883-6-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify genapic.h some more.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/genapic.h |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 7df1b48..19a5193 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -3,6 +3,9 @@
 
 #include <linux/cpumask.h>
 
+#include <asm/mpspec.h>
+#include <asm/atomic.h>
+
 /*
  * Copyright 2004 James Cleverdon, IBM.
  * Subject to the GNU Public License, v.2
@@ -13,7 +16,6 @@
  * Martin Bligh, Andi Kleen, James Bottomley, John Stultz, and
  * James Cleverdon.
  */
-
 struct genapic {
 	char *name;
 
@@ -85,6 +87,7 @@ struct genapic {
 
 	int trampoline_phys_low;
 	int trampoline_phys_high;
+
 	void (*wait_for_init_deassert)(atomic_t *deassert);
 	void (*smp_callin_clear_local_apic)(void);
 	void (*store_NMI_vector)(unsigned short *high, unsigned short *low);
@@ -92,10 +95,9 @@ struct genapic {
 	void (*inquire_remote_apic)(int apicid);
 };
 
-#ifdef CONFIG_X86_32
+extern struct genapic *genapic;
 
-#include <asm/mpspec.h>
-#include <asm/atomic.h>
+#ifdef CONFIG_X86_32
 
 #define APICFUNC(x) .x = x,
 
@@ -143,8 +145,8 @@ struct genapic {
 	IPIFUNC(send_IPI_all)				\
 	APICFUNC(enable_apic_mode)			\
 	APICFUNC(phys_pkg_id)				\
-	.trampoline_phys_low = TRAMPOLINE_PHYS_LOW,		\
-	.trampoline_phys_high = TRAMPOLINE_PHYS_HIGH,		\
+	.trampoline_phys_low = TRAMPOLINE_PHYS_LOW,	\
+	.trampoline_phys_high = TRAMPOLINE_PHYS_HIGH,	\
 	APICFUNC(wait_for_init_deassert)		\
 	APICFUNC(smp_callin_clear_local_apic)		\
 	APICFUNC(store_NMI_vector)			\
@@ -152,13 +154,10 @@ struct genapic {
 	APICFUNC(inquire_remote_apic)			\
 }
 
-extern struct genapic *genapic;
 extern void es7000_update_genapic_to_cluster(void);
 
 #else /* CONFIG_X86_64: */
 
-extern struct genapic *genapic;
-
 extern struct genapic apic_flat;
 extern struct genapic apic_physflat;
 extern struct genapic apic_x2apic_cluster;
-- 
1.6.0.2

