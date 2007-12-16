Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbXLPMGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbXLPMGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 07:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934070AbXLPMEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 07:04:32 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60624 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933282AbXLPME0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 07:04:26 -0500
Message-ID: <397806668.73374@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071216120418.201213716@mail.ustc.edu.cn>
References: <20071216115927.986126305@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 16 Dec 2007 19:59:33 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
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

--- linux-2.6.24-rc4-mm1.orig/include/linux/mm.h
+++ linux-2.6.24-rc4-mm1/include/linux/mm.h
@@ -1103,6 +1103,9 @@ void page_cache_async_readahead(struct a
 				unsigned long size);
 
 unsigned long max_sane_readahead(unsigned long nr);
+unsigned long ra_submit(struct file_ra_state *ra,
+		        struct address_space *mapping,
+			struct file *filp);
 
 /* Do stack extension */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
--- linux-2.6.24-rc4-mm1.orig/mm/readahead.c
+++ linux-2.6.24-rc4-mm1/mm/readahead.c
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
