Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZERNLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZERNLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 09:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZERNLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 09:11:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:7086 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZERNLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 09:11:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=acxdHXkyNegvN38IANbg06Mdg4bEkFGEGRc9GiWZWI3jFcRJIcyA2U72/GnD1W5+Ty
         1YRb/k7cZG/jI02XO/bIB8IF9xLvFSP9u4e7HMDpL2+dFIS+aklLF+YaJ+L5n9lgLd8y
         lsHxNh0FJi1sUw4P7dEiMiC4RdT+aMDzciaqY=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 1/2] parport_gsc: fix printk format warning
Date: Mon, 18 May 2009 17:10:52 +0400
Message-Id: <1242652252-1835-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build warning:
drivers/parport/parport_gsc.c:356: warning: format '%lx' expects type
'long unsigned int', but argument 2 has type 'resource_size_t'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/parport/parport_gsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 6531db2..51d4866 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -353,7 +353,7 @@ static int __devinit parport_init_chip(struct parisc_device *dev)
 
 	if (!dev->irq) {
 		printk(KERN_WARNING "IRQ not found for parallel device at 0x%lx\n",
-			dev->hpa.start);
+			(unsigned long)dev->hpa.start);
 		return -ENODEV;
 	}
 
-- 
1.6.2.5

