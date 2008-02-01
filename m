Return-Path: <linux-kernel-owner+w=401wt.eu-S1762859AbYBANBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859AbYBANBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbYBANBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:01:16 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:48745 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbYBANBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:01:15 -0500
Date: Fri, 1 Feb 2008 08:01:05 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, axboe@kernel.dk
Subject: [PATCH] BLOCK: Remove obsolete fd1772.h header file.
Message-ID: <alpine.LFD.1.00.0802010759110.29664@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Given that the entire drivers/acorn/block/ directory no longer exists
(which included fd1772.c), there seems to be little reason to keep
this unreferenced header file.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/include/linux/fd1772.h b/include/linux/fd1772.h
deleted file mode 100644
index 871d6e4..0000000
--- a/include/linux/fd1772.h
+++ /dev/null
@@ -1,80 +0,0 @@
-#ifndef _LINUX_FD1772REG_H
-#define _LINUX_FD1772REG_H
-
-/*
-** WD1772 stuff - originally from the M68K Linux
- * Modified for Archimedes by Dave Gilbert (gilbertd@cs.man.ac.uk)
- */
-
-/* register codes */
-
-#define FDC1772SELREG_STP   (0x80)   /* command/status register */
-#define FDC1772SELREG_TRA   (0x82)   /* track register */
-#define FDC1772SELREG_SEC   (0x84)   /* sector register */
-#define FDC1772SELREG_DTA   (0x86)   /* data register */
-
-/* register names for FDC1772_READ/WRITE macros */
-
-#define FDC1772REG_CMD         0
-#define FDC1772REG_STATUS      0
-#define FDC1772REG_TRACK       2
-#define FDC1772REG_SECTOR      4
-#define FDC1772REG_DATA                6
-
-/* command opcodes */
-
-#define FDC1772CMD_RESTORE  (0x00)   /*  -                   */
-#define FDC1772CMD_SEEK     (0x10)   /*   |                  */
-#define FDC1772CMD_STEP     (0x20)   /*   |  TYP 1 Commands  */
-#define FDC1772CMD_STIN     (0x40)   /*   |                  */
-#define FDC1772CMD_STOT     (0x60)   /*  -                   */
-#define FDC1772CMD_RDSEC    (0x80)   /*  -   TYP 2 Commands  */
-#define FDC1772CMD_WRSEC    (0xa0)   /*  -          "        */
-#define FDC1772CMD_RDADR    (0xc0)   /*  -                   */
-#define FDC1772CMD_RDTRA    (0xe0)   /*   |  TYP 3 Commands  */
-#define FDC1772CMD_WRTRA    (0xf0)   /*  -                   */
-#define FDC1772CMD_FORCI    (0xd0)   /*  -   TYP 4 Command   */
-
-/* command modifier bits */
-
-#define FDC1772CMDADD_SR6   (0x00)   /* step rate settings */
-#define FDC1772CMDADD_SR12  (0x01)
-#define FDC1772CMDADD_SR2   (0x02)
-#define FDC1772CMDADD_SR3   (0x03)
-#define FDC1772CMDADD_V     (0x04)   /* verify */
-#define FDC1772CMDADD_H     (0x08)   /* wait for spin-up */
-#define FDC1772CMDADD_U     (0x10)   /* update track register */
-#define FDC1772CMDADD_M     (0x10)   /* multiple sector access */
-#define FDC1772CMDADD_E     (0x04)   /* head settling flag */
-#define FDC1772CMDADD_P     (0x02)   /* precompensation */
-#define FDC1772CMDADD_A0    (0x01)   /* DAM flag */
-
-/* status register bits */
-
-#define        FDC1772STAT_MOTORON     (0x80)   /* motor on */
-#define        FDC1772STAT_WPROT       (0x40)   /* write protected (FDC1772CMD_WR*) */
-#define        FDC1772STAT_SPINUP      (0x20)   /* motor speed stable (Type I) */
-#define        FDC1772STAT_DELDAM      (0x20)   /* sector has deleted DAM (Type II+III) */
-#define        FDC1772STAT_RECNF       (0x10)   /* record not found */
-#define        FDC1772STAT_CRC         (0x08)   /* CRC error */
-#define        FDC1772STAT_TR00        (0x04)   /* Track 00 flag (Type I) */
-#define        FDC1772STAT_LOST        (0x04)   /* Lost Data (Type II+III) */
-#define        FDC1772STAT_IDX         (0x02)   /* Index status (Type I) */
-#define        FDC1772STAT_DRQ         (0x02)   /* DRQ status (Type II+III) */
-#define        FDC1772STAT_BUSY        (0x01)   /* FDC1772 is busy */
-
-
-/* PSG Port A Bit Nr 0 .. Side Sel .. 0 -> Side 1  1 -> Side 2 */
-#define DSKSIDE     (0x01)
-
-#define DSKDRVNONE  (0x06)
-#define DSKDRV0     (0x02)
-#define DSKDRV1     (0x04)
-
-/* step rates */
-#define        FDC1772STEP_6   0x00
-#define        FDC1772STEP_12  0x01
-#define        FDC1772STEP_2   0x02
-#define        FDC1772STEP_3   0x03
-
-#endif
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

Home page:                                         http://crashcourse.ca
Fedora Cookbook:    http://crashcourse.ca/wiki/index.php/Fedora_Cookbook
========================================================================
