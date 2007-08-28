Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbXH1TNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbXH1TNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761241AbXH1TIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58346 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756785AbXH1THh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:37 -0400
Message-Id: <20070828190736.220951776@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:26 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [35/36] Large blocksize support for ext2
Content-Disposition: inline; filename=0035-Large-blocksize-support-for-ext2.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for a block size of up to 64k on any platform.
It enables the mounting filesystems that have a larger blocksize
than the page size.

F.e. the following is possible on x86_64 and i386 that have only a 4k page
size:

mke2fs -b 16384 /dev/hdd2	<Ignore warning about too large block size>

mount /dev/hdd2 /media
ls -l /media

.... Do more things with the volume that uses a 16k page cache size on
a 4k page sized platform..

Hmmm... Actually there is nothing additional to be done after the earlier
cleanup of the macros. So just modify copyright.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/ext2/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 0079b2c..5ff775a 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -20,6 +20,9 @@
  * 	(jj@sunsite.ms.mff.cuni.cz)
  *
  *  Assorted race fixes, rewrite of ext2_get_block() by Al Viro, 2000
+ *
+ *  (C) 2007 SGI.
+ *  Large blocksize support by Christoph Lameter
  */
 
 #include <linux/smp_lock.h>
-- 
1.5.2.4

-- 
