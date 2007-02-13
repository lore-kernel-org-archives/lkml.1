Return-Path: <linux-kernel-owner+w=401wt.eu-S1751166AbXBMHng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbXBMHng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 02:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbXBMHng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 02:43:36 -0500
Received: from adsl-207-214-87-82.dsl.snfc21.pacbell.net ([207.214.87.82]:41470
	"EHLO heimdal.trondhjem.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751166AbXBMHnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 02:43:35 -0500
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 1/2] VM: invalidate_inode_pages2_range() should not exit early
Date: Mon, 12 Feb 2007 23:43:35 -0800
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Message-Id: <20070213074335.24191.51525.stgit@heimdal.trondhjem.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

Fix invalidate_inode_pages2_range() so that it does not immediately exit
just because a single page in the specified range could not be removed.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 mm/truncate.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index ebf3fcb..0f4b6d1 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -375,10 +375,10 @@ int invalidate_inode_pages2_range(struct
 
 	pagevec_init(&pvec, 0);
 	next = start;
-	while (next <= end && !ret && !wrapped &&
+	while (next <= end && !wrapped &&
 		pagevec_lookup(&pvec, mapping, next,
 			min(end - next, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
-		for (i = 0; !ret && i < pagevec_count(&pvec); i++) {
+		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 			pgoff_t page_index;
 
