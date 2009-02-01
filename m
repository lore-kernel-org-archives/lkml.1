Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZBAPxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZBAPxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 10:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZBAPxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 10:53:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:44602 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbZBAPxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 10:53:22 -0500
Subject: [PATCH -tip] x86: irqinit_32.c fix compilation warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 01 Feb 2009 21:22:54 +0530
Message-Id: <1233503574.5737.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix:
  arch/x86/kernel/irqinit_32.c:124: warning: 'smp_intr_init' defined but not used

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/irqinit_32.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index ddf3eb7..09cc049 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -120,9 +120,10 @@ int vector_used_by_percpu_irq(unsigned int vector)
 	return 0;
 }
 
+#ifdef CONFIG_X86_LOCAL_APIC
 static void __init smp_intr_init(void)
 {
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
 	 * IPI, driven by wakeup.
@@ -151,6 +152,7 @@ static void __init smp_intr_init(void)
 	set_bit(IRQ_MOVE_CLEANUP_VECTOR, used_vectors);
 #endif
 }
+#endif
 
 static void __init apic_intr_init(void)
 {
-- 
1.6.1



