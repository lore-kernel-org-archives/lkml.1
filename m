Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbXHVIY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbXHVIY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbXHVIYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:24:20 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:58310 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbXHVIYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:24:11 -0400
Subject: [PATCH] ppc: remove unused sys_free_irq
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, galak@kernel.crashing.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 22 Aug 2007 17:24:09 +0900
Message-Id: <1187771049.25624.26.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sys_free_irq is never used, so delete it.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.23-rc3-orig/arch/ppc/amiga/ints.c linux-2.6.23-rc3/arch/ppc/amiga/ints.c
--- linux-2.6.23-rc3-orig/arch/ppc/amiga/ints.c	2007-08-22 17:14:32.000000000 +0900
+++ linux-2.6.23-rc3/arch/ppc/amiga/ints.c	2007-08-22 17:15:27.000000000 +0900
@@ -75,23 +75,6 @@ irq_node_t *new_irq_node(void)
 	return NULL;
 }
 
-void sys_free_irq(unsigned int irq, void *dev_id)
-{
-	if (irq < IRQ1 || irq > IRQ7) {
-		printk("%s: Incorrect IRQ %d\n", __FUNCTION__, irq);
-		return;
-	}
-
-	if (irq_list[irq].dev_id != dev_id)
-		printk("%s: Removing probably wrong IRQ %d from %s\n",
-		       __FUNCTION__, irq, irq_list[irq].devname);
-
-	irq_list[irq].handler = (*mach_default_handler)[irq];
-	irq_list[irq].flags   = 0;
-	irq_list[irq].dev_id  = NULL;
-	irq_list[irq].devname = default_names[irq];
-}
-
 asmlinkage void process_int(unsigned long vec, struct pt_regs *fp)
 {
 	if (vec >= VEC_INT1 && vec <= VEC_INT7 && !MACH_IS_BVME6000) {


