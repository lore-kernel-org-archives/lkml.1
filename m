Return-Path: <linux-kernel-owner+w=401wt.eu-S934226AbXC0WoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934226AbXC0WoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934237AbXC0WoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:44:04 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:52445 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934226AbXC0WoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:44:03 -0400
From: Zach Brown <zach.brown@oracle.com>
To: linux-aio@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20070327224401.17758.17852.sendpatchset@tetsuo.zabbo.net>
Subject: [PATCH] aio: remove bare user-triggerable error printk
Date: Tue, 27 Mar 2007 15:44:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

aio: remove bare user-triggerable error printk

The user can generate console output if they cause do_mmap() to fail during
sys_io_setup().  This was seen in a regression test that does exactly that by
spinning calling mmap() until it gets -ENOMEM before calling io_setup().

We don't need this printk all, just remove it.

Signed-off-by: Zach Brown <zach.brown@oracle.com>
---

 fs/aio.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/aio.c	Tue Mar 27 14:56:08 2007 -0700
+++ b/fs/aio.c	Tue Mar 27 14:56:49 2007 -0700
@@ -136,7 +136,6 @@ static int aio_setup_ring(struct kioctx 
 				  0);
 	if (IS_ERR((void *)info->mmap_base)) {
 		up_write(&ctx->mm->mmap_sem);
-		printk("mmap err: %ld\n", -info->mmap_base);
 		info->mmap_size = 0;
 		aio_free_ring(ctx);
 		return -EAGAIN;
