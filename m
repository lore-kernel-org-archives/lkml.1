Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbXGBLKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbXGBLKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 07:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbXGBLKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 07:10:13 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:20422 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbXGBLKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 07:10:12 -0400
Date: Mon, 2 Jul 2007 15:04:53 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: pe1rxq@amsat.org, v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] se401: fix "&& 0x" typo
Message-ID: <20070702110453.GA6634@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Code there survived trivial regexp made earlier, but after bulk preprocessing
was done...

===>	if (!cp[2] && 0x40) {	<===
		printk("<3>" "%s: " "Bayer format not supported!" ...
		return 1;
	}


NOTE: to me, check or error message should be reverted, but I know nothing
about this driver.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/media/video/se401.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/se401.c
+++ b/drivers/media/video/se401.c
@@ -1280,7 +1280,7 @@ static int se401_init(struct usb_se401 *se401, int button)
 	rc=se401_sndctrl(0, se401, SE401_REQ_GET_HEIGHT, 0, cp, sizeof(cp));
 	se401->cheight=cp[0]+cp[1]*256;
 
-	if (!cp[2] && SE401_FORMAT_BAYER) {
+	if (!(cp[2] & SE401_FORMAT_BAYER)) {
 		err("Bayer format not supported!");
 		return 1;
 	}

