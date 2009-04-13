Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbZDMT5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbZDMT5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZDMT5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:57:25 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:6744 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbZDMT5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:57:25 -0400
Subject: [PATCH] squashfs broken when pageszie > blocksize
From: Doug Chapman <doug.chapman@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: phillip@lougher.demon.co.uk
Content-Type: text/plain
Date: Mon, 13 Apr 2009 15:57:17 -0400
Message-Id: <1239652637.1127.10.camel@oberon>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Squashfs is broken on any system where the pageszie is larger than either
the block size of the squashfs image or larger than the metadata size (8192).
This is easily fixed by ensuring cache->pages is always > 0.

Signed-off-by: Doug Chapman <doug.chapman@hp.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>

---
diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index 1c4739e..c31aa89 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -252,6 +252,7 @@ struct squashfs_cache *squashfs_cache_init(char *name, int entries,
 	cache->entries = entries;
 	cache->block_size = block_size;
 	cache->pages = block_size >> PAGE_CACHE_SHIFT;
+	cache->pages = cache->pages?cache->pages:1;
 	cache->name = name;
 	cache->num_waiters = 0;
 	spin_lock_init(&cache->lock);


