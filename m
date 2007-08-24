Return-Path: <linux-kernel-owner+w=401wt.eu-S1765343AbXHXTeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765343AbXHXTeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbXHXTeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:34:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:31049 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbXHXTeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=CFzflIq3oYcoj2ouRNwfIRLmLXxe+R4EQOGKLItiaCqKhLzp+ocdRys74Iva+LkGFJvFYYLMSRbwjX+x7GKufKiP+Q2BZkaqZmGh2sZXEVn6zXor5I3Dy6D62v0NqwPb0ss5yuv3YEiaSR0bhYKGuQmy6Qvg0a+Cf0BjBQmig3c=
Date: Fri, 24 Aug 2007 23:33:58 +0400
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Drop some headers from mm.h
Message-ID: <20070824193358.GA1824@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mm.h doesn't use directly anything from mutex.h and backing-dev.h, so
remove them and add them back to files which need them.

Cross-compile tested on many configs and archs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

BTW, switching to SLUB makes this nice workload to go OOM, which SLAB
never allowed itself, however, I'm not prepared right now to tell the
story. It smells like semi-recent breakage, because, I can swear,
I ran it with SLUB for stress-testing purposes.

 fs/afs/write.c     |    2 +-
 include/linux/mm.h |    2 --
 mm/fremap.c        |    2 +-
 mm/mmap.c          |    1 +
 mm/truncate.c      |    1 +
 5 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index a03b92a..4b72207 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -8,7 +8,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
-
+#include <linux/backing-dev.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1692dd6..57d44ae 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -10,9 +10,7 @@
 #include <linux/mmzone.h>
 #include <linux/rbtree.h>
 #include <linux/prio_tree.h>
-#include <linux/mutex.h>
 #include <linux/debug_locks.h>
-#include <linux/backing-dev.h>
 #include <linux/mm_types.h>
 
 struct mempolicy;
diff --git a/mm/fremap.c b/mm/fremap.c
index c395b1a..8dfae8f 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -5,7 +5,7 @@
  *
  * started by Ingo Molnar, Copyright (C) 2002, 2003
  */
-
+#include <linux/backing-dev.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/file.h>
diff --git a/mm/mmap.c b/mm/mmap.c
index 0d40e66..9e685b9 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/backing-dev.h>
 #include <linux/mm.h>
 #include <linux/shm.h>
 #include <linux/mman.h>
diff --git a/mm/truncate.c b/mm/truncate.c
index 5cdfbc1..3bdf108 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/backing-dev.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/module.h>
