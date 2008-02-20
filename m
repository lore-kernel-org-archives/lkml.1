Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbYBTAQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbYBTAQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763338AbYBTAOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:14:49 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50446 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763017AbYBTAOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:14:47 -0500
Date: Wed, 20 Feb 2008 02:14:10 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] net/9p/trans_virtio.c: kmalloc() enough memory
Message-ID: <20080220001410.GX31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that less memory than required was allocated.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
c9a5f66eca8484c302f848bb117b0bdb57e9ec42 diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 9e3d81c..de7a9f5 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -110,7 +110,7 @@ static struct p9_req_t *p9_lookup_tag(struct virtio_chan *c, u16 tag)
 		}
 		for (count = old_max; count < c->max_tag; count++) {
 			c->reqs[count].status = REQ_STATUS_IDLE;
-			c->reqs[count].wq = kmalloc(sizeof(wait_queue_t),
+			c->reqs[count].wq = kmalloc(sizeof(wait_queue_head_t),
 								GFP_ATOMIC);
 			if (!c->reqs[count].wq) {
 				printk(KERN_ERR "Couldn't grow tag array\n");

