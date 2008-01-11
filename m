Return-Path: <linux-kernel-owner+w=401wt.eu-S1761965AbYAKSRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761965AbYAKSRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 13:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760223AbYAKSR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 13:17:26 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58983 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760203AbYAKSRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 13:17:25 -0500
Date: Fri, 11 Jan 2008 18:14:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: [PATCH] serverworks: IRQ routing needs no _p
Message-ID: <20080111181434.3dec6206@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can find no reason for the _p on the serverworks IRQ routing logic, and
a review of the documentation contains no indication that any such delay
is needed so lets try this

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/arch/x86/pci/irq.c linux-2.6.24-rc6-mm1/arch/x86/pci/irq.c
--- linux.vanilla-2.6.24-rc6-mm1/arch/x86/pci/irq.c	2008-01-02 16:04:19.000000000 +0000
+++ linux-2.6.24-rc6-mm1/arch/x86/pci/irq.c	2008-01-11 15:21:17.000000000 +0000
@@ -461,14 +461,14 @@
  */
 static int pirq_serverworks_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
 {
-	outb_p(pirq, 0xc00);
+	outb(pirq, 0xc00);
 	return inb(0xc01) & 0xf;
 }
 
 static int pirq_serverworks_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
 {
-	outb_p(pirq, 0xc00);
-	outb_p(irq, 0xc01);
+	outb(pirq, 0xc00);
+	outb(irq, 0xc01);
 	return 1;
 }
 
