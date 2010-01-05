Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744Ab0AEUP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab0AEUP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412Ab0AEUPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:15:31 -0500
Received: from kroah.org ([198.145.64.141]:49941 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab0AEUGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:02:59 2010
Message-Id: <20100105200259.553250690@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Dan Williams <dan.j.williams@intel.com>
Subject: [05/39] dma: at_hdmac: correct incompatible type for argument 1 of spin_lock_bh
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 4297a462f455e38f08976df7b16c849614a287da upstream.

Correct a typo error in locking calls.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dma/at_hdmac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -813,7 +813,7 @@ atc_is_tx_complete(struct dma_chan *chan
 	dev_vdbg(chan2dev(chan), "is_tx_complete: %d (d%d, u%d)\n",
 			cookie, done ? *done : 0, used ? *used : 0);
 
-	spin_lock_bh(atchan->lock);
+	spin_lock_bh(&atchan->lock);
 
 	last_complete = atchan->completed_cookie;
 	last_used = chan->cookie;
@@ -828,7 +828,7 @@ atc_is_tx_complete(struct dma_chan *chan
 		ret = dma_async_is_complete(cookie, last_complete, last_used);
 	}
 
-	spin_unlock_bh(atchan->lock);
+	spin_unlock_bh(&atchan->lock);
 
 	if (done)
 		*done = last_complete;


