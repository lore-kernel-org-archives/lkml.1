Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbZDWNkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbZDWNkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZDWNkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:40:45 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:26774 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752690AbZDWNko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:40:44 -0400
From: Benny Halevy <bhalevy@panasas.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Fred Isaman <iisaman@citi.umich.edu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Benny Halevy <bhalevy@panasas.com>
Subject: [PATCH] lib: find_last_bit.o needed by a module only, move it from lib to obj
Date: Thu, 23 Apr 2009 16:40:32 +0300
Message-Id: <1240494032-9674-1-git-send-email-bhalevy@panasas.com>
X-Mailer: git-send-email 1.6.2.1
X-OriginalArrivalTime: 23 Apr 2009 13:40:40.0137 (UTC) FILETIME=[1753E390:01C9C419]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fred Isaman <iisaman@citi.umich.edu>

Currently, although find_last_bit is EXPORTed, it is statically linked with
the lernel and is referenced only under CONFIG_SMP.

When CONFIG_SMP is undefined and find_last_bit is referenced only by modules,
linking fails with:
ERROR: "find_last_bit" [fs/nfs/nfs.ko] undefined!

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Fred Isaman <iisaman@citi.umich.edu>
Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---

Linus, can you please merge this trivial patch upstream?
This breaks nfs-2.6/{nfsv41,linux-next} on uni-processors
configured with !CONFIG_SMP.

Thanks,

Benny

 lib/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Makefile b/lib/Makefile
index d6edd67..33a40e4 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -38,7 +38,7 @@ lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
-lib-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
+obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
-- 
1.6.2.1

