Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbZLEUTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbZLEUTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932970AbZLEUTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:19:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41328 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbZLEUQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:16:42 -0500
Date: Sat, 05 Dec 2009 19:13:46 +0000
To: linux-arch@vger.kernel.org
Subject: [RFC][PATCH 6/18] fix pgoff in "have to relocate" case of
 mremap()
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NH04g-0000RD-W6@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/mremap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 84efffb..bbbbbf5 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -495,7 +495,9 @@ unsigned long do_mremap(unsigned long addr,
 			map_flags |= MAP_SHARED;
 
 		new_addr = get_unmapped_area(vma->vm_file, 0, new_len,
-					vma->vm_pgoff, map_flags);
+					vma->vm_pgoff +
+					((addr - vma->vm_start) >> PAGE_SHIFT),
+					map_flags);
 		if (new_addr & ~PAGE_MASK) {
 			ret = new_addr;
 			goto out;
-- 
1.5.6.5


