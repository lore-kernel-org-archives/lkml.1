Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbYJLEQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbYJLEQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 00:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYJLEQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 00:16:14 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58608 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYJLEQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 00:16:14 -0400
Date: Sun, 12 Oct 2008 07:15:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Josef Bacik <jbacik@redhat.com>, Mark Fasheh <mfasheh@suse.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] provide generic_block_fiemap() only with BLOCK=y
Message-ID: <20081012041519.GC31153@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error with CONFIG_BLOCK=n caused 
by commit 68c9d702bb72f367f3b148963ec6cf5e07ff7f65
(generic block based fiemap implementation):

<--  snip  -->

...
  CC      fs/ioctl.o
fs/ioctl.c: In function 'generic_block_fiemap':
fs/ioctl.c:249: error: storage size of 'tmp' isn't known
fs/ioctl.c:272: error: invalid application of 'sizeof' to incomplete type 'struct buffer_head' 
fs/ioctl.c:280: error: implicit declaration of function 'buffer_mapped'
fs/ioctl.c:249: warning: unused variable 'tmp'
make[2]: *** [fs/ioctl.o] Error 1

<--  snip  -->


Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/ioctl.c b/fs/ioctl.c
index 33a6b7e..d152856 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -226,6 +226,8 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
 	return error;
 }
 
+#ifdef CONFIG_BLOCK
+
 #define blk_to_logical(inode, blk) (blk << (inode)->i_blkbits)
 #define logical_to_blk(inode, offset) (offset >> (inode)->i_blkbits);
 
@@ -342,6 +344,8 @@ int generic_block_fiemap(struct inode *inode,
 }
 EXPORT_SYMBOL(generic_block_fiemap);
 
+#endif  /*  CONFIG_BLOCK  */
+
 static int file_ioctl(struct file *filp, unsigned int cmd,
 		unsigned long arg)
 {

