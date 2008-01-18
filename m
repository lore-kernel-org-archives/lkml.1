Return-Path: <linux-kernel-owner+w=401wt.eu-S932232AbYARUFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbYARUFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765459AbYARUEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:04:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765329AbYARUEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:04:30 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 3/10] provide a native_init_IRQ function to x86_64
Date: Fri, 18 Jan 2008 15:20:18 -0200
Message-Id: <12006768473571-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1200676842822-git-send-email-gcosta@redhat.com>
References: <12006768251548-git-send-email-gcosta@redhat.com> <12006768362108-git-send-email-gcosta@redhat.com> <1200676842822-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 lacks a native_init_IRQ() function, so we turn the arch's
init_IRQ() function into a native construct

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/i8259_64.c  |    4 +++-
 include/asm-x86/hw_irq_64.h |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/i8259_64.c b/arch/x86/kernel/i8259_64.c
index cba13e0..738517e 100644
--- a/arch/x86/kernel/i8259_64.c
+++ b/arch/x86/kernel/i8259_64.c
@@ -456,7 +456,9 @@ void __init init_ISA_irqs (void)
 	}
 }
 
-void __init init_IRQ(void)
+void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
+
+void __init native_init_IRQ(void)
 {
 	int i;
 
diff --git a/include/asm-x86/hw_irq_64.h b/include/asm-x86/hw_irq_64.h
index a346159..312a58d 100644
--- a/include/asm-x86/hw_irq_64.h
+++ b/include/asm-x86/hw_irq_64.h
@@ -141,6 +141,7 @@ extern void print_IO_APIC(void);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int slot, int fn);
 extern void send_IPI(int dest, int vector);
 extern void setup_ioapic_dest(void);
+extern void native_init_IRQ(void);
 
 extern unsigned long io_apic_irqs;
 
-- 
1.4.4.2

