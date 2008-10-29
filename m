Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYJ2WgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYJ2WgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYJ2Wfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:35:55 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:38414 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbYJ2Wfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:35:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: hjk@linutronix.de, gregkh@suse.de, damm@igel.co.jp
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] UIO: uio_pdrv_genirq: allow custom irq_flags
Date: Wed, 29 Oct 2008 18:35:52 -0400
Message-Id: <1225319752-659-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't think of a reason why the driver prevents people from setting any
custom bits in their platform device, but I can think of some reasons for
allowing custom flags.  Like setting the IRQF_TRIGGER_... bits.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- disallow IRQF_SHARED in irq_flags

 drivers/uio/uio_pdrv_genirq.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 1f82c83..3f06818 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -81,7 +81,8 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 		goto bad0;
 	}
 
-	if (uioinfo->handler || uioinfo->irqcontrol || uioinfo->irq_flags) {
+	if (uioinfo->handler || uioinfo->irqcontrol ||
+	    uioinfo->irq_flags & IRQF_SHARED) {
 		dev_err(&pdev->dev, "interrupt configuration error\n");
 		goto bad0;
 	}
@@ -132,7 +133,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	 * Interrupt sharing is not supported.
 	 */
 
-	uioinfo->irq_flags = IRQF_DISABLED;
+	uioinfo->irq_flags |= IRQF_DISABLED;
 	uioinfo->handler = uio_pdrv_genirq_handler;
 	uioinfo->irqcontrol = uio_pdrv_genirq_irqcontrol;
 	uioinfo->priv = priv;
-- 
1.6.0.2

