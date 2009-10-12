Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZJLNug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZJLNug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbZJLNuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:50:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39745 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035AbZJLNue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:50:34 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH] USB: musb: invert arch depend string
Date: Mon, 12 Oct 2009 09:49:56 -0400
Message-Id: <1255355396-20533-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <20091012074221.GA19198@elte.hu>
References: <20091012074221.GA19198@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MUSB code relies on platform implementations that currently only
exists for Arm and Blackfin processors, so have the MUSB Kconfig depend
upon those arches.

This should prevent other arches from building MUSB via randconfig.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/musb/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 760e727..b84abd8 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -9,7 +9,7 @@ comment "Enable Host or Gadget support to see Inventra options"
 # (M)HDRC = (Multipoint) Highspeed Dual-Role Controller
 config USB_MUSB_HDRC
 	depends on (USB || USB_GADGET)
-	depends on !SUPERH
+	depends on (ARM || BLACKFIN)
 	select NOP_USB_XCEIV if ARCH_DAVINCI
 	select TWL4030_USB if MACH_OMAP_3430SDP
 	select NOP_USB_XCEIV if MACH_OMAP3EVM
-- 
1.6.5.rc2

