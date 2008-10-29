Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbYJ2QQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbYJ2QQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYJ2QQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:16:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:40662 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbYJ2QQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:16:34 -0400
Date: Wed, 29 Oct 2008 09:17:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] corruption checker: print the DMI board name
Message-ID: <20081029091703.47628e54@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 4f829eef5a31b68a0cbaf83a75ac8b0a1ed05afb Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 29 Oct 2008 09:13:23 -0700
Subject: [PATCH] corruption checker: print the DMI board name

when the memory corruptor checker hits (as it has done now based on kerneloops.org data),
it would be extremely useful to know the DMI board name so we can add a blacklist for
such a machine... without having to ask the user for lots of extra info.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/check.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 2ac0ab7..f952182 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -2,6 +2,7 @@
 #include <linux/sched.h>
 #include <linux/kthread.h>
 #include <linux/workqueue.h>
+#include <linux/dmi.h>
 #include <asm/e820.h>
 #include <asm/proto.h>
 
@@ -113,6 +114,7 @@ void check_for_bios_corruption(void)
 {
 	int i;
 	int corruption = 0;
+	const char *board;
 
 	if (!memory_corruption_check)
 		return;
@@ -131,7 +133,11 @@ void check_for_bios_corruption(void)
 		}
 	}
 
-	WARN_ONCE(corruption, KERN_ERR "Memory corruption detected in low memory\n");
+	board = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!board)
+		board = "";
+	WARN_ONCE(corruption, KERN_ERR "Memory corruption detected in low memory\nBoard name: %s\n",
+		board);
 }
 
 static void check_corruption(struct work_struct *dummy);
-- 
1.5.5.1


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
