Return-Path: <linux-kernel-owner+w=401wt.eu-S1761848AbXFTSia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761848AbXFTSia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759385AbXFTSbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54798 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758211AbXFTSaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:15 -0400
Message-Id: <20070620183014.438784820@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:43 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [36/37] Large blocksize support for ext2
Content-Disposition: inline; filename=vps_filesystem_ext2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for a block size of up to 64k on any platform.
It enables the mounting filesystems that have a larger blocksize
than the page size.

F.e. the following is possible on x86_64 and i386 that have only a 4k page
size.

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
 1 file changed, 3 insertions(+)


Index: linux-2.6.22-rc4-mm2/fs/ext2/inode.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/ext2/inode.c	2007-06-19 19:40:56.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/ext2/inode.c	2007-06-19 19:41:56.000000000 -0700
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
