Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXGCOIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXGCOIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbXGCOHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:07:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58835 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754576AbXGCOHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:07:51 -0400
Date: Tue, 3 Jul 2007 15:14:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pata_pcmcia: Switch to ata_sff_port_start
Message-ID: <20070703151405.4ffb1ece@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PCMCIA doesn't use DMA and as this driver is used on many platforms we
don't want it to fail on those that define the DMA alloc API as a NULL
return

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_pcmcia.c linux-2.6.22-rc6-mm1/drivers/ata/pata_pcmcia.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_pcmcia.c	2007-07-02 20:48:49.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/ata/pata_pcmcia.c	2007-07-02 21:04:38.000000000 +0100
@@ -129,7 +129,7 @@
 	.irq_on		= ata_irq_on,
 	.irq_ack	= ata_irq_ack,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 #define CS_CHECK(fn, ret) \
