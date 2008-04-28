Return-Path: <linux-kernel-owner+w=401wt.eu-S934885AbYD1PkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934885AbYD1PkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935857AbYD1PjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:39:07 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34979 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935848AbYD1PjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:39:04 -0400
Date: Mon, 28 Apr 2008 18:38:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: [2.6 patch] fs/block_dev.c:I_BDEV() mustn't be inline
Message-ID: <20080428153831.GC2813@cs181133002.pp.htv.fi>
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
  CC      fs/block_dev.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c: In function ‘blkdev_get_block’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c:42: sorry, unimplemented: inlining failed in call to ‘I_BDEV’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c:119: sorry, unimplemented: called from here
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c:42: sorry, unimplemented: inlining failed in call to ‘I_BDEV’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c:131: sorry, unimplemented: called from here
make[2]: *** [fs/block_dev.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
cd324c3df8a964c6abe03828861238ea3083ba02 diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7d822fa..ce9ea3e 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -38,7 +38,7 @@ static inline struct bdev_inode *BDEV_I(struct inode *inode)
 	return container_of(inode, struct bdev_inode, vfs_inode);
 }
 
-inline struct block_device *I_BDEV(struct inode *inode)
+struct block_device *I_BDEV(struct inode *inode)
 {
 	return &BDEV_I(inode)->bdev;
 }

