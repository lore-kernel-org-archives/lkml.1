Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbYIVGQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbYIVGQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 02:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYIVGQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 02:16:26 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43383 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYIVGQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 02:16:25 -0400
From: Krishna Kumar <krkumar2@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: krkumar2@in.ibm.com, Krishna Kumar <krkumar2@in.ibm.com>
Date: Mon, 22 Sep 2008 11:46:10 +0530
Message-Id: <20080922061610.20158.86022.sendpatchset@localhost.localdomain>
Subject: [PATCH] mm: do_generic_file_read() never gets a NULL 'filp' argument
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Kumar <krkumar2@in.ibm.com>

The 'filp' argument to do_generic_file_read() is never NULL.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
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
