Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbXIDINQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbXIDINQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 04:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbXIDIM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 04:12:59 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:32561 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbXIDIM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 04:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=CE9o8ufFJy5KT7frvGuQTMwtvoPxc+Zx1aJ9KFF8I2p/6obL/yYqKQSpM0hswMNlA6mel0LbAich8B1/52Q2DJD9oKXymR0xwEclV/y1JsJ/MSZwVXboCYKgH03ppfBl+5esx8wh5u57Qc7hWRMiMktvCzPpY3qGQXCCVxxCesM=
Message-ID: <46DD13CE.6010905@gmail.com>
Date: Tue, 04 Sep 2007 16:14:06 +0800
From: Micah Gruber <micah.gruber@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com
Subject: [CORRECTION][PATCH] Fix a potential NULL pointer dereference in uli526x_interrupt()
 in drivers/net/tulip/uli526x.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a potential null dereference bug where we dereference dev before a null check. This patch simply moves the dereferencing after the null check.

Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
---

--- a/drivers/net/tulip/uli526x.c
+++ b/drivers/net/tulip/uli526x.c
@@ -663,7 +663,7 @@
 {
 	struct net_device *dev = dev_id;
 	struct uli526x_board_info *db = netdev_priv(dev);
-	unsigned long ioaddr = dev->base_addr;
+	unsigned long ioaddr;
 	unsigned long flags;
 
 	if (!dev) {
@@ -671,6 +671,8 @@
 		return IRQ_NONE;
 	}
 
+	ioaddr = dev->base_addr;
+
 	spin_lock_irqsave(&db->lock, flags);
 	outl(0, ioaddr + DCR7);

