Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbXIDIGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbXIDIGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 04:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbXIDIFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 04:05:44 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:40723 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbXIDIFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 04:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=MF4C47nIIC1nk6K0FAi55A0wLfVF2ydOmkb5aD1AXLgrOBx4zDYNt1OXu9f0ZAPPV7/C4mIGpKlV06M3nIGwOhqvCEO4TRIA9UxeY7HxXKhkupsYoCHHzpLuxbBFcFJvmer8uLsdLuSdzGKn1opLNZqoTw/97v+5Zv5uCpjxGoU=
Message-ID: <46DD121A.2010404@gmail.com>
Date: Tue, 04 Sep 2007 16:06:50 +0800
From: Micah Gruber <micah.gruber@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] Fix a potential NULL pointer dereference in uli526x_interrupt()
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
-	unsigned long ioaddr;
+	unsigned long ioaddr = dev->base_addr;
 	unsigned long flags;
 
 	if (!dev) {
@@ -671,8 +671,6 @@
 		return IRQ_NONE;
 	}
 
-	ioaddr = dev->base_addr;
-
 	spin_lock_irqsave(&db->lock, flags);
 	outl(0, ioaddr + DCR7);

