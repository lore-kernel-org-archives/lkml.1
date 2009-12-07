Return-Path: <linux-kernel-owner+w=401wt.eu-S934680AbZLGDyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934680AbZLGDyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934651AbZLGDy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:54:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51497 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934671AbZLGDy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:54:26 -0500
Date: Mon, 07 Dec 2009 03:54:31 +0000
To: linux-arch@vger.kernel.org
Subject: [PATCH 16/19] switch do_brk() to get_unmapped_area()
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NHUgB-0007yw-2K@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/mmap.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index e92cbe5..f364677 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1989,20 +1989,14 @@ unsigned long do_brk(unsigned long addr, unsigned long len)
 	if (!len)
 		return addr;
 
-	if ((addr + len) > TASK_SIZE || (addr + len) < addr)
-		return -EINVAL;
-
-	if (is_hugepage_only_range(mm, addr, len))
-		return -EINVAL;
-
 	error = security_file_mmap(NULL, 0, 0, 0, addr, 1);
 	if (error)
 		return error;
 
 	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
 
-	error = arch_mmap_check(addr, len, flags);
-	if (error)
+	error = get_unmapped_area(NULL, addr, len, 0, MAP_FIXED | flags);
+	if (error & ~PAGE_MASK)
 		return error;
 
 	/*
-- 
1.5.6.5


