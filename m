Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZGGFkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZGGFkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZGGFkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:40:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62503 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbZGGFkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:40:11 -0400
Message-ID: <4A52DFBB.7040800@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 13:40:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hw_breakpoint: remove sample code from hw_breakpoint.h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sample code is a bit out-dated, and there's already a
sample in sample/hw_breakpoint/.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/asm-generic/hw_breakpoint.h |   41 +---------------------------------
 1 files changed, 2 insertions(+), 39 deletions(-)

diff --git a/include/asm-generic/hw_breakpoint.h b/include/asm-generic/hw_breakpoint.h
index 9bf2d12..30ab37c 100644
--- a/include/asm-generic/hw_breakpoint.h
+++ b/include/asm-generic/hw_breakpoint.h
@@ -60,45 +60,8 @@
  * Breakpoints are disabled during execution @triggered, to avoid
  * recursive traps and allow unhindered access to breakpointed memory.
  *
- * This sample code sets a breakpoint on pid_max and registers a callback
- * function for writes to that variable.  Note that it is not portable
- * as written, because not all architectures support HW_BREAKPOINT_LEN_4.
- *
- * ----------------------------------------------------------------------
- *
- * #include <asm/hw_breakpoint.h>
- *
- * struct hw_breakpoint my_bp;
- *
- * static void my_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
- * {
- * 	printk(KERN_DEBUG "Inside triggered routine of breakpoint exception\n");
- * 	dump_stack();
- *  	.......<more debugging output>........
- * }
- *
- * static struct hw_breakpoint my_bp;
- *
- * static int init_module(void)
- * {
- *	..........<do anything>............
- *	my_bp.info.type = HW_BREAKPOINT_WRITE;
- *	my_bp.info.len = HW_BREAKPOINT_LEN_4;
- *
- *	my_bp.installed = (void *)my_bp_installed;
- *
- *	rc = register_kernel_hw_breakpoint(&my_bp);
- *	..........<do anything>............
- * }
- *
- * static void cleanup_module(void)
- * {
- *	..........<do anything>............
- *	unregister_kernel_hw_breakpoint(&my_bp);
- *	..........<do anything>............
- * }
- *
- * ----------------------------------------------------------------------
+ * See sample/hw_breakpoint/ for a sample that sets a breakpoint on
+ * a specified kernel symbol.
  */
 struct hw_breakpoint {
 	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
-- 
1.5.4.rc3
