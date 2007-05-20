Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbXETOkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbXETOkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 10:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbXETOkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 10:40:11 -0400
Received: from mail.parknet.jp ([210.171.160.80]:2985 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373AbXETOkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 10:40:09 -0400
X-AuthUser: hirofumi@parknet.jp
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, nate.diller@gmail.com
Subject: [PATCH] Fix "fs: convert core functions to zero_user_page"
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Sun, 20 May 2007 23:39:40 +0900
Message-ID: <87abvzy2xf.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The bug introduced by 01f2705daf5a36208e69d7cf95db9c330f843af6.
It misses to convert the first argument, it should be "new_page".

This became the cause of fatfs corruption.

Cc: Nate Diller <nate.diller@gmail.com>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/buffer.c~fix-zero_user_page-conversion fs/buffer.c
--- linux-2.6/fs/buffer.c~fix-zero_user_page-conversion	2007-05-20 18:36:02.000000000 +0900
+++ linux-2.6-hirofumi/fs/buffer.c	2007-05-20 18:36:21.000000000 +0900
@@ -2109,7 +2109,7 @@ int cont_prepare_write(struct page *page
 						PAGE_CACHE_SIZE, get_block);
 		if (status)
 			goto out_unmap;
-		zero_user_page(page, zerofrom, PAGE_CACHE_SIZE - zerofrom,
+		zero_user_page(new_page, zerofrom, PAGE_CACHE_SIZE - zerofrom,
 				KM_USER0);
 		generic_commit_write(NULL, new_page, zerofrom, PAGE_CACHE_SIZE);
 		unlock_page(new_page);
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
