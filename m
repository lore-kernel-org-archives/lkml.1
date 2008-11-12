Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYKLNhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYKLNhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYKLNfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:35:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45170 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbYKLNfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:35:46 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 5/8] x86 kdump: Make nmi_shootdown_cpus() non-static
Date: Wed, 12 Nov 2008 11:34:41 -0200
Message-Id: <1226496884-24628-6-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226496884-24628-1-git-send-email-ehabkost@redhat.com>
References: <1226496884-24628-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype to asm/reboot.h.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/include/asm/reboot.h |    5 +++++
 arch/x86/kernel/crash.c       |    3 +--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index df77103..562d4fd 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_REBOOT_H
 #define _ASM_X86_REBOOT_H
 
+#include <linux/kdebug.h>
+
 struct pt_regs;
 
 struct machine_ops {
@@ -18,4 +20,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs);
 void native_machine_shutdown(void);
 void machine_real_restart(const unsigned char *code, int length);
 
+typedef void (*nmi_shootdown_cb)(int, struct die_args*);
+void nmi_shootdown_cpus(nmi_shootdown_cb callback);
+
 #endif /* _ASM_X86_REBOOT_H */
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index f23c2be..fb298d1 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -29,7 +29,6 @@
 
 #include <mach_ipi.h>
 
-typedef void (*nmi_shootdown_cb)(int, struct die_args*);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
@@ -100,7 +99,7 @@ static struct notifier_block crash_nmi_nb = {
 	.notifier_call = crash_nmi_callback,
 };
 
-static void nmi_shootdown_cpus(nmi_shootdown_cb callback)
+void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 {
 	unsigned long msecs;
 
-- 
1.5.5.GIT

