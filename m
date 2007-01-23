Return-Path: <linux-kernel-owner+w=401wt.eu-S933000AbXAWMZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbXAWMZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 07:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932998AbXAWMZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 07:25:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60925 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbXAWMZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 07:25:10 -0500
To: torvalds@osdl.org
Subject: [PATCH] s2io bogus memset
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1H9Ki4-0006pB-FK@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 23 Jan 2007 12:25:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


memset() after kmalloc() on size * 8 would better be on size * 8, not
just size; fixed by switching to kcalloc() - it's more idiomatic anyway.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -554,10 +554,9 @@ static int init_shared_mem(struct s2io_n
 		}
 	}
 
-	nic->ufo_in_band_v = kmalloc((sizeof(u64) * size), GFP_KERNEL);
+	nic->ufo_in_band_v = kcalloc(size, sizeof(u64), GFP_KERNEL);
 	if (!nic->ufo_in_band_v)
 		return -ENOMEM;
-	memset(nic->ufo_in_band_v, 0, size);
 
 	/* Allocation and initialization of RXDs in Rings */
 	size = 0;
