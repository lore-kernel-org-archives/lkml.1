Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYFUNjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYFUNjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 09:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYFUNjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 09:39:06 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51396 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbYFUNjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 09:39:04 -0400
Date: Sat, 21 Jun 2008 17:41:24 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ethan Solomita <solo@google.com>, Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] get_user_pages: fix possible page leak on oom
Message-ID: <20080621134124.GA10851@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_user_pages() must not return the error when i != 0. When pages != NULL we
have i get_page()'ed pages.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/mm/memory.c~1_GUP_OOM	2008-06-21 15:35:21.000000000 +0400
+++ 26-rc2/mm/memory.c	2008-06-21 15:56:58.000000000 +0400
@@ -1115,7 +1115,7 @@ int get_user_pages(struct task_struct *t
 			 * be processed until returning to user space.
 			 */
 			if (unlikely(test_tsk_thread_flag(tsk, TIF_MEMDIE)))
-				return -ENOMEM;
+				return i ? i : -ENOMEM;
 
 			if (write)
 				foll_flags |= FOLL_WRITE;

