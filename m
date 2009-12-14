Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZLNKcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZLNKcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZLNKcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:32:14 -0500
Received: from smtp.nokia.com ([192.100.122.230]:31158 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbZLNKcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:32:10 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Aaro Koskinen <aaro.koskinen@nokia.com>,
       David Brownell <david-b@pacbell.net>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@openedhand.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [RFC/PATCH 4/4] usb: otg: twl4030: move to request_threaded_irq
Date: Mon, 14 Dec 2009 12:30:54 +0200
Message-Id: <1260786654-13294-5-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
In-Reply-To: <20091212183410.GF3092@sirena.org.uk>
References: <20091212183410.GF3092@sirena.org.uk>
X-OriginalArrivalTime: 14 Dec 2009 10:31:39.0858 (UTC) FILETIME=[9F11E320:01CA7CA8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move to request_threaded_irq() on twl4030 children.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/usb/otg/twl4030-usb.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index bd9883f..36bcd5f 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -576,14 +576,6 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 	struct twl4030_usb *twl = _twl;
 	int status;
 
-#ifdef CONFIG_LOCKDEP
-	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
-	 * we don't want and can't tolerate.  Although it might be
-	 * friendlier not to borrow this thread context...
-	 */
-	local_irq_enable();
-#endif
-
 	status = twl4030_usb_linkstat(twl);
 	if (status != USB_LINK_UNKNOWN) {
 
@@ -702,7 +694,7 @@ static int __devinit twl4030_usb_probe(struct platform_device *pdev)
 	 * need both handles, otherwise just one suffices.
 	 */
 	twl->irq_enabled = true;
-	status = request_irq(twl->irq, twl4030_usb_irq,
+	status = request_threaded_irq(twl->irq, NULL, twl4030_usb_irq,
 			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 			"twl4030_usb", twl);
 	if (status < 0) {
-- 
1.6.6.rc0

