Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbZLXByv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbZLXByv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 20:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbZLXByv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 20:54:51 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:9528 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZLXByu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 20:54:50 -0500
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: x86@kernel.org
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
       linux-kernel@vger.kernel.org, gorcunov@gmail.com,
       oprofile-list@lists.sf.net, mingo@elte.hu, tglx@linutronix.de
Message-Id: <20091224015441.6005.4408.sendpatchset@localhost.localdomain>
Subject: [PATCH] x86, perfctr: remove unused func avail_to_resrv_perfctr_nmi()
Date: Thu, 24 Dec 2009 01:54:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

avail_to_resrv_perfctr_nmi() is neither EXPORT'd, nor used in the file.
So remove it.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
---
 arch/x86/include/asm/nmi.h             |    1 -
 arch/x86/kernel/cpu/perfctr-watchdog.c |   11 -----------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 139d4c1..93da9c3 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -19,7 +19,6 @@ extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
-extern int avail_to_resrv_perfctr_nmi(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
 extern void release_perfctr_nmi(unsigned int);
 extern int reserve_evntsel_nmi(unsigned int);
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 898df97..74f4e85 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -115,17 +115,6 @@ int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
 
 	return !test_bit(counter, perfctr_nmi_owner);
 }
-
-/* checks the an msr for availability */
-int avail_to_resrv_perfctr_nmi(unsigned int msr)
-{
-	unsigned int counter;
-
-	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	return !test_bit(counter, perfctr_nmi_owner);
-}
 EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
 
 int reserve_perfctr_nmi(unsigned int msr)
-- 
1.6.2.2

