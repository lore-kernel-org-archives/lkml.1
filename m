Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbXCUGut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbXCUGut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbXCUGut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:50:49 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:16853 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbXCUGus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:50:48 -0400
Message-ID: <d4cf37a60703202350p2e24c805oe84f3459fda0c0a9@mail.gmail.com>
Date: Tue, 20 Mar 2007 23:50:47 -0700
From: "Wink Saville" <wink@saville.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] Added trec_snapshot and trec_print_snapshot to do_page_fault() when the kernel itself faults
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wink Saville <wink@saville.com>
---
 arch/x86_64/mm/fault.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index 6ada723..9857ade 100644
--- a/arch/x86_64/mm/fault.c
+++ b/arch/x86_64/mm/fault.c
@@ -25,6 +25,10 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>

+#ifdef CONFIG_TREC
+#include <linux/trec.h>
+#endif
+
 #include <asm/system.h>
 #include <asm/pgalloc.h>
 #include <asm/smp.h>
@@ -534,6 +538,9 @@ no_context:
  */

 	flags = oops_begin();
+#ifdef CONFIG_TREC
+	trec_snapshot();
+#endif

 	if (address < PAGE_SIZE)
 		printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference");
@@ -548,6 +555,9 @@ no_context:
 	__die("Oops", regs, error_code);
 	/* Executive summary in case the body of the oops scrolled away */
 	printk(KERN_EMERG "CR2: %016lx\n", address);
+#ifdef CONFIG_TREC
+	trec_print_snapshot();
+#endif
 	oops_end(flags);
 	do_exit(SIGKILL);

-- 
1.5.0.rc2
