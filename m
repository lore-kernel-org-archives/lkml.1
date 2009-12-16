Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbZLPOgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbZLPOgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762152AbZLPOgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:36:41 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:42534 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762165AbZLPOge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:36:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K9qWBD5ao7PMsks1Pqv0kDeLjV9w8qkKuObUFlHUVMReNq9i2hUGoW5EzAzo9mDgOz
         DgGaSTUDjtFFI6asepiItHxhpjlPzrOq9+0IxgI2DIpz7cGOVyAqozfkaIvRejpxJIM0
         gAZ1V1YyZSjJ7O/i+YaogW4rh0aYQdVdOU0Go=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Li Yang <leoli@freescale.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-usb@vger.kernel.org
Subject: [PATCH 3/5] USB: use DECLARE_COMPLETION_ONSTACK for non-constant completion
Date: Wed, 16 Dec 2009 22:35:59 +0800
Message-Id: <1260974161-6934-4-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1260974161-6934-3-git-send-email-yong.zhang0@gmail.com>
References: <1260974161-6934-1-git-send-email-yong.zhang0@gmail.com>
 <1260974161-6934-2-git-send-email-yong.zhang0@gmail.com>
 <1260974161-6934-3-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _ONSTACK variant should be used for on-stack completion,
otherwise it will break lockdep.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Li Yang <leoli@freescale.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/gadget/fsl_qe_udc.c   |    2 +-
 drivers/usb/gadget/fsl_udc_core.c |    2 +-
 drivers/usb/gadget/langwell_udc.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index 7881f12..5e9e921 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2694,7 +2694,7 @@ static int __devexit qe_udc_remove(struct of_device *ofdev)
 	struct qe_ep *ep;
 	unsigned int size;
 
-	DECLARE_COMPLETION(done);
+	DECLARE_COMPLETION_ONSTACK(done);
 
 	if (!udc_controller)
 		return -ENODEV;
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index fa3d142..e9e4de3 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2399,7 +2399,7 @@ static int __exit fsl_udc_remove(struct platform_device *pdev)
 {
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	DECLARE_COMPLETION(done);
+	DECLARE_COMPLETION_ONSTACK(done);
 
 	if (!udc_controller)
 		return -ENODEV;
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index a391351..ddfe015 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -2903,7 +2903,7 @@ static void langwell_udc_remove(struct pci_dev *pdev)
 {
 	struct langwell_udc	*dev = the_controller;
 
-	DECLARE_COMPLETION(done);
+	DECLARE_COMPLETION_ONSTACK(done);
 
 	BUG_ON(dev->driver);
 	DBG(dev, "---> %s()\n", __func__);
-- 
1.6.3.3

