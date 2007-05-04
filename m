Return-Path: <linux-kernel-owner+w=401wt.eu-S1031710AbXEDVhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031710AbXEDVhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031711AbXEDVhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:37:42 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32328 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031710AbXEDVhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:37:41 -0400
Date: Fri, 4 May 2007 14:41:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] doc. fixes for readahead
Message-Id: <20070504144121.22b20030.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mm/readahead.c & filemap.c kernel-doc warnings (goes with readahead
patch when it's submitted).

Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'mapping'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'ra'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'filp'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'offset'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'req_size'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/filemap.c:1394): No description found for parameter 'vma'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/filemap.c:1394): No description found for parameter 'fdata'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 mm/filemap.c   |    3 ++-
 mm/readahead.c |    7 ++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- linux-2621-rc7mm2.orig/mm/readahead.c
+++ linux-2621-rc7mm2/mm/readahead.c
@@ -1610,8 +1610,13 @@ thrashing_recovery_readahead(struct addr
 
 /**
  * page_cache_readahead_adaptive - thrashing safe adaptive read-ahead
- * @mapping, @ra, @filp, @offset, @req_size: the same as page_cache_readahead()
+ * @mapping: address_space which holds the pagecache and I/O vectors
+ * @ra: file_ra_state which holds the readahead state
+ * @filp: passed on to ->readpage() and ->readpages()
  * @page: the page at @offset, or NULL if non-present
+ * @offset: start offset into @mapping, in PAGE_CACHE_SIZE units
+ * @req_size: hint: total size of the read which the caller is performing in
+ *            PAGE_CACHE_SIZE units
  *
  * page_cache_readahead_adaptive() is the entry point of the adaptive
  * read-ahead logic. It tries a set of methods in turn to determine the
--- linux-2621-rc7mm2.orig/mm/filemap.c
+++ linux-2621-rc7mm2/mm/filemap.c
@@ -1381,7 +1381,8 @@ static int fastcall page_cache_read(stru
 
 /**
  * filemap_fault - read in file data for page fault handling
- * @data:	the applicable fault_data
+ * @vma:	user vma (not used)
+ * @fdata:	the applicable fault_data
  *
  * filemap_fault() is invoked via the vma operations vector for a
  * mapped memory region to read in file data during a page fault.
