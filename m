Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbYGZMXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbYGZMXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 08:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYGZMWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 08:22:54 -0400
Received: from mo30.po.2iij.net ([210.128.50.53]:6674 "EHLO mo30.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYGZMWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 08:22:54 -0400
Date: Sat, 26 Jul 2008 21:22:46 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix build error when no swap
Message-Id: <20080726212246.d64073b3.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_SWAP is not set, I got the following error.

In file included from include/asm/tlb.h:21,
                 from fs/exec.c:55:
		 include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
		 include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
		 include/asm-generic/tlb.h: In function 'tlb_remove_page':
		 include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
		 make[1]: *** [fs/exec.o] Error 1

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X /home/yuasa/Memo/dontdiff linux-orig/include/linux/swap.h linux/include/linux/swap.h
--- linux-orig/include/linux/swap.h	2008-07-26 17:27:22.651869820 +0900
+++ linux/include/linux/swap.h	2008-07-26 18:36:46.406531575 +0900
@@ -7,6 +7,7 @@
 #include <linux/list.h>
 #include <linux/memcontrol.h>
 #include <linux/sched.h>
+#include <linux/pagemap.h>
 
 #include <asm/atomic.h>
 #include <asm/page.h>
