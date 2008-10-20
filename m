Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbYJTKyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbYJTKyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 06:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYJTKy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 06:54:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61007 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbYJTKy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 06:54:28 -0400
Message-ID: <48FC6310.7020808@cn.fujitsu.com>
Date: Mon, 20 Oct 2008 18:53:04 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Subject: [PATCH v2] Fix debugfs_create_file's error checking method for usb/gadget/
References: <Pine.LNX.4.44L0.0810171114500.2178-100000@iolanthe.rowland.org> <4F580DA88E8146FC8BDA0789613AB813@zhaoleiwin> <20081020034639.GB26650@kroah.com>
In-Reply-To: <20081020034639.GB26650@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs_create_file() returns NULL if an error occurs, returns -ENODEV
when debugfs is not enabled in the kernel.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 drivers/usb/gadget/s3c2410_udc.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index 48f51b1..00ba06b 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1894,11 +1894,8 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
 		udc->regs_info = debugfs_create_file("registers", S_IRUGO,
 				s3c2410_udc_debugfs_root,
 				udc, &s3c2410_udc_debugfs_fops);
-		if (IS_ERR(udc->regs_info)) {
-			dev_warn(dev, "debugfs file creation failed %ld\n",
-				 PTR_ERR(udc->regs_info));
-			udc->regs_info = NULL;
-		}
+		if (!udc->regs_info)
+			dev_warn(dev, "debugfs file creation failed\n");
 	}
 
 	dev_dbg(dev, "probe ok\n");
-- 
1.5.5.3


