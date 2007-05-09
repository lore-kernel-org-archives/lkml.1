Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbXEIRZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbXEIRZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbXEIRZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:25:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978AbXEIRZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:25:35 -0400
Date: Wed, 9 May 2007 13:25:32 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rmk+lkml@arm.linux.org.uk, dzickus@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070509172532.16700.33405.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH] Remove cpu hotplug defines for __INIT & __INITDATA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell and Andrew,

After examining what was checked in and the code base I discovered that most
of 86c0baf123e474b6eb404798926ecf62b426bf3a wasn't necessary anymore....

So here's a patch that reverts the last part of that changeset:




Revert part of 86c0baf123e474b6eb404798926ecf62b426bf3a.

The kernel has moved forward to a state where the original change is not
necessary.  After porting forward, this final version of the patch was
applied and broke non-x86 architectures.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/include/linux/init.h b/include/linux/init.h
index 8bc32bb..e007ae4 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -52,14 +52,9 @@
 #endif
 
 /* For assembly routines */
-#ifdef CONFIG_HOTPLUG_CPU
-#define __INIT		.section	".text","ax"
-#define __INITDATA	.section	".data","aw"
-#else
 #define __INIT		.section	".init.text","ax"
-#define __INITDATA	.section	".init.data","aw"
-#endif
 #define __FINIT		.previous
+#define __INITDATA	.section	".init.data","aw"
 
 #ifndef __ASSEMBLY__
 /*
