Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXCPIvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXCPIvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932458AbXCPIvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:51:06 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34653 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932368AbXCPIvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:51:04 -0400
Message-ID: <374035059.08925@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085052.688674000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:49:04 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] readahead: remove parameter ra_max from thrashing_recovery_readahead()
Content-Disposition: inline; filename=readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unused @ra_max from thrashing_recovery_readahead().

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- linux-2.6.21-rc3-mm2.orig/mm/readahead.c
+++ linux-2.6.21-rc3-mm2/mm/readahead.c
@@ -1567,9 +1567,8 @@ try_backward_prefetching(struct file_ra_
  * Readahead thrashing recovery.
  */
 static unsigned long
-thrashing_recovery_readahead(struct address_space *mapping,
-				struct file *filp, struct file_ra_state *ra,
-				pgoff_t offset, unsigned long ra_max)
+thrashing_recovery_readahead(struct address_space *mapping, struct file *filp,
+			     struct file_ra_state *ra, pgoff_t offset)
 {
 	unsigned long ra_size;
 	int unbalanced_aging = probe_page(mapping, offset - 1);
@@ -1682,8 +1681,7 @@ page_cache_readahead_adaptive(struct add
 	 * Recover from possible thrashing.
 	 */
 	if (!page && offset - ra->prev_page <= 1 && ra_has_index(ra, offset))
-		return thrashing_recovery_readahead(mapping, filp, ra,
-								offset, ra_max);
+		return thrashing_recovery_readahead(mapping, filp, ra, offset);
 
 	/*
 	 * State based sequential read-ahead.

--
