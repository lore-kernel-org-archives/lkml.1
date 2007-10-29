Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbXJ2XFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbXJ2XFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXJ2XFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:05:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63113 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbXJ2XFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:05:32 -0400
Date: Mon, 29 Oct 2007 11:19:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] bttv: uses input functions, should depend on INPUT
Message-Id: <20071029111945.7abaeb64.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Several media drivers use input_(*) functions so they need to depend on
the INPUT config symbol.

drivers/built-in.o: In function `bttv_input_fini':
linux-2.6.24-rc1-git4/drivers/media/video/bt8xx/bttv-input.c:346: undefined reference to `input_unregister_device'
drivers/built-in.o: In function `bttv_input_init':
linux-2.6.24-rc1-git4/drivers/media/video/bt8xx/bttv-input.c:204: undefined reference to `input_allocate_device'
linux-2.6.24-rc1-git4/drivers/media/video/bt8xx/bttv-input.c:335: undefined reference to `input_free_device'
linux-2.6.24-rc1-git4/drivers/media/video/bt8xx/bttv-input.c:321: undefined reference to `input_register_device'
linux-2.6.24-rc1-git4/drivers/media/video/bt8xx/bttv-input.c:335: undefined reference to `input_free_device'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/bt8xx/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc1-git4.orig/drivers/media/video/bt8xx/Kconfig
+++ linux-2.6.24-rc1-git4/drivers/media/video/bt8xx/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_BT848
 	tristate "BT848 Video For Linux"
-	depends on VIDEO_DEV && PCI && I2C && VIDEO_V4L1
+	depends on VIDEO_DEV && PCI && I2C && VIDEO_V4L1 && INPUT
 	select I2C_ALGOBIT
 	select FW_LOADER
 	select VIDEO_BTCX
