Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbYGJRCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbYGJRCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbYGJRBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:01:19 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:12141 "EHLO
	WA2EHSNDR004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758268AbYGJRBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:01:18 -0400
X-BigFish: VPS30(z297cpzzz10d3izzz32i87il)
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: 30
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3SV9E-02-GGF-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/5] x86: build fix for "x86: fix C1E && nx6325 stability problem"
Date: Thu, 10 Jul 2008 18:58:26 +0200
Message-ID: <1215709106-9182-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
References: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 10 Jul 2008 17:00:50.0711 (UTC) FILETIME=[81A1CA70:01C8E2AE]
MIME-Version: 1.0
Content-Type: text/plain
Reply-To: <rrichter@elbe.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

fix:

 arch/x86/kernel/built-in.o: In function `dmi_ignore_irq0_timer_override':
 boot.c:(.init.text+0x3ea4): undefined reference to `force_mask_ioapic_irq_2'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/genapic_32.h |    4 ++++
 include/asm-x86/genapic_64.h |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/genapic_32.h b/include/asm-x86/genapic_32.h
index 8d4c8bd..33a73f5 100644
--- a/include/asm-x86/genapic_32.h
+++ b/include/asm-x86/genapic_32.h
@@ -119,6 +119,10 @@ enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
 #define is_uv_system()			0
 #define uv_wakeup_secondary(a, b)	1
 
+#ifdef CONFIG_X86_IO_APIC
 extern void force_mask_ioapic_irq_2(void);
+#else
+static inline void force_mask_ioapic_irq_2(void) { }
+#endif
 
 #endif
diff --git a/include/asm-x86/genapic_64.h b/include/asm-x86/genapic_64.h
index 082ad02..647e4e5 100644
--- a/include/asm-x86/genapic_64.h
+++ b/include/asm-x86/genapic_64.h
@@ -46,6 +46,10 @@ extern int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip);
 
 extern void setup_apic_routing(void);
 
+#ifdef CONFIG_X86_IO_APIC
 extern void force_mask_ioapic_irq_2(void);
+#else
+static inline void force_mask_ioapic_irq_2(void) { }
+#endif
 
 #endif
-- 
1.5.5.4


