Return-Path: <linux-kernel-owner+w=401wt.eu-S933711AbZIPXjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711AbZIPXjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933672AbZIPXiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:38:55 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45314 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760636AbZIPXiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:38:52 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 10/11] USB: musb: Blackfin code needs NOP_USB_XCEIV too
Date: Wed, 16 Sep 2009 19:38:44 -0400
Message-Id: <1253144325-1203-10-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
References: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Otherwise we get the link failure:
drivers/built-in.o: In function 'musb_platform_init':
drivers/usb/musb/blackfin.c:300: undefined reference to 'usb_nop_xceiv_register'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/musb/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 2fb3216..06135a1 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -11,9 +11,8 @@ config USB_MUSB_HDRC
 	depends on (USB || USB_GADGET) && HAVE_CLK
 	depends on !SUPERH
 	depends on !BLACKFIN || (BF54x && !BF544) || (BF52x && !BF522 && !BF523)
-	select NOP_USB_XCEIV if ARCH_DAVINCI
+	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
 	select TWL4030_USB if MACH_OMAP_3430SDP
-	select NOP_USB_XCEIV if MACH_OMAP3EVM
 	select USB_OTG_UTILS
 	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
 	help
-- 
1.6.5.rc1

