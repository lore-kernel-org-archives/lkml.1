Return-Path: <linux-kernel-owner+w=401wt.eu-S1763155AbYCERpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763155AbYCERpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762130AbYCERpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:45:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541AbYCERpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:45:43 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 1/1] export native versions of machine_ops functions
Date: Wed,  5 Mar 2008 14:44:00 -0300
Message-Id: <1204739040-18422-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

People overriding machine_ops provided functions may want to
call the native version after its pre-processing. It already
happens for the smp_ops functions, so I don't see a reason
for avoiding it here.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/reboot.c |   10 +++++-----
 include/asm-x86/reboot.h |    5 +++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 7fd6ac4..8b577f1 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -326,7 +326,7 @@ static inline void kb_wait(void)
 	}
 }
 
-static void native_machine_emergency_restart(void)
+void native_machine_emergency_restart(void)
 {
 	int i;
 
@@ -376,7 +376,7 @@ #endif
 	}
 }
 
-static void native_machine_shutdown(void)
+void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
@@ -420,7 +420,7 @@ #ifdef CONFIG_X86_64
 #endif
 }
 
-static void native_machine_restart(char *__unused)
+void native_machine_restart(char *__unused)
 {
 	printk("machine restart\n");
 
@@ -429,11 +429,11 @@ static void native_machine_restart(char 
 	machine_emergency_restart();
 }
 
-static void native_machine_halt(void)
+void native_machine_halt(void)
 {
 }
 
-static void native_machine_power_off(void)
+void native_machine_power_off(void)
 {
 	if (pm_power_off) {
 		if (!reboot_force)
diff --git a/include/asm-x86/reboot.h b/include/asm-x86/reboot.h
index e9e3ffc..fb1bdf1 100644
--- a/include/asm-x86/reboot.h
+++ b/include/asm-x86/reboot.h
@@ -16,5 +16,10 @@ struct machine_ops
 extern struct machine_ops machine_ops;
 
 void machine_real_restart(unsigned char *code, int length);
+void native_machine_emergency_restart(void);
+void native_machine_shutdown(void);
+void native_machine_restart(char *__unused);
+void native_machine_halt(void);
+void native_machine_power_off(void);
 
 #endif	/* _ASM_REBOOT_H */
-- 
1.4.2

