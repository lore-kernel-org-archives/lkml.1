Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbZCOSZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbZCOSZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbZCOSY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:24:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:42367 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbZCOSY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:24:57 -0400
Date: Sun, 15 Mar 2009 11:25:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH] ide/net: flip the order of SATA and network init
Message-ID: <20090315112503.686b1e73@infradead.org>
In-Reply-To: <20090315112345.764fc4ac@infradead.org>
References: <20090315112345.764fc4ac@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7c73393acfcce11a8d8ee661e08bae24fc17af61 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 26 Jan 2009 18:58:11 -0800
Subject: [PATCH] ide/net: flip the order of SATA and network init

this patch flips the order in which sata and network drivers are initialized.

SATA probing takes quite a bit of time, and with the asynchronous infrastructure
other drivers that run after it can execute in parallel. Network drivers do tend
to take some real time talking to the hardware, so running these later is
a good thing (the sata probe then runs concurrent)

This saves about 15% of my kernels boot time.

Both Dave and Jeff acked this patch and suggested it should go via the async
tree.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/Makefile |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index c1bf417..2618a61 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -36,13 +36,14 @@ obj-$(CONFIG_FB_INTEL)          += video/intelfb/
 
 obj-y				+= serial/
 obj-$(CONFIG_PARPORT)		+= parport/
-obj-y				+= base/ block/ misc/ mfd/ net/ media/
+obj-y				+= base/ block/ misc/ mfd/ media/
 obj-$(CONFIG_NUBUS)		+= nubus/
-obj-$(CONFIG_ATM)		+= atm/
 obj-y				+= macintosh/
 obj-$(CONFIG_IDE)		+= ide/
 obj-$(CONFIG_SCSI)		+= scsi/
 obj-$(CONFIG_ATA)		+= ata/
+obj-y				+= net/
+obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_FUSION)		+= message/
 obj-$(CONFIG_FIREWIRE)		+= firewire/
 obj-y				+= ieee1394/
-- 
1.6.0.6




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
