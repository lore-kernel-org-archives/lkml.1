Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYHXJF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYHXJF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbYHXJDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbYHXJDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LYQYEnBKqI+YadQ1pKHK3TBdjHG0yY1EkrkvlV26nR3rqJVN0xvwsojvM4whOaPiZ2
         i0LpZCcicT+yk/2t9ukZU5UV+LxtT/hXhSAYPy+2H5/Ijw9olv43JXQZYCj4O6rX5YiY
         1GS599zZTDS6Qdz8J0SKg+4DICuzscMdoWNis=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 07/18] x86: apic - unify smp_apic_timer_interrupt
Date: Sun, 24 Aug 2008 02:01:45 -0700
Message-Id: <1219568516-681-8-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_32.c |    3 +++
 arch/x86/kernel/apic_64.c |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 63bebb3..0f52bdd 100644
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
index 283968d..2e10911 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -625,7 +625,9 @@ void smp_apic_timer_interrupt(struct pt_regs *regs)
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
1.5.4.5

