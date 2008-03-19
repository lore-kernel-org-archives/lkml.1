Return-Path: <linux-kernel-owner+w=401wt.eu-S1764476AbYCSULZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764476AbYCSULZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbYCSTiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154AbYCSTic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:32 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 43/79] [PATCH] call nmi_watchdog_default in i386
Date: Wed, 19 Mar 2008 14:25:38 -0300
Message-Id: <1205947770685-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059477661524-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

this does not exist, so it will be an empty macro

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |    1 +
 include/asm-x86/nmi.h        |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 1f3aff4..a350553 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -876,6 +876,7 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
    who understands all this stuff should rewrite it properly. --RR 15/Jul/02 */
 void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
+	nmi_watchdog_default();
 	smp_commenced_mask = cpumask_of_cpu(0);
 	cpu_callin_map = cpumask_of_cpu(0);
 	mb();
diff --git a/include/asm-x86/nmi.h b/include/asm-x86/nmi.h
index 2b94199..1e36302 100644
--- a/include/asm-x86/nmi.h
+++ b/include/asm-x86/nmi.h
@@ -39,6 +39,9 @@ static inline void unset_nmi_pm_callback(struct pm_dev *dev)
 #ifdef CONFIG_X86_64
 extern void default_do_nmi(struct pt_regs *);
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
+extern void nmi_watchdog_default(void);
+#else
+#define nmi_watchdog_default() do {} while (0)
 #endif
 
 extern int check_nmi_watchdog(void);
@@ -50,7 +53,6 @@ extern int reserve_perfctr_nmi(unsigned int);
 extern void release_perfctr_nmi(unsigned int);
 extern int reserve_evntsel_nmi(unsigned int);
 extern void release_evntsel_nmi(unsigned int);
-extern void nmi_watchdog_default(void);
 
 extern void setup_apic_nmi_watchdog(void *);
 extern void stop_apic_nmi_watchdog(void *);
-- 
1.5.0.6

