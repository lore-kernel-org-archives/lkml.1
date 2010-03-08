Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0CHQWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:22:53 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:59874 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab0CHQWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:22:46 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: stable@kernel.org, stable-review@kernel.org, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] USB: musb: fix build error introduced by isoc change
Date: Mon,  8 Mar 2010 11:26:01 -0500
Message-Id: <1268065561-24350-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The recent commit "usb: musb: Fix for isochronous IN transfer" (f82a689fa)
seems to have been against an older kernel version.  It uses the old style
naming of variables.  Unfortunately, this breaks building for most MUSB
users out there since "bDesiredMode" has been renamed to "desired_mode".

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/musb/musb_host.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index d21fffa..ef29f38 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1689,7 +1689,7 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 				dma->desired_mode = 1;
 			if (rx_count < hw_ep->max_packet_sz_rx) {
 				length = rx_count;
-				dma->bDesiredMode = 0;
+				dma->desired_mode = 0;
 			} else {
 				length = urb->transfer_buffer_length;
 			}
-- 
1.7.0

