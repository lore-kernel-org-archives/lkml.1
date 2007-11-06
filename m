Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbXKFBJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbXKFBJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 20:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbXKFBJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 20:09:35 -0500
Received: from waste.org ([66.93.16.53]:40113 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbXKFBJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 20:09:35 -0500
Date: Mon, 5 Nov 2007 19:09:24 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Loopback mounts should update the mtime of the underlying file on writes
Message-ID: <20071106010924.GT17536@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed by a Mercurial user. I think this should fix it.

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: l/drivers/block/loop.c
===================================================================
--- l.orig/drivers/block/loop.c	2007-11-05 17:50:07.000000000 -0600
+++ l/drivers/block/loop.c	2007-11-05 19:03:51.000000000 -0600
@@ -221,6 +221,7 @@ static int do_lo_send_aops(struct loop_d
 	offset = pos & ((pgoff_t)PAGE_CACHE_SIZE - 1);
 	bv_offs = bvec->bv_offset;
 	len = bvec->bv_len;
+	file_update_time(file);
 	while (len > 0) {
 		sector_t IV;
 		unsigned size;
@@ -299,6 +300,7 @@ static int __do_lo_send_write(struct fil
 
 	set_fs(get_ds());
 	bw = file->f_op->write(file, buf, len, &pos);
+	file_update_time(file);
 	set_fs(old_fs);
 	if (likely(bw == len))
 		return 0;


-- 
Mathematics is the supreme nostalgia of our time.
