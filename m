Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbXCZPGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbXCZPGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 11:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbXCZPGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 11:06:23 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:47109 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbXCZPGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 11:06:23 -0400
X-Greylist: delayed 2642 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Mar 2007 11:06:23 EDT
Date: Mon, 26 Mar 2007 10:22:13 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: axboe@kernel.dk
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fs/buffer.c: Loop rewrite within grow_buffers for finding
 sizebits
Message-ID: <alpine.DEB.0.83.0703260952560.20524@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

This patch alters the (do...while) construct to a simple (while) and saves 
one increment operation. It's entirely possible that gcc optimizes away 
the first iteration anyway, but in case it doesn't (and also because it's 
easier to read this way), I think this is better.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

--- linux-2.6.20.4/fs/buffer.c.orig	2007-03-26 09:42:15.000000000 -0400
+++ linux-2.6.20.4/fs/buffer.c	2007-03-26 10:10:25.000000000 -0400
@@ -1045,10 +1045,10 @@ grow_buffers(struct block_device *bdev,
  	pgoff_t index;
  	int sizebits;

-	sizebits = -1;
-	do {
+	sizebits = 0;
+	while ((size << sizebits) < PAGE_SIZE) {
  		sizebits++;
-	} while ((size << sizebits) < PAGE_SIZE);
+	}

  	index = block >> sizebits;

