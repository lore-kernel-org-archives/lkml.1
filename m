Return-Path: <linux-kernel-owner+w=401wt.eu-S934730AbZLGIo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934730AbZLGIo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933622AbZLGIoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:44:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55395 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933582AbZLGIoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:44:24 -0500
Date: Mon, 7 Dec 2009 19:44:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>
Subject: linux-next: block tree build failure
Message-Id: <20091207194429.d33903ed.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next build (powerpc allyesconfig) failed like this:

block/blk-cgroup.c: In function 'blkiocg_create':
block/blk-cgroup.c:285: error: implicit declaration of function 'ERR_PTR'
block/blk-cgroup.c:285: warning: return makes pointer from integer without a cast
block/blk-cgroup.c:289: warning: return makes pointer from integer without a cast

Caused by commit 31e4c28d95e64f2d5d3c497a3ecf37c62de635b4 ("blkio:
Introduce blkio controller cgroup interface").

I applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 7 Dec 2009 19:29:39 +1100
Subject: [PATCH] block: include linux/err.h to use ERR_PTR

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 block/blk-cgroup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 3ad497f..1fa2654 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -14,6 +14,7 @@
 #include <linux/seq_file.h>
 #include <linux/kdev_t.h>
 #include <linux/module.h>
+#include <linux/err.h>
 #include "blk-cgroup.h"
 
 static DEFINE_SPINLOCK(blkio_list_lock);
-- 
1.6.5.3


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
