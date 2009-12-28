Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbZL1LGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbZL1LGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZL1LGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:06:14 -0500
Received: from smtp.nokia.com ([192.100.122.230]:17518 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZL1LGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:06:11 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCH 4/4] usb: otg: twl4030: move to request_threaded_irq
Date: Mon, 28 Dec 2009 13:02:48 +0200
Message-Id: <1261998172-29760-1-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Patchwork-Id: 67249
X-OriginalArrivalTime: 28 Dec 2009 11:04:30.0919 (UTC) FILETIME=[87B26D70:01CA87AD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move to request_threaded_irq() on twl4030 children.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>

---

resending because it wasn't applied before

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
