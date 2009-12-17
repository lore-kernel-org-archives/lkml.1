Return-Path: <linux-kernel-owner+w=401wt.eu-S936067AbZLQBgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936067AbZLQBgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936047AbZLQBfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:35:40 -0500
Received: from kroah.org ([198.145.64.141]:48017 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763639AbZLQBUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:33 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:04 2009
Message-Id: <20091217011604.354502244@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [49/90] b44: Fix wedge when using netconsole.
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 0cae200eec6330cd2c20b24279597be1da50dc93 ]

Fixes kernel bugzilla #14691

Due to the way netpoll works, it is perfectly legal to see
NAPI already scheduled when new device events are pending
in b44_interrupt().

So logging a message about it is wrong and in fact harmful.

Based upon a patch by Andreas Mohr.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/b44.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -913,9 +913,6 @@ static irqreturn_t b44_interrupt(int irq
 			bp->istat = istat;
 			__b44_disable_ints(bp);
 			__napi_schedule(&bp->napi);
-		} else {
-			printk(KERN_ERR PFX "%s: Error, poll already scheduled\n",
-			       dev->name);
 		}
 
 irq_ack:


