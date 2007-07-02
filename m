Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbXGBWgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbXGBWgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbXGBWfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:35:33 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:59370 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbXGBWfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:35:31 -0400
Date: Mon, 02 Jul 2007 15:34:59 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 2/4] dma: make dma pool to use kmalloc_node
In-reply-to: <200706291326.43563.yinghai.lu@sun.com>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707021534.59944.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200706291326.43563.yinghai.lu@sun.com>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/4] dma: make dma pool to use kmalloc_node

Using dev_to_node(&dev->dev) to get node, and kmalloc_node to dma buffer on corresding node dma pool

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/base/dmapool.c b/drivers/base/dmapool.c
index 91970e9..7647abf 100644
--- a/drivers/base/dmapool.c
+++ b/drivers/base/dmapool.c
@@ -127,7 +127,7 @@ dma_pool_create (const char *name, struct device *dev,
 	} else if (allocation < size)
 		return NULL;
 
-	if (!(retval = kmalloc (sizeof *retval, GFP_KERNEL)))
+	if (!(retval = kmalloc_node (sizeof *retval, GFP_KERNEL, dev_to_node(dev))))
 		return retval;
 
 	strlcpy (retval->name, name, sizeof retval->name);
