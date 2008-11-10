Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYKJF21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYKJF21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 00:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYKJF2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 00:28:19 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:3260 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbYKJF2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 00:28:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=c2wjO69BtVlGojjW/wm76mX94cB+EwYojY5xieEY8abVQd9ksLPiM7TSJSk6Gts6gW
         XgAFjmEDJuOQadIOq139ci+YzWYouznOVyGAwOViU9tJPZOaXJt6CNrpcc6BKtnp0+iT
         +NY7XFiIIpnHlHNz9r15pb9jCND9pmRIyuKv8=
Subject: [PATCH] x86: x86_32 has its own irq_regs definition
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Nov 2008 21:28:15 -0800
Message-Id: <1226294895.5478.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: prevent second percpu define of unused irq_regs

Arches that have their own irq_regs definition are expected to
define ARCH_HAS_OWN_IRQ_REGS or else a generic (unused) set
will also be defined in lib/irq_regs.c

Sparse noticed the unused generic one had no prototype:
lib/irq_regs.c:15:1: warning: symbol 'per_cpu____irq_regs' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/include/asm/irq_regs_32.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/irq_regs_32.h b/arch/x86/include/asm/irq_regs_32.h
index af2f02d..86afd74 100644
--- a/arch/x86/include/asm/irq_regs_32.h
+++ b/arch/x86/include/asm/irq_regs_32.h
@@ -9,6 +9,8 @@
 
 #include <asm/percpu.h>
 
+#define ARCH_HAS_OWN_IRQ_REGS
+
 DECLARE_PER_CPU(struct pt_regs *, irq_regs);
 
 static inline struct pt_regs *get_irq_regs(void)
-- 
1.6.0.3.866.gc189b



