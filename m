Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbXGXCk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbXGXCk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 22:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbXGXCkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 22:40:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:50839 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbXGXCkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 22:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=W9X/5zZerSJQYGo9U2t6W0oHCmQ8P8WkS178w6IIGk58OchVa0XOAdgHmkUUkok79IGuIQ0XvM6Y98hptycke2C398p9EblvGOQOhik1u8QWkkQ0raMiFLxzuilR/cpESv90agArcKLGgXTylCsX4IAJsgI23e4QSttV1aDv/fM=
Message-ID: <46A567A8.6050409@gmail.com>
Date: Tue, 24 Jul 2007 10:44:56 +0800
From: Micah Gruber <micah.gruber@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] [2.6.22] Fix a potential NULL pointer dereference in mace_interrupt()
 in drivers/net/pcmcia/nmclan_cs.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a potential null dereference bug where we dereference 
DEV before a null check. This patch simply moves the dereferencing after 
the null check.

Signed-off-by: Micah Gruber <micah.gruber@gmail.com>

---

--- a/drivers/net/pcmcia/nmclan_cs.c    
+++ b/drivers/net/pcmcia/nmclan_cs.c    
@@ -996,7 +996,7 @@
 {
   struct net_device *dev = (struct net_device *) dev_id;
   mace_private *lp = netdev_priv(dev);
-  kio_addr_t ioaddr = dev->base_addr;
+  kio_addr_t ioaddr;
   int status;
   int IntrCnt = MACE_MAX_IR_ITERATIONS;

@@ -1006,6 +1006,8 @@
     return IRQ_NONE;
   }

+  ioaddr = dev->base_addr;
+
   if (lp->tx_irq_disabled) {
     printk(
       (lp->tx_irq_disabled?

