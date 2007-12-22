Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXLVBd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXLVBd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXLVBdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:33:19 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53958 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750756AbXLVBdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:33:18 -0500
Message-ID: <398287206.10334@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071222013315.126541416@mail.ustc.edu.cn>
References: <20071222013147.897522982@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sat, 22 Dec 2007 09:31:52 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] readahead: make ra_submit() non-static
Content-Disposition: inline; filename=readahead-export-ra_submit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ra_submit() non-static and callable from other files.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
---
 include/linux/mm.h |    3 +++
 mm/readahead.c     |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6.24-rc5-mm1.orig/include/linux/mm.h
+++ linux-2.6.24-rc5-mm1/include/linux/mm.h
@@ -1103,6 +1103,9 @@ void page_cache_async_readahead(struct a
 				unsigned long size);
 
 unsigned long max_sane_readahead(unsigned long nr);
+unsigned long ra_submit(struct file_ra_state *ra,
+		        struct address_space *mapping,
+			struct file *filp);
 
 /* Do stack extension */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
--- linux-2.6.24-rc5-mm1.orig/mm/readahead.c
+++ linux-2.6.24-rc5-mm1/mm/readahead.c
@@ -242,7 +242,7 @@ subsys_initcall(readahead_init);
 /*
  * Submit IO for the read-ahead request in file_ra_state.
  */
-static unsigned long ra_submit(struct file_ra_state *ra,
+unsigned long ra_submit(struct file_ra_state *ra,
 		       struct address_space *mapping, struct file *filp)
 {
 	int actual;

-- 
