Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYHWNDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYHWNDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYHWNBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:01:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:19071 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbYHWNA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=J86cy+J+GaZ63gkn3ZAvuDasx/uw134lBUA82m51Dk+mxc+m4trZZpNL/Y9OJ4EMGY
         iF2tHqrPyUZadCeLZmxwkaqD+JcTfnizJeKAVWMcjIOST9aWWmXOQB9mR5LlQHHsjC4E
         5KicyxZK+yGkwCNymd+HPXmwwJwj9d6vmgh4Y=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: yhlu.kernel@gmail.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 8/8] x86: apic - unify smp_apic_timer_interrupt
Date: Sat, 23 Aug 2008 17:01:25 +0400
Message-Id: <770f9ab03c2f99a7910cd2c9aece885cf668b3ed.1219491572.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.6.gc667
In-Reply-To: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
References: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
References: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |    3 +++
 arch/x86/kernel/apic_64.c |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 0c608ac..a7193cb 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -718,6 +718,9 @@ void smp_apic_timer_interrupt(struct pt_regs *regs)
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
+#ifdef CONFIG_X86_64
+	exit_idle();
+#endif
 	irq_enter();
 	local_apic_timer_interrupt();
 	irq_exit();
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 99b5f97..bcfa91d 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -617,7 +617,9 @@ void smp_apic_timer_interrupt(struct pt_regs *regs)
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
+#ifdef CONFIG_X86_64
 	exit_idle();
+#endif
 	irq_enter();
 	local_apic_timer_interrupt();
 	irq_exit();
-- 
1.6.0.6.gc667

