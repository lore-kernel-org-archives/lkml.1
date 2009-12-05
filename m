Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbZLEUQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbZLEUQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZLEUQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:16:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41319 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbZLEUQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:16:22 -0500
Date: Sat, 05 Dec 2009 19:08:51 +0000
To: linux-arch@vger.kernel.org
Subject: [RFC][PATCH 16/18] switch do_brk() to get_unmapped_area()
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NGzzv-0008Rt-4N@ZenIV.linux.org.uk>
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


