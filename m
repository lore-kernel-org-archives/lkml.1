Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbYCSUPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbYCSUPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbYCSTjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180AbYCSTiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:52 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 62/79] [PATCH] move stack_start to smp.h
Date: Wed, 19 Mar 2008 14:25:57 -0300
Message-Id: <12059478541232-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1205947850822-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

voyager would conflict with it, but the types are ultimately
compatible. So remove the extern definition from voyager_smp.c
in favour of the common one

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c        |    6 ------
 arch/x86/mach-voyager/voyager_smp.c |    7 -------
 include/asm-x86/smp.h               |    7 +++++++
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 1eb7b73..ae25927 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -257,12 +257,6 @@ void __devinit initialize_secondary(void)
 		:"m" (current->thread.sp),"m" (current->thread.ip));
 }
 
-/* Static state in head.S used to set up a CPU */
-extern struct {
-	void * sp;
-	unsigned short ss;
-} stack_start;
-
 static inline void __inquire_remote_apic(int apicid)
 {
 	unsigned i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 5d4c185..a707712 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -518,13 +518,6 @@ static void __init do_boot_cpu(__u8 cpu)
 	    & ~(voyager_extended_vic_processors
 		& voyager_allowed_boot_processors);
 
-	/* This is an area in head.S which was used to set up the
-	 * initial kernel stack.  We need to alter this to give the
-	 * booting CPU a new stack (taken from its idle process) */
-	extern struct {
-		__u8 *sp;
-		unsigned short ss;
-	} stack_start;
 	/* This is the format of the CPI IDT gate (in real mode) which
 	 * we're hijacking to boot the CPU */
 	union IDTFormat {
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index d02e6ea..78ef16d 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -28,6 +28,13 @@ extern const unsigned char trampoline_data [];
 extern const unsigned char trampoline_end  [];
 extern unsigned char *trampoline_base;
 
+/* Static state in head.S used to set up a CPU */
+extern struct {
+	void *sp;
+	unsigned short ss;
+} stack_start;
+
+
 struct smp_ops {
 	void (*smp_prepare_boot_cpu)(void);
 	void (*smp_prepare_cpus)(unsigned max_cpus);
-- 
1.5.0.6

