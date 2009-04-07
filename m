Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbZDGPGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbZDGPGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZDGPGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:06:08 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:58350 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbZDGPGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:06:08 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ming@elte.hu
Cc: penberg@cs.helsinki.fi, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/13] x86: use identical loop constructs in 32-bit and 64-bit native_init_IRQ()
Date: Tue,  7 Apr 2009 16:48:32 +0300
Message-Id: <1239112120-676-5-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/irqinit_32.c |    2 +-
 arch/x86/kernel/irqinit_64.c |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 9ba68c4..1029a18 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -205,7 +205,7 @@ void __init native_init_IRQ(void)
 	 * us. (some of these will be overridden and become
 	 * 'special' SMP interrupts)
 	 */
-	for (i =  FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
+	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
 		/* SYSCALL_VECTOR was reserved in trap_init. */
 		if (i != SYSCALL_VECTOR)
 			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 8cd1053..1c8858b 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -159,15 +159,16 @@ void __init native_init_IRQ(void)
 	int i;
 
 	init_ISA_irqs();
+
 	/*
 	 * Cover the whole vector space, no vector can escape
 	 * us. (some of these will be overridden and become
 	 * 'special' SMP interrupts)
 	 */
-	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
-		int vector = FIRST_EXTERNAL_VECTOR + i;
-		if (vector != IA32_SYSCALL_VECTOR)
-			set_intr_gate(vector, interrupt[i]);
+	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
+		/* IA32_SYSCALL_VECTOR was reserved in trap_init. */
+		if (i != IA32_SYSCALL_VECTOR)
+			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
 	}
 
 	apic_intr_init();
-- 
1.5.6.3

