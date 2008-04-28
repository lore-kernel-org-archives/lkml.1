Return-Path: <linux-kernel-owner+w=401wt.eu-S964961AbYD1Pjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961AbYD1Pjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935850AbYD1PjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:39:04 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59565 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935735AbYD1PjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:39:02 -0400
Date: Mon, 28 Apr 2008 18:38:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: [2.6 patch] fs/buffer.c:init_buffer() mustn't be inline
Message-ID: <20080428153829.GB2813@cs181133002.pp.htv.fi>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080426172222.GD17345@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error with UML and gcc 4.3:

<--  snip  -->

...
  CC      fs/buffer.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/buffer.c: In function ‘init_page_buffers’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/buffer.c:51: sorry, unimplemented: inlining failed in call to ‘init_buffer’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/buffer.c:1007: sorry, unimplemented: called from here
make[2]: *** [fs/buffer.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
922267dbec9ea632537ab61ef9cb2d0d5f9d8f9e diff --git a/fs/buffer.c b/fs/buffer.c
index 39ff144..d74743d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -46,8 +46,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
 
 #define BH_ENTRY(list) list_entry((list), struct buffer_head, b_assoc_buffers)
 
-inline void
-init_buffer(struct buffer_head *bh, bh_end_io_t *handler, void *private)
+void init_buffer(struct buffer_head *bh, bh_end_io_t *handler, void *private)
 {
 	bh->b_end_io = handler;
 	bh->b_private = private;

