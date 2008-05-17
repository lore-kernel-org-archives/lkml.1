Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbYEQLB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbYEQLB6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 07:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbYEQLBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 07:01:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:52978 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbYEQLBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 07:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references:sender;
        b=kmCzEpEInaOFazMWvZHcsZvpyaOI9Joxs8TCIuUirBEtnzyNBHiXTldHz4O01FRm5VfewhKpXslksapyvqSFHY7nWrefWw+JrsFbwxDAqwxOIlap/AdgD13GOHmETe2mF4iuzj8Wk2zt15sfUj7MQexh3h44sFv/zzK5IUn755s=
From: Bryan Wu <cooloney@kernel.org>
To: me@felipebalbi.com, david-b@pacbell.net, tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 2/2] MUSB: Real fix bug 4 usb bugs found on Blackfin
Date: Sat, 17 May 2008 19:01:21 +0800
Message-Id: <1211022081-27298-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1211022081-27298-1-git-send-email-cooloney@kernel.org>
References: <1211022081-27298-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - USB-IDE
   http://blackfin.uclinux.org/gf/project/linux-kernel/tracker/?action=TrackerItemEdit&tracker_item_id=3789
 - 30G iPod
   http://blackfin.uclinux.org/gf/project/linux-kernel/tracker/?action=TrackerItemEdit&tracker_item_id=3806
 - USB to CF/SD card reader
   http://blackfin.uclinux.org/gf/project/linux-kernel/tracker/?action=TrackerItemEdit&tracker_item_id=3790
   http://blackfin.uclinux.org/gf/project/linux-kernel/tracker/?action=TrackerItemEdit&tracker_item_id=3807

Sonic found, when we got STALL, we should clear the toggle.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/musb/musb_host.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 535922d..806c479 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1473,7 +1473,7 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 			(void) musb->dma_controller->channel_abort(dma);
 			xfer_len = dma->actual_len;
 		}
-		musb_h_flush_rxfifo(hw_ep, 0);
+		musb_h_flush_rxfifo(hw_ep, MUSB_RXCSR_CLRDATATOG);
 		musb_writeb(epio, MUSB_RXINTERVAL, 0);
 		done = true;
 		goto finish;
-- 
1.5.5

