Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbYIVEDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbYIVEDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 00:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYIVEDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 00:03:40 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36861 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbYIVEDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 00:03:39 -0400
From: Krishna Kumar <krkumar2@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: krkumar2@in.ibm.com, Krishna Kumar <krkumar2@in.ibm.com>
Date: Mon, 22 Sep 2008 09:33:25 +0530
Message-Id: <20080922040325.10196.87900.sendpatchset@localhost.localdomain>
Subject: [PATCH] mm: do_generic_file_read() doesn't need to validate filp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Kumar <krkumar2@in.ibm.com>

do_generic_file_read() doesn't need to validate filp when accessing it. This
is probably a remnant of an earlier code.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
 mm/filemap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -ruNp 2.6.27-rc7-org/mm/filemap.c 2.6.27-rc7-new/mm/filemap.c
--- 2.6.27-rc7-org/mm/filemap.c	2008-09-17 12:53:25.000000000 +0530
+++ 2.6.27-rc7-new/mm/filemap.c	2008-09-17 12:53:59.000000000 +0530
@@ -1186,8 +1186,7 @@ out:
 	ra->prev_pos |= prev_offset;
 
 	*ppos = ((loff_t)index << PAGE_CACHE_SHIFT) + offset;
-	if (filp)
-		file_accessed(filp);
+	file_accessed(filp);
 }
 
 int file_read_actor(read_descriptor_t *desc, struct page *page,
