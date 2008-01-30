Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbYA3ORy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbYA3ORy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761106AbYA3OR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:17:28 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:58274 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761337AbYA3OR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:17:26 -0500
Date: Wed, 30 Jan 2008 17:20:14 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       William Lee Irwin III <wli@holomorphy.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] sys_remap_file_pages: fix ->vm_file accounting
Message-ID: <20080130142014.GA2164@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ->vm_file accounting, mmap_region() may do do_munmap().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- MM/mm/fremap.c~RFP	2007-10-25 16:22:12.000000000 +0400
+++ MM/mm/fremap.c	2008-01-30 16:56:39.000000000 +0300
@@ -192,8 +192,10 @@ asmlinkage long sys_remap_file_pages(uns
 			unsigned long addr;
 
 			flags &= MAP_NONBLOCK;
+			get_file(vma->vm_file);
 			addr = mmap_region(vma->vm_file, start, size,
 					flags, vma->vm_flags, pgoff, 1);
+			fput(vma->vm_file);
 			if (IS_ERR_VALUE(addr)) {
 				err = addr;
 			} else {

