Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbXBWAjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbXBWAjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 19:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXBWAjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 19:39:15 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40039 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbXBWAjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 19:39:13 -0500
Date: Thu, 22 Feb 2007 18:39:12 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] eCryptfs: remove unnecessary flush_dcache_page()
Message-ID: <20070223003912.GA22628@us.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070223003803.GA22599@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223003803.GA22599@us.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary flush_dcache_page() call. Thanks to Dmitriy
Monakhov for pointing this out.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/mmap.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 842497d..2a65914 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -238,7 +238,6 @@ int ecryptfs_do_readpage(struct file *file, struct page *page,
 	lower_page_data = kmap_atomic(lower_page, KM_USER1);
 	memcpy(page_data, lower_page_data, PAGE_CACHE_SIZE);
 	kunmap_atomic(lower_page_data, KM_USER1);
-	flush_dcache_page(lower_page);
 	kunmap_atomic(page_data, KM_USER0);
 	flush_dcache_page(page);
 	rc = 0;
-- 
1.4.4.4

