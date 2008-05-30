Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbYE3X7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbYE3X7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYE3X6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:58:36 -0400
Received: from host217-43-228-68.range217-43.btcentralplus.com ([217.43.228.68]:37129
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753364AbYE3X6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:58:34 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 5] xen/blkfront: Make sure we don't use bounce buffers,
	we don't need them
X-Mercurial-Node: 967afd96e8ece92cb8636e62de9b0b14aab72047
Message-Id: <967afd96e8ece92cb863.1212191401@localhost>
In-Reply-To: <patchbomb.1212191400@localhost>
Date: Sat, 31 May 2008 00:50:01 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jeff Garzik <jgarzik.pobox.com@goop.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@xensource.com>

[ linux-2.6.18-xen changeset 667228bf8fc5 ]

Signed-off-by: Ian Campbell <ian.campbell@xensource.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -324,6 +324,9 @@
 	/* Make sure buffer addresses are sector-aligned. */
 	blk_queue_dma_alignment(rq, 511);
 
+	/* Make sure we don't use bounce buffers. */
+	blk_queue_bounce_limit(rq, BLK_BOUNCE_ANY);
+
 	gd->queue = rq;
 
 	return 0;


