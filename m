Return-Path: <linux-kernel-owner+w=401wt.eu-S937155AbXG0Jxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937155AbXG0Jxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936678AbXG0JtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:49:16 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:36794 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936594AbXG0JtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:49:13 -0400
Date: Fri, 27 Jul 2007 11:47:47 +0200 (MEST)
Message-Id: <200707270947.LAA17593@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 20/68] 0 -> NULL, for arch/xtensa
Cc: chris@zankel.net, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When comparing a pointer, it's clearer to compare it to NULL than to 0.

Here is an excerpt of the semantic patch: 

@@
expression *E;
@@

  E ==
- 0
+ NULL

@@
expression *E;
@@

  E !=
- 0
+ NULL

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: chris@zankel.net
Cc: akpm@linux-foundation.org
---

 kernel/pci.c           |    2 +-
 kernel/traps.c         |    2 +-
 platform-iss/console.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/kernel/pci.c b/arch/xtensa/kernel/pci.c
index 77deae5..1102816 100644
--- a/arch/xtensa/kernel/pci.c
+++ b/arch/xtensa/kernel/pci.c
@@ -306,7 +306,7 @@ __pci_mmap_make_offset(struct pci_dev *d
 	unsigned long io_offset = 0;
 	int i, res_bit;
 
-	if (pci_ctrl == 0)
+	if (pci_ctrl == NULL)
 		return -EINVAL;		/* should never happen */
 
 	/* If memory, add on the PCI bridge address offset */
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index c5e62f9..eb21c7c 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -419,7 +419,7 @@ void show_stack(struct task_struct *task
 	int i = 0;
 	unsigned long *stack;
 
-	if (sp == 0)
+	if (sp == NULL)
 		__asm__ __volatile__ ("mov %0, a1\n" : "=a"(sp));
 
  	stack = sp;
diff --git a/arch/xtensa/platform-iss/console.c b/arch/xtensa/platform-iss/console.c
index 2f4f20f..ad8d65e 100644
--- a/arch/xtensa/platform-iss/console.c
+++ b/arch/xtensa/platform-iss/console.c
@@ -265,7 +265,7 @@ static void iss_console_write(struct con
 {
 	int len = strlen(s);
 
-	if (s != 0 && *s != 0)
+	if (s != NULL && *s != 0)
 		__simc (SYS_write, 1, (unsigned long)s,
 			count < len ? count : len,0,0);
 }

