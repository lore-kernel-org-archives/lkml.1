Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbXIMMfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbXIMMfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 08:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXIMMfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 08:35:05 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:35969 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291AbXIMMfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 08:35:03 -0400
Date: Thu, 13 Sep 2007 14:36:27 +0200
From: aherrman@arcor.de
To: luca.risolia@studio.unibo.it, akpm@linux-foundation.org
Cc: linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] v4l: Build error with et61x251, if V4L1_COMPAT is not selected
Message-ID: <20070913123627.GD10348@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With current git tree I get an build error
for et61x251, if V4L1_COMPAT is not selected:

drivers/media/video/et61x251/et61x251_core.c: In et61x251_show_:
drivers/media/video/et61x251/et61x251_core.c:718: error: implicit declaration of to_video_device

Fix: add VIDEO_V4L1_COMPAT as a dependency for this driver.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
---
 drivers/media/video/et61x251/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/et61x251/Kconfig b/drivers/media/video/et61x251/Kconfig
index dcc1a03..9143424 100644
--- a/drivers/media/video/et61x251/Kconfig
+++ b/drivers/media/video/et61x251/Kconfig
@@ -1,6 +1,6 @@
 config USB_ET61X251
 	tristate "USB ET61X[12]51 PC Camera Controller support"
-	depends on VIDEO_V4L2
+	depends on VIDEO_V4L2 && VIDEO_V4L1_COMPAT
 	---help---
 	  Say Y here if you want support for cameras based on Etoms ET61X151
 	  or ET61X251 PC Camera Controllers.
-- 
1.5.3


