Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbXJAP6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbXJAP6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbXJAP6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:58:07 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:46722 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684AbXJAP6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:58:05 -0400
Date: Mon, 01 Oct 2007 09:57:33 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/6] Xilinxfb: add banner output to probe routine when DEBUG	is
 defined
In-reply-to: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
To: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       akonovalov@ru.mvista.com, linuxppc@ozlabs.org, adaplas@gmail.com
Message-id: <20071001155733.6114.71740.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Debug support: when DEBUG is defined, output relevant details to the
log about the framebuffer registration.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/video/xilinxfb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 4bc67ab..1a5f1e4 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -287,6 +287,11 @@ xilinxfb_drv_probe(struct device *dev)
 		goto failed4;
 	}
 
+	/* Put a banner in the log (for DEBUG) */
+	dev_dbg(dev, "regs: phys=%x, virt=%p\n",
+		drvdata->regs_phys, drvdata->regs);
+	dev_dbg(dev, "fb: phys=%p, virt=%p, size=%x\n",
+		(void*)drvdata->fb_phys, drvdata->fb_virt, FB_SIZE);
 	return 0;	/* success */
 
 failed4:

