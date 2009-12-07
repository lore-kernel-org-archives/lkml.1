Return-Path: <linux-kernel-owner+w=401wt.eu-S934468AbZLGDwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934468AbZLGDwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbZLGDwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:52:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51474 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933608AbZLGDwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:52:44 -0500
Date: Mon, 07 Dec 2009 03:52:50 +0000
To: linux-arch@vger.kernel.org
Subject: [PATCH 6/19] fix pgoff in "have to relocate" case of mremap()
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NHUeY-0007vy-PN@ZenIV.linux.org.uk>
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


