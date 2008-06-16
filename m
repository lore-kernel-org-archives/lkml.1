Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYFPVps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYFPVps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYFPVpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:45:38 -0400
Received: from gw.goop.org ([64.81.55.164]:45406 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbYFPVpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:45:38 -0400
Message-ID: <4856DED4.9030402@goop.org>
Date: Mon, 16 Jun 2008 14:44:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 1/5] xen/blkfront: Make sure we don't use bounce buffers,
 we don't need them.
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

===================================================================
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


