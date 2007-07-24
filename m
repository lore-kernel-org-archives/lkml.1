Return-Path: <linux-kernel-owner+w=401wt.eu-S934481AbXGXCPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481AbXGXCPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 22:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762266AbXGXCMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 22:12:20 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:40707 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759139AbXGXCMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 22:12:13 -0400
Message-ID: <385243123.17117@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070724020043.064974174@mail.ustc.edu.cn>
References: <20070724020009.677809022@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Tue, 24 Jul 2007 10:00:18 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] filemap: trivial code cleanups
Content-Disposition: inline; filename=cleanup-filemap.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- remove unused local next_index in do_generic_mapping_read()
- wrap a long line
- remove a redudant page_cache_read() declaration

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/filemap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.22-rc6-mm1.orig/mm/filemap.c
+++ linux-2.6.22-rc6-mm1/mm/filemap.c
@@ -873,13 +873,11 @@ void do_generic_mapping_read(struct addr
 	unsigned long index;
 	unsigned long offset;
 	unsigned long last_index;
-	unsigned long next_index;
 	unsigned long prev_index;
 	unsigned int prev_offset;
 	int error;
 
 	index = *ppos >> PAGE_CACHE_SHIFT;
-	next_index = index;
 	prev_index = ra->prev_pos >> PAGE_CACHE_SHIFT;
 	prev_offset = ra->prev_pos & (PAGE_CACHE_SIZE-1);
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
@@ -1214,7 +1212,8 @@ out:
 }
 EXPORT_SYMBOL(generic_file_aio_read);
 
-int file_send_actor(read_descriptor_t * desc, struct page *page, unsigned long offset, unsigned long size)
+int file_send_actor(read_descriptor_t * desc, struct page *page,
+			unsigned long offset, unsigned long size)
 {
 	ssize_t written;
 	unsigned long count = desc->count;
@@ -1287,7 +1286,6 @@ asmlinkage ssize_t sys_readahead(int fd,
 }
 
 #ifdef CONFIG_MMU
-static int FASTCALL(page_cache_read(struct file * file, unsigned long offset));
 /**
  * page_cache_read - adds requested page to the page cache if not already there
  * @file:	file to read

--
