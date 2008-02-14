Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbYBNVKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbYBNVKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbYBNVK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:10:28 -0500
Received: from flpi185.sbcis.sbc.com ([207.115.20.187]:45933 "EHLO
	flpi185.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbYBNVK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:10:27 -0500
X-ORBL: [76.241.169.38]
From: Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH] Fix {clear,copy}_user_page() declarations in page.h
To: akpm@linux-foundation.org
Cc: jeremy.fitzhardinge@citrix.com, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2008 16:09:26 -0500
Message-ID: <20080214210926.12162.76261.stgit@manray.1015granger.net>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up: eliminate some compiler noise on x86 when building with strict
warnings enabled, introduced by commit 345b904c.

In file included from include2/asm/thread_info_64.h:12,
                 from include2/asm/thread_info.h:4,
                 from
/home/cel/src/linux/nfs-2.6/include/linux/thread_info.h:35,
                 from
/home/cel/src/linux/nfs-2.6/include/linux/preempt.h:9,
                 from
/home/cel/src/linux/nfs-2.6/include/linux/spinlock.h:49,
                 from /home/cel/src/linux/nfs-2.6/include/linux/mmzone.h:7,
                 from /home/cel/src/linux/nfs-2.6/include/linux/gfp.h:4,
                 from /home/cel/src/linux/nfs-2.6/include/linux/slab.h:14,
                 from /home/cel/src/linux/nfs-2.6/fs/nfsd/nfs4acl.c:40:
include2/asm/page.h:55: warning: `inline' is not at beginning of
declaration
include2/asm/page.h:61: warning: `inline' is not at beginning of
declaration

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---

 include/asm-x86/page.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
index 1cb7c51..a05b289 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -52,13 +52,13 @@ extern int page_is_ram(unsigned long pagenr);
 
 struct page;
 
-static void inline clear_user_page(void *page, unsigned long vaddr,
+static inline void clear_user_page(void *page, unsigned long vaddr,
 				struct page *pg)
 {
 	clear_page(page);
 }
 
-static void inline copy_user_page(void *to, void *from, unsigned long vaddr,
+static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 				struct page *topage)
 {
 	copy_page(to, from);

