Return-Path: <linux-kernel-owner+w=401wt.eu-S933658AbZIPXiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658AbZIPXiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933588AbZIPXis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:38:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45284 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760577AbZIPXiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:38:46 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>,
       Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 04/11] USB: musb: update Blackfin processor dependency
Date: Wed, 16 Sep 2009 19:38:38 -0400
Message-Id: <1253144325-1203-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
References: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Do not allow MUSB driver to be selected on derivatives that don't have the
MUSB controller on them.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/musb/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 803adcb..2fb3216 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -10,6 +10,7 @@ comment "Enable Host or Gadget support to see Inventra options"
 config USB_MUSB_HDRC
 	depends on (USB || USB_GADGET) && HAVE_CLK
 	depends on !SUPERH
+	depends on !BLACKFIN || (BF54x && !BF544) || (BF52x && !BF522 && !BF523)
 	select NOP_USB_XCEIV if ARCH_DAVINCI
 	select TWL4030_USB if MACH_OMAP_3430SDP
 	select NOP_USB_XCEIV if MACH_OMAP3EVM
-- 
1.6.5.rc1

