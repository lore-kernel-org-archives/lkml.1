Return-Path: <linux-kernel-owner+w=401wt.eu-S933743AbZIPXkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743AbZIPXkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760615AbZIPXip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:38:45 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45263 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760580AbZIPXio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:38:44 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 02/11] USB: musb: kill compile warning for Blackfin systems
Date: Wed, 16 Sep 2009 19:38:36 -0400
Message-Id: <1253144325-1203-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
References: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan Wu <cooloney@kernel.org>

The Blackfin version of musb_read_target_reg_base() returns a u16 when the
common code expects a (void __iomem *), so update the Blackfin function to
return the right value.  This fixes the compile warning:

drivers/usb/musb/musb_core.c: In function 'musb_core_init':
drivers/usb/musb/musb_core.c:1448: warning: assignment makes pointer from
	integer without a cast

Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/musb/musb_regs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/musb_regs.h b/drivers/usb/musb/musb_regs.h
index fbfd3fd..0154e38 100644
--- a/drivers/usb/musb/musb_regs.h
+++ b/drivers/usb/musb/musb_regs.h
@@ -474,9 +474,9 @@ static inline u16 musb_read_hwvers(void __iomem *mbase)
 	return 0;
 }
 
-static inline u16 musb_read_target_reg_base(u8 i, void __iomem *mbase)
+static inline void __iomem *musb_read_target_reg_base(u8 i, void __iomem *mbase)
 {
-	return 0;
+	return NULL;
 }
 
 static inline void musb_write_rxfunaddr(void __iomem *ep_target_regs,
-- 
1.6.5.rc1

