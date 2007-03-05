Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbXCELIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbXCELIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933144AbXCELIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:08:16 -0500
Received: from www.osadl.org ([213.239.205.134]:49696 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933082AbXCELIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:08:15 -0500
Subject: [PATCH] Fix compile error in latest git
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 05 Mar 2007 12:08:08 +0100
Message-Id: <1173092888.3417.11.camel@bender.tec.linutronix.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recognized a compile error in latest git:

/here/workdir/git/drivers/net/gianfar.c: In function `gfar_vlan_rx_kill_vid':
/here/workdir/git/drivers/net/gianfar.c:1135: error: structure has no member named `vgrp'

This error was introduced in commit:

commit 6d04e3b04b6ab569cabeb5ca28ad1be11777e895
Merge: 4227003... 5c15bde...
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Sun Mar 4 13:16:49 2007 -0800

    Merge master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6
    
    * master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6:
      [VLAN]: Avoid a 4-order allocation.
      [HDLC] Fix dev->header_cache_update having a random value.
      [NetLabel]: Verify sensitivity level has a valid CIPSO mapping
      [PPPOE]: Key connections properly on local device.
      [AF_UNIX]: Test against sk_max_ack_backlog properly.
      [NET]: Fix bugs in "Whether sock accept queue is full" checking

Patch is attached.

Signed-off-by: Jan Altenberg <jan@linutronix.de>

---
 drivers/net/gianfar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/net/gianfar.c
===================================================================
--- linux-2.6.orig/drivers/net/gianfar.c
+++ linux-2.6/drivers/net/gianfar.c
@@ -1132,7 +1132,7 @@ static void gfar_vlan_rx_kill_vid(struct
 
 	spin_lock_irqsave(&priv->rxlock, flags);
 
-	vlan_group_set_device(priv->vgrp, vid, NULL);
+	vlan_group_set_device(priv->vlgrp, vid, NULL);
 
 	spin_unlock_irqrestore(&priv->rxlock, flags);
 }


