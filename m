Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbXA3Vmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbXA3Vmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbXA3Vmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:42:51 -0500
Received: from relay01.mail-hub.dodo.com.au ([203.220.32.149]:44510 "EHLO
	relay01.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739AbXA3Vmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:42:50 -0500
From: Grant Coady <grant_lkml@dodo.com.au>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] -mm3: include/linux/blkdev.h double def'd -> compile fail
Date: Wed, 31 Jan 2007 08:42:46 +1100
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <5ucvr251jeafujuto8tlrkpuv3k4kak86s@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Random .config: 20-rc6-mm3a/002 found the following boo-boo...


From: Grant Coady <gcoady.lk@gmail.com>

Defining protos twice caused:

In file included from kernel/sched.c:39:
include/linux/blkdev.h:928: error: redefinition of 'blk_replug_current_nested'
include/linux/blkdev.h:907: error: previous definition of 'blk_replug_current_nested' was here
include/linux/blkdev.h:932: error: redefinition of 'blk_plug_current'
include/linux/blkdev.h:911: error: previous definition of 'blk_plug_current' was here
include/linux/blkdev.h:936: error: redefinition of 'blk_unplug_current'
include/linux/blkdev.h:915: error: previous definition of 'blk_unplug_current' was here
include/linux/blkdev.h:940: error: redefinition of 'blk_unplug_current_nested'
include/linux/blkdev.h:919: error: previous definition of 'blk_unplug_current_nested' was here
include/linux/blkdev.h:945: error: redefinition of 'blk_plug_current_nested'
include/linux/blkdev.h:924: error: previous definition of 'blk_plug_current_nested' was here
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

Patch is compile tested on 2.6.20-rc6-mm3.

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>

---
 blkdev.h |   21 ---------------------
 1 files changed, 21 deletions(-)

--- linux-2.6.20-rc6-mm3/include/linux/blkdev.h	2007-01-30 16:25:30.000000000 +1100
+++ linux-2.6.20-rc6-mm3c/include/linux/blkdev.h	2007-01-31 08:01:28.000000000 +1100
@@ -924,27 +924,6 @@
 {
 }
 
-static inline void blk_replug_current_nested(void)
-{
-}
-
-static inline void blk_plug_current(void)
-{
-}
-
-static inline void blk_unplug_current(void)
-{
-}
-
-static inline int blk_unplug_current_nested(void)
-{
-	return 0;
-}
-
-static inline void blk_plug_current_nested(int depth)
-{
-}
-
 #endif /* CONFIG_BLOCK */
 
 #endif
