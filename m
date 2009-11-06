Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbZKFLox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbZKFLox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 06:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbZKFLow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 06:44:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46103 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756871AbZKFLow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 06:44:52 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] jfs: Fix 32bit build warning
To: sfrench@usb.ibm.com, linux-kernel@vger.kernel.org
Date: Fri, 06 Nov 2009 11:31:06 +0000
Message-ID: <20091106113051.14652.34331.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loff_t is a type that isn't entirely dependant upon 32 v 64bit choice

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 fs/jfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 2234c73..d929a82 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -524,7 +524,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	 * Page cache is indexed by long.
 	 * I would use MAX_LFS_FILESIZE, but it's only half as big
 	 */
-	sb->s_maxbytes = min(((u64) PAGE_CACHE_SIZE << 32) - 1, sb->s_maxbytes);
+	sb->s_maxbytes = min(((u64) PAGE_CACHE_SIZE << 32) - 1, (u64)sb->s_maxbytes);
 #endif
 	sb->s_time_gran = 1;
 	return 0;

