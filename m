Return-Path: <linux-kernel-owner+w=401wt.eu-S932071Ab0AEAsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0AEAsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287Ab0AEAfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:13 -0500
Received: from kroah.org ([198.145.64.141]:34191 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab0AEAfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:03 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nicolas Ferre <nicolas.ferre@atmel.com>,
       Dan Williams <dan.j.williams@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/97] dma: at_hdmac: correct incompatible type for argument 1 of 'spin_lock_bh'
Date: Mon,  4 Jan 2010 16:32:43 -0800
Message-Id: <1262651630-7354-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 4297a462f455e38f08976df7b16c849614a287da upstream.

Correct a typo error in locking calls.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/dma/at_hdmac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 7585c41..c558fa1 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -815,7 +815,7 @@ atc_is_tx_complete(struct dma_chan *chan,
 	dev_vdbg(chan2dev(chan), "is_tx_complete: %d (d%d, u%d)\n",
 			cookie, done ? *done : 0, used ? *used : 0);
 
-	spin_lock_bh(atchan->lock);
+	spin_lock_bh(&atchan->lock);
 
 	last_complete = atchan->completed_cookie;
 	last_used = chan->cookie;
@@ -830,7 +830,7 @@ atc_is_tx_complete(struct dma_chan *chan,
 		ret = dma_async_is_complete(cookie, last_complete, last_used);
 	}
 
-	spin_unlock_bh(atchan->lock);
+	spin_unlock_bh(&atchan->lock);
 
 	if (done)
 		*done = last_complete;
-- 
1.6.6

