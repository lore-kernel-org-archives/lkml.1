Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYKJGj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYKJGj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 01:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbYKJGjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 01:39:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50568 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbYKJGjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 01:39:48 -0500
Message-ID: <4917D726.7070406@cn.fujitsu.com>
Date: Mon, 10 Nov 2008 14:39:34 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Ross Cohen <rcohen@snurgle.org>
Subject: [PATCH] staging: fix go7007 build failure
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 25a87bb72b5d391c3f01a623c12ce22bc5bb2467 Mon Sep 17 00:00:00 2001
From: Wang Chen <wangchen@cn.fujitsu.com>
Date: Mon, 10 Nov 2008 14:24:08 +0800
Subject: [PATCH] staging: fix go7007 build failure

Comes from commit: df20d69ec968b33526461457c219ad4ba8ba8ac8
"Staging: go7007 v4l fixes".

CC [M]  drivers/staging/go7007/go7007-v4l2.o
drivers/staging/go7007/go7007-v4l2.c:1457: error: 'VID_TYPE_CAPTURE' undeclared here (not in a function)
make[3]: *** [drivers/staging/go7007/go7007-v4l2.o] Error 1
make[2]: *** [drivers/staging/go7007] Error 2
make[1]: *** [drivers/staging] Error 2
make: *** [drivers] Error 2

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Ross Cohen <rcohen@snurgle.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/go7007/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/go7007/Kconfig b/drivers/staging/go7007/Kconfig
index 593fdb7..409bc5d 100644
--- a/drivers/staging/go7007/Kconfig
+++ b/drivers/staging/go7007/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_GO7007
 	tristate "Go 7007 support"
-	depends on VIDEO_DEV && PCI && I2C && INPUT
+	depends on VIDEO_V4L1_COMPAT && PCI && I2C && INPUT
 	depends on SND
 	select VIDEOBUF_DMA_SG
 	select VIDEO_IR
-- 
1.5.5.1


