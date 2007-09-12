Return-Path: <linux-kernel-owner+w=401wt.eu-S934115AbXILCGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115AbXILCGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 22:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbXILCGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 22:06:22 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:59620 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbXILCGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 22:06:21 -0400
Date: Wed, 12 Sep 2007 11:06:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] fs: define file_fsync() even for CONFIG_BLOCK=n
Message-ID: <20070912020610.GA26827@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's nothing that is problematic for file_fsync() with CONFIG_BLOCK=n,
and it's built in unconditionally anyways, so move the prototype out to
reflect that. Without this, the unionfs build bails out.

  CC      fs/unionfs/file.o
fs/unionfs/file.c:148: error: 'file_fsync' undeclared here (not in a function)
make[2]: *** [fs/unionfs/file.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [fs/unionfs] Error 2

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 include/linux/buffer_head.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1.orig/include/linux/buffer_head.h	2007-09-11 15:15:56.000000000 +0900
+++ linux-2.6.23-rc4-mm1/include/linux/buffer_head.h	2007-09-12 10:18:57.000000000 +0900
@@ -14,6 +14,8 @@
 #include <linux/wait.h>
 #include <asm/atomic.h>
 
+int file_fsync(struct file *, struct dentry *, int);
+
 #ifdef CONFIG_BLOCK
 
 enum bh_state_bits {
@@ -225,7 +227,6 @@
 sector_t generic_block_bmap(struct address_space *, sector_t, get_block_t *);
 int generic_commit_write(struct file *, struct page *, unsigned, unsigned);
 int block_truncate_page(struct address_space *, loff_t, get_block_t *);
-int file_fsync(struct file *, struct dentry *, int);
 int nobh_prepare_write(struct page*, unsigned, unsigned, get_block_t*);
 int nobh_commit_write(struct file *, struct page *, unsigned, unsigned);
 int nobh_truncate_page(struct address_space *, loff_t);
