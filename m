Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbYJQM4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbYJQM4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYJQM4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:56:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52372 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbYJQM4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:56:12 -0400
Message-ID: <48F88B22.6010102@cn.fujitsu.com>
Date: Fri, 17 Oct 2008 20:54:58 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Subject: [PATCH] Fix debugfs_create_file's error checking method for usb/gadget/
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

debugfs_create_file() returns NULL if an error occurs, returns -ENODEV
when debugfs is not enabled in the kernel.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 drivers/usb/gadget/s3c2410_udc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index 29d13eb..4ba50ef 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1894,7 +1894,7 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
 		udc->regs_info = debugfs_create_file("registers", S_IRUGO,
 				s3c2410_udc_debugfs_root,
 				udc, &s3c2410_udc_debugfs_fops);
-		if (IS_ERR(udc->regs_info)) {
+		if (IS_ERR(udc->regs_info) || !udc->regs_info) {
 			dev_warn(dev, "debugfs file creation failed %ld\n",
 				 PTR_ERR(udc->regs_info));
 			udc->regs_info = NULL;
-- 
1.5.5.3


