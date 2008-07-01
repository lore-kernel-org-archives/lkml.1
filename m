Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbYGAI33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbYGAI33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbYGAI21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:28:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:36880 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbYGAI2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:28:19 -0400
Date: Tue, 1 Jul 2008 09:28:00 +0100
From: Eugene Teo <eugeneteo@kernel.sg>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@redhat.com>
Subject: [PATCH] hamradio: add missing sanity check to tty operation
Message-ID: <20080701082800.GA25223@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing sanity check to tty operation.

Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Eugene Teo <eteo@redhat.com>
---
 drivers/net/hamradio/mkiss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 6516603..cdebc09 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -546,7 +546,7 @@ static int ax_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 
 		printk(KERN_ERR "mkiss: %s: transmit timed out, %s?\n", dev->name,
-		       (ax->tty->ops->chars_in_buffer(ax->tty) || ax->xleft) ?
+		       (tty_chars_in_buffer(ax->tty) || ax->xleft) ?
 		       "bad line quality" : "driver error");
 
 		ax->xleft = 0;
-- 
1.5.5.1

