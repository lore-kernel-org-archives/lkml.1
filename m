Return-Path: <linux-kernel-owner+w=401wt.eu-S1760955AbZAFWef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955AbZAFWef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbZAFWOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:23 -0500
Received: from kroah.org ([198.145.64.141]:51330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756085AbZAFWOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>, "Hans J. Koch" <hjk@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 57/60] UIO: uio_pdrv_genirq: allow custom irq_flags
Date: Tue,  6 Jan 2009 14:12:16 -0800
Message-Id: <1231279939-32728-57-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

I can't think of a reason why the driver prevents people from setting any
custom bits in their platform device, but I can think of some reasons for
allowing custom flags.  Like setting the IRQF_TRIGGER_... bits.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
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
1.6.0.4

