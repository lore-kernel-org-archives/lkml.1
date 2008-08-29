Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYH2GQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYH2GQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYH2GP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:15:27 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59504 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYH2GP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:26 -0400
Date: Thu, 28 Aug 2008 23:47:40 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5leOa016106@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 1/29] mdb: export ioapic read routines and detected ioapic count
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export ioapic read routines and detected ioapic count.


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/arch/x86/kernel/io_apic_32.c	2008-08-28 14:19:19.000000000 -0600
+++ b/arch/x86/kernel/io_apic_32.c	2008-08-28 16:07:46.000000000 -0600
@@ -75,6 +75,7 @@
 /* I/O APIC entries */
 struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
+EXPORT_SYMBOL(nr_ioapics);
 
 /* MP IRQ source entries */
 struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
@@ -120,12 +121,13 @@
 		+ (mp_ioapics[idx].mp_apicaddr & ~PAGE_MASK);
 }
 
-static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
+unsigned int io_apic_read(unsigned int apic, unsigned int reg)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 	writel(reg, &io_apic->index);
 	return readl(&io_apic->data);
 }
+EXPORT_SYMBOL(io_apic_read);
 
 static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
 {
