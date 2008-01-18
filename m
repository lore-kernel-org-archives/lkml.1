Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbYARCjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbYARCjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759744AbYARChH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:37:07 -0500
Received: from waste.org ([66.93.16.53]:40603 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758273AbYARChF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:37:05 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 07 of 12] random: remove cacheline alignment for locks
X-Mercurial-Node: 70f981257057999181a6611fb11b1c6e3747cdce
Message-Id: <70f981257057999181a6.1200623629@cinder.waste.org>
In-Reply-To: <patchbomb.1200623622@cinder.waste.org>
Date: Thu, 17 Jan 2008 20:33:49 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier changes greatly reduce the number of times we grab the lock
per output byte, so we shouldn't need this particular hack any more.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 9569d3011032 -r 70f981257057 drivers/char/random.c
--- a/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
+++ b/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
@@ -395,7 +395,7 @@
 
 struct entropy_store;
 struct entropy_store {
-	/* mostly-read data: */
+	/* read-only data: */
 	struct poolinfo *poolinfo;
 	__u32 *pool;
 	const char *name;
@@ -403,7 +403,7 @@
 	struct entropy_store *pull;
 
 	/* read-write data: */
-	spinlock_t lock ____cacheline_aligned_in_smp;
+	spinlock_t lock;
 	unsigned add_ptr;
 	int entropy_count;
 	int input_rotate;
