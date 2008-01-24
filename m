Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbYAXQ5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbYAXQ5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbYAXQxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:19 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64217 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbYAXQxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:06 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 17/17] [MIPS] remove Documentation/mips/GT64120.README
Date: Thu, 24 Jan 2008 19:52:57 +0300
Message-Id: <1201193577-4261-18-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based upon the 2.4 kernel, the information presented in the
Documentation/mips/GT64120.README file is outdated. Worse,
the document contents are plain misleading nowadays because
the text mentions files and directories, which have been
deleted, moved or restructured for 2.6.

This patch removes the documentation, which is no more valid.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 Documentation/mips/00-INDEX       |    2 -
 Documentation/mips/GT64120.README |   65 -------------------------------------
 2 files changed, 0 insertions(+), 67 deletions(-)
 delete mode 100644 Documentation/mips/GT64120.README

diff --git a/Documentation/mips/00-INDEX b/Documentation/mips/00-INDEX
index 3f13bf8..8ae9cff 100644
--- a/Documentation/mips/00-INDEX
+++ b/Documentation/mips/00-INDEX
@@ -2,5 +2,3 @@
 	- this file.
 AU1xxx_IDE.README
 	- README for MIPS AU1XXX IDE driver.
-GT64120.README
-	- README for dir with info on MIPS boards using GT-64120 or GT-64120A.
diff --git a/Documentation/mips/GT64120.README b/Documentation/mips/GT64120.README
deleted file mode 100644
index 2d0eec9..0000000
--- a/Documentation/mips/GT64120.README
+++ /dev/null
@@ -1,65 +0,0 @@
-README for arch/mips/gt64120 directory and subdirectories
-
-Jun Sun, jsun@mvista.com or jsun@junsun.net
-01/27, 2001
-
-MOTIVATION
-----------
-
-Many MIPS boards share the same system controller (or CPU companian chip),
-such as GT-64120.  It is highly desirable to let these boards share
-the same controller code instead of duplicating them.
-
-This directory is meant to hold all MIPS boards that use GT-64120 or GT-64120A.
-
-
-HOW TO ADD A BOARD
-------------------
- 
-. Create a subdirectory include/asm/gt64120/<board>.  
-
-. Create a file called gt64120_dep.h under that directory.
-
-. Modify include/asm/gt64120/gt64120.h file to include the new gt64120_dep.h
-  based on config options.  The board-dep section is at the end of 
-  include/asm/gt64120/gt64120.h file. There you can find all required
-  definitions include/asm/gt64120/<board>/gt64120_dep.h file must supply.
-
-. Create a subdirectory arch/mips/gt64120/<board> directory to hold
-  board specific routines.
-
-. The GT-64120 common code is supplied under arch/mips/gt64120/common directory.
-  It includes:
-	1) arch/mips/gt64120/pci.c -
-		common PCI routine, include the top-level pcibios_init()
-	2) arch/mips/gt64120/irq.c -
-		common IRQ routine, include the top-level do_IRQ() 
-	   [This part really belongs to arch/mips/kernel. jsun]
- 	3) arch/mips/gt64120/gt_irq.c -
-		common IRQ routines for GT-64120 chip.  Currently it only handles
-	 	the timer interrupt.
-
-. Board-specific routines are supplied under arch/mips/gt64120/<board> dir.
-	1) arch/mips/gt64120/<board>/pci.c - it provides bus fixup routine
-	2) arch/mips/gt64120/<board>/irq.c - it provides enable/disable irqs
-		and board irq setup routine (irq_setup)
-	3) arch/mips/gt64120/<board>/int-handler.S -
-		The first-level interrupt dispatching routine.
-	4) a bunch of other "normal" stuff (setup, prom, dbg_io, reset, etc)
-
-. Follow other "normal" procedure to modify configuration files, etc.
-
-
-TO-DO LIST
-----------
-
-. Expand arch/mips/gt64120/gt_irq.c to handle all GT-64120 interrupts.
-  We probably need to introduce GT_IRQ_BASE  in board-dep header file,
-  which is used the starting irq_nr for all GT irqs.
-
-  A function, gt64120_handle_irq(), will be added so that the first-level
-  irq dispatcher will call this function if it detects an interrupt
-  from GT-64120.
-
-. More support for GT-64120 PCI features (2nd PCI bus, perhaps)
-
-- 
1.5.3

