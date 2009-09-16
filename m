Return-Path: <linux-kernel-owner+w=401wt.eu-S933721AbZIPXji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721AbZIPXji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933676AbZIPXjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:39:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45318 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933628AbZIPXix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:38:53 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 11/11] USB: musb: fix printf warning in debug code
Date: Wed, 16 Sep 2009 19:38:45 -0400
Message-Id: <1253144325-1203-11-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
References: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debug code in the DMA ISR uses a %d for a size_t when it should be
using %zu.  Otherwise gcc whines with:

drivers/usb/musb/musbhsdma.c: In function 'dma_controller_irq':
drivers/usb/musb/musbhsdma.c:288: warning: format '%d' expects type 'int',
	but argument 7 has type 'size_t'

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/musb/musbhsdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/musbhsdma.c b/drivers/usb/musb/musbhsdma.c
index c767387..a237550 100644
--- a/drivers/usb/musb/musbhsdma.c
+++ b/drivers/usb/musb/musbhsdma.c
@@ -285,7 +285,7 @@ static irqreturn_t dma_controller_irq(int irq, void *private_data)
 				channel->actual_len = addr
 					- musb_channel->start_addr;
 
-				DBG(2, "ch %p, 0x%x -> 0x%x (%d / %d) %s\n",
+				DBG(2, "ch %p, 0x%x -> 0x%x (%zu / %d) %s\n",
 					channel, musb_channel->start_addr,
 					addr, channel->actual_len,
 					musb_channel->len,
-- 
1.6.5.rc1

