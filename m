Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZERNL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZERNL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 09:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZERNLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 09:11:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:7086 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZERNLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 09:11:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YogbXAqSRznQ85SD9EKCulONjSNyVNVih74dwJ/eLSHovg6neWGtth9/HRHMM6XiXK
         2mIKRPTaRFSSxiaL+ND3rtpDGqeu6YziPbWzdRnzucUH/MmknrtHuGMKZ8MQpaFLO09N
         aWVEke+SwdG4WfNEKRerJ/SKSAfBbHKfh7P4Q=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 2/2] serial: 8250_gsc: fix printk format warning
Date: Mon, 18 May 2009 17:11:31 +0400
Message-Id: <1242652291-1868-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build warning:
drivers/serial/8250_gsc.c:44: warning: format '%lx' expects type
'long unsigned int', but argument 2 has type 'resource_size_t'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/serial/8250_gsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250_gsc.c b/drivers/serial/8250_gsc.c
index 418b4fe..a7b02a5 100644
--- a/drivers/serial/8250_gsc.c
+++ b/drivers/serial/8250_gsc.c
@@ -41,7 +41,7 @@ static int __init serial_init_chip(struct parisc_device *dev)
 			printk(KERN_INFO
 				"Serial: device 0x%lx not configured.\n"
 				"Enable support for Wax, Lasi, Asp or Dino.\n",
-				dev->hpa.start);
+				(unsigned long)dev->hpa.start);
 		return -ENODEV;
 	}
 
-- 
1.6.2.5

