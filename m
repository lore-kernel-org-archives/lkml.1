Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab0BDR0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:26:41 -0500
Received: from kroah.org ([198.145.64.141]:34932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933359Ab0BDRW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:26 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:24 2010
Message-Id: <20100204171523.776883883@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [63/74] be2net: Fix memset() arg ordering.
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

commit d291b9af1a1a12f59a464494900c6e0db26e2ec3 upstream.

Noticed by Ben Hutchings.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/benet/be_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/benet/be_main.c
+++ b/drivers/net/benet/be_main.c
@@ -2034,7 +2034,7 @@ static int be_stats_init(struct be_adapt
 	cmd->va = pci_alloc_consistent(adapter->pdev, cmd->size, &cmd->dma);
 	if (cmd->va == NULL)
 		return -1;
-	memset(cmd->va, cmd->size, 0);
+	memset(cmd->va, 0, cmd->size);
 	return 0;
 }
 


