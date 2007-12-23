Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbXLWTQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbXLWTQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 14:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXLWTQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 14:16:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:48184 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbXLWTQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 14:16:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=kZHRxbUnAMuXRT/FAruB3H/0LogdX7eWOtvGDJPkVC5ux21f+y+p/wOr8OTVyzq+191PWG2VVSY5GTs/tVGTF0yZs9l1Zb9USFOJf93QLo7GFI25WjeTGnFOTJyYJTELSea9dBKWOdgCmy3kvSUxdPzoxASIxdcKV50EtTBwbME=
Message-ID: <476EB3FA.5090607@gmail.com>
Date: Sun, 23 Dec 2007 22:16:10 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: jsun@mvista.com
CC: jsun@junsun.net, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6] remove Documentation/mips/GT64120.README
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being related to 2.4 kernel, the information presented in the `Documentation/mips/GT64120.README' file is outdated. Worse, the document contents are plain misleading nowadays because the text mentions files and directories, which have been deleted, moved or restructured for 2.6.

In my opinion, this file should be deleted from the 2.6 kernel tree.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

--

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
