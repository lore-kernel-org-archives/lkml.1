Return-Path: <linux-kernel-owner+w=401wt.eu-S933443AbZDIMin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443AbZDIMin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933323AbZDIMib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:38:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:53237 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761631AbZDIMia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:38:30 -0400
Subject: [PATCH -tip] x86: irq.c declare smp_generic_interrupt before they
 get used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 18:08:08 +0530
Message-Id: <1239280688.11859.20.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix sparse warning:
  arch/x86/kernel/irq.c:245:6: warning: symbol 'smp_generic_interrupt' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/irq.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index f38481b..5c71f4f 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -42,6 +42,7 @@ extern void native_init_IRQ(void);
 extern bool handle_irq(unsigned irq, struct pt_regs *regs);
 
 extern unsigned int do_IRQ(struct pt_regs *regs);
+extern void smp_generic_interrupt(struct pt_regs *regs);
 
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
-- 
1.6.0.6



