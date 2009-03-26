Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZCZLXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZCZLXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 07:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZCZLXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 07:23:10 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:4432 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751789AbZCZLXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 07:23:09 -0400
Message-ID: <49CB6597.9060607@panasas.com>
Date: Thu, 26 Mar 2009 13:23:03 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: pNFS Mailing List <pnfs@linux-nfs.org>
CC: Fredric Isaman <iisaman@citi.umich.edu>, Steve Dickson <steved@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib: statically link find_last_bit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2009 11:23:05.0879 (UTC) FILETIME=[3BD71270:01C9AE05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the only use of find_last_bit in the kernel is
setup_nr_cpu_ids which compiles only under CONFIG_SMP.
On uniprocessor machines the linker can't find it when
needed in a loadable module.

    Kernel: arch/x86/boot/bzImage is ready  (#5)
      Building modules, stage 2.
      MODPOST 515 modules
    ERROR: "find_last_bit" [fs/nfs/nfs.ko] undefined!

Cc: Fredric Isaman <iisaman@citi.umich.edu>
Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---

patch required for the nfs41 series

 lib/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Makefile b/lib/Makefile
index 32b0e64..286e2f7 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -37,7 +37,7 @@ lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
-lib-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
+obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_PLIST) += plist.o
-- 
1.6.2.1

