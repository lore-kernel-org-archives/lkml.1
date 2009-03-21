Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbZCUKX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbZCUKX2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZCUKXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:23:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:46819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZCUKXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:23:19 -0400
Subject: [PATCH -tip] x86: apic/io_apic fix compilation warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Mar 2009 15:52:47 +0530
Message-Id: <1237630967.2409.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

Is this fix looks OK to you:

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Sat, 21 Mar 2009 15:41:17 +0530
Subject: [PATCH] x86: apic/io_apic fix compilation warning

Fix:
 arch/x86/kernel/apic/io_apic.c:1431: warning: ‘msi_ir_chip’ defined but not used

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/apic/io_apic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d882c03..3ca7838 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1428,7 +1428,6 @@ void __setup_vector_irq(int cpu)
 
 static struct irq_chip ioapic_chip;
 static struct irq_chip ir_ioapic_chip;
-static struct irq_chip msi_ir_chip;
 
 #define IOAPIC_AUTO     -1
 #define IOAPIC_EDGE     0
@@ -3402,6 +3401,8 @@ static struct irq_chip msi_ir_chip = {
 #endif
 	.retrigger	= ioapic_retrigger_irq,
 };
+#else
+static struct irq_chip msi_ir_chip;
 #endif
 
 /*
-- 
1.6.0.6



