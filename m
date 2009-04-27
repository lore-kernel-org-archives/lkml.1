Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbZD0SHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbZD0SHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758160AbZD0SG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:06:56 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62917 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757804AbZD0SG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:06:56 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 6/8] sh: Use __INIT macro instead of .text.init.
Date: Mon, 27 Apr 2009 14:02:25 -0400
Message-Id: <1240855347-19316-7-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240855347-19316-6-git-send-email-tabbott@mit.edu>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu>
 <1240855347-19316-2-git-send-email-tabbott@mit.edu>
 <1240855347-19316-3-git-send-email-tabbott@mit.edu>
 <1240855347-19316-4-git-send-email-tabbott@mit.edu>
 <1240855347-19316-5-git-send-email-tabbott@mit.edu>
 <1240855347-19316-6-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sh architecture has some code in the .text.init section, but it
does not reference that section in its linker scripts.

This change moves this code from the .text.init section to the
.init.text section, which is presumably where it belongs.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/kernel/cpu/sh5/entry.S |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/sh/kernel/cpu/sh5/entry.S b/arch/sh/kernel/cpu/sh5/entry.S
index e640c63..7e49cb8 100644
--- a/arch/sh/kernel/cpu/sh5/entry.S
+++ b/arch/sh/kernel/cpu/sh5/entry.S
@@ -10,6 +10,7 @@
  * for more details.
  */
 #include <linux/errno.h>
+#include <linux/init.h>
 #include <linux/sys.h>
 #include <cpu/registers.h>
 #include <asm/processor.h>
@@ -2058,10 +2059,10 @@ asm_uaccess_end:
 
 
 /*
- * --- .text.init Section
+ * --- .init.text Section
  */
 
-	.section	.text.init, "ax"
+	__INIT
 
 /*
  * void trap_init (void)
-- 
1.6.2.1

