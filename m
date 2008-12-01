Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYLAAc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYLAAc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYLAAcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:32:17 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33400 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbYLAAcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:32:16 -0500
Date: Mon, 1 Dec 2008 00:32:04 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Woodhouse <dwmw2@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, Joern Engel <joern@logfs.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Donjun Shin <djshin90@gmail.com>, Tejun Heo <teheo@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, Matt Mackall <mpm@selenic.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/9] swapfile: let others seed random
In-Reply-To: <Pine.LNX.4.64.0811252146090.20455@blonde.site>
Message-ID: <Pine.LNX.4.64.0812010029550.10131@blonde.site>
References: <Pine.LNX.4.64.0811252132580.17555@blonde.site>
 <Pine.LNX.4.64.0811252140230.17555@blonde.site> <Pine.LNX.4.64.0811252146090.20455@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the srandom32((u32)get_seconds()) from non-rotational swapon:
there's been a coincidental discussion of earlier randomization, assume
that goes ahead, let swapon be a client rather than stirring for itself.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
To follow 10/9

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- swapfile10/mm/swapfile.c	2008-11-28 20:36:44.000000000 +0000
+++ swapfile11/mm/swapfile.c	2008-11-28 20:37:16.000000000 +0000
@@ -1842,7 +1842,6 @@ asmlinkage long sys_swapon(const char __
 
 	if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
 		p->flags |= SWP_SOLIDSTATE;
-		srandom32((u32)get_seconds());
 		p->cluster_next = 1 + (random32() % p->highest_bit);
 	}
 	if (discard_swap(p) == 0)
