Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYG1MdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYG1MdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 08:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYG1MdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 08:33:09 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:45537 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbYG1MdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 08:33:08 -0400
Date: Mon, 28 Jul 2008 21:32:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: [PATCH] USB: m66592-udc: Fix up dev_set_name() badness.
Message-ID: <20080728123229.GA15202@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-sh@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0031a06e2f07ab0d1bc98c31dbb6801f95f4bf01 converted all of the USB
drivers to use dev_set_name(), though there was a typo on the m66592-udc
conversion that handed off the wrong pointer (we want the struct device
here obviously, not the struct usb_gadget).

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/usb/gadget/m66592-udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index 8da7535..77b44fb 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -1593,7 +1593,7 @@ static int __init m66592_probe(struct platform_device *pdev)
 
 	m66592->gadget.ops = &m66592_gadget_ops;
 	device_initialize(&m66592->gadget.dev);
-	dev_set_name(&m66592->gadget, "gadget");
+	dev_set_name(&m66592->gadget.dev, "gadget");
 	m66592->gadget.is_dualspeed = 1;
 	m66592->gadget.dev.parent = &pdev->dev;
 	m66592->gadget.dev.dma_mask = pdev->dev.dma_mask;
