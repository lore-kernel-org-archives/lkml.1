Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbXLFMul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbXLFMul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXLFMno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:43:44 -0500
Received: from nic2.axis.se ([193.13.178.10]:35763 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbXLFMnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:43:42 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <e3e8c6a368f3085b7ecfcb0d8b05cb84d7641fc7.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 16:13:29 +0100
Subject: [PATCH 27/47] Update CRISv10 rescue head.s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Correct whitespace problems.
- Add ifdef for ETRAX_AXISFLASHMAP to avoid compile error when not set.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/boot/rescue/head.S |  117 +++++++++++++++++----------------
 1 files changed, 61 insertions(+), 56 deletions(-)

diff --git a/arch/cris/arch-v10/boot/rescue/head.S b/arch/cris/arch-v10/boot/rescue/head.S
index f223cc0..cf644e2 100644
--- a/arch/cris/arch-v10/boot/rescue/head.S
+++ b/arch/cris/arch-v10/boot/rescue/head.S
@@ -1,5 +1,4 @@
-/* $Id: head.S,v 1.7 2005/03/07 12:11:06 starvik Exp $
- * 
+/*
  * Rescue code, made to reside at the beginning of the
  * flash-memory. when it starts, it checks a partition
  * table at the first sector after the rescue sector.
@@ -23,20 +22,20 @@
  * Partition table format:
  *
  *     Code transparency:
- * 
+ *
  *     2 bytes    [opcode 'nop']
  *     2 bytes    [opcode 'di']
  *     4 bytes    [opcode 'ba <offset>', 8-bit or 16-bit version]
  *     2 bytes    [opcode 'nop', delay slot]
  *
- *     Table validation (at +10):	
- * 
+ *     Table validation (at +10):
+ *
  *     2 bytes    [magic/version word for partitiontable - 0xef, 0xbe]
  *     2 bytes    [length of all entries plus the end marker]
  *     4 bytes    [checksum for the partitiontable itself]
  *
- *     Entries, each with the following format, last has offset -1:	
- *    
+ *     Entries, each with the following format, last has offset -1:
+ *
  *        4 bytes    [offset in bytes, from start of flash]
  *        4 bytes    [length in bytes of partition]
  *        4 bytes    [checksum, simple longword sum]
@@ -47,9 +46,9 @@
  *     End marker
  *
  *        4 bytes    [-1]
- * 
+ *
  *	 10 bytes    [0, padding]
- * 
+ *
  * Bit 0 in flags signifies RW or RO. The rescue code only bothers
  * to check the checksum for RO partitions, since the others will
  * change their data without updating the checksums. A 1 in bit 0
@@ -59,16 +58,18 @@
  *
  * During the wait for serial input, the status LED will flash so the
  * user knows something went wrong.
- * 
- * Copyright (C) 1999, 2000, 2001, 2002, 2003 Axis Communications AB
+ *
+ * Copyright (C) 1999-2007 Axis Communications AB
  */
 
+#ifdef CONFIG_ETRAX_AXISFLASHMAP
+
 #define ASSEMBLER_MACROS_ONLY
 #include <asm/arch/sv_addr_ag.h>
 
 	;; The partitiontable is looked for at the first sector after the boot
 	;; sector. Sector size is 65536 bytes in all flashes we use.
-		
+
 #define PTABLE_START CONFIG_ETRAX_PTABLE_SECTOR
 #define PTABLE_MAGIC 0xbeef
 
@@ -78,7 +79,7 @@
 	;; having setup the DRAM etc). It is the same length as the on-chip
 	;; ROM loads, so the same host loader can be used to load a rescued
 	;; product as well as one booted through the Etrax serial boot code.
-		
+
 #define CODE_START 0x40000000
 #define CODE_LENGTH 784
 
@@ -102,7 +103,7 @@
 #define SERRECC R_SERIAL2_REC_CTRL
 #define SERRDAT R_SERIAL2_REC_DATA
 #define SERSTAT R_SERIAL2_STATUS
-#endif	
+#endif
 #ifdef CONFIG_ETRAX_RESCUE_SER3
 #define SERXOFF R_SERIAL3_XOFF
 #define SERBAUD R_SERIAL3_BAUD
@@ -115,60 +116,61 @@
 #define RAM_INIT_MAGIC 0x56902387
 
 	.text
-	
+
 	;; This is the entry point of the rescue code
 	;; 0x80000000 if loaded in flash (as it should be)
-	;; since etrax actually starts at address 2 when booting from flash, we
+	;; Since etrax actually starts at address 2 when booting from flash, we
 	;; put a nop (2 bytes) here first so we dont accidentally skip the di
 
-	nop	
+	nop
 	di
 
 	jump	in_cache	; enter cached area instead
 in_cache:
 
 
-	;; first put a jump test to give a possibility of upgrading the rescue code
-	;; without erasing/reflashing the sector. we put a longword of -1 here and if
-	;; it is not -1, we jump using the value as jump target. since we can always
-	;; change 1's to 0's without erasing the sector, it is possible to add new
+	;; First put a jump test to give a possibility of upgrading the
+	;; rescue code without erasing/reflashing the sector.
+	;; We put a longword of -1 here and if it is not -1, we jump using
+	;; the value as jump target. Since we can always change 1's to 0's
+	;; without erasing the sector, it is possible to add new
 	;; code after this and altering the jumptarget in an upgrade.
 
 jtcd:	move.d	[jumptarget], $r0
 	cmp.d	0xffffffff, $r0
 	beq	no_newjump
 	nop
-	
+
 	jump	[$r0]
 
-jumptarget:	
+jumptarget:
 	.dword	0xffffffff	; can be overwritten later to insert new code
-	
+
 no_newjump:
-#ifdef CONFIG_ETRAX_ETHERNET		
+#ifdef CONFIG_ETRAX_ETHERNET
 	;; Start MII clock to make sure it is running when tranceiver is reset
 	move.d 0x3, $r0    ; enable = on, phy = mii_clk
 	move.d $r0, [R_NETWORK_GEN_CONFIG]
 #endif
-	
+
 	;; We need to setup the bus registers before we start using the DRAM
 #include "../../lib/dram_init.S"
 
 	;; we now should go through the checksum-table and check the listed
 	;; partitions for errors.
-	
+
 	move.d	PTABLE_START, $r3
 	move.d	[$r3], $r0
 	cmp.d	NOP_DI, $r0	; make sure the nop/di is there...
 	bne	do_rescue
 	nop
-	
+
 	;; skip the code transparency block (10 bytes).
 
 	addq	10, $r3
-	
+
 	;; check for correct magic
-	
+
 	move.w	[$r3+], $r0
 	cmp.w	PTABLE_MAGIC, $r0
 	bne	do_rescue	; didn't recognize - trig rescue
@@ -186,11 +188,11 @@ no_newjump:
 	cmp.d	$r0, $r4
 	bne	do_rescue	; didn't match - trig rescue
 	nop
-	
+
 	;; ptable is ok. validate each entry.
 
 	moveq	-1, $r7
-	
+
 ploop:	move.d	[$r3+], $r1	; partition offset (from ptable start)
 	bne	notfirst	; check if it is the partition containing ptable
 	nop			; yes..
@@ -199,7 +201,7 @@ ploop:	move.d	[$r3+], $r1	; partition offset (from ptable start)
 	sub.d	$r8, $r2	; minus the ptable length
 	ba	bosse
 	nop
-notfirst:	
+notfirst:
 	cmp.d	-1, $r1		; the end of the ptable ?
 	beq	flash_ok	;   if so, the flash is validated
 	move.d	[$r3+], $r2	; partition length
@@ -213,47 +215,46 @@ bosse:	move.d	[$r3+], $r5	; checksum
 	bpl	1f
 	nop
 	move.d	$r1, $r7	; remember boot partition offset
-1:	
-
+1:
 	add.d	PTABLE_START, $r1
-	
+
 	jsr	checksum	; checksum the partition
-	
+
 	cmp.d	$r0, $r5
 	beq	ploop		; checksums matched, go to next entry
 	nop
 
 	;; otherwise fall through to the rescue code.
-	
+
 do_rescue:
 	;; setup port PA and PB default initial directions and data
 	;; (so we can flash LEDs, and so that DTR and others are set)
-	
+
 	move.b	CONFIG_ETRAX_DEF_R_PORT_PA_DIR, $r0
 	move.b	$r0, [R_PORT_PA_DIR]
 	move.b	CONFIG_ETRAX_DEF_R_PORT_PA_DATA, $r0
 	move.b	$r0, [R_PORT_PA_DATA]
-	
+
 	move.b	CONFIG_ETRAX_DEF_R_PORT_PB_DIR, $r0
 	move.b	$r0, [R_PORT_PB_DIR]
 	move.b	CONFIG_ETRAX_DEF_R_PORT_PB_DATA, $r0
 	move.b	$r0, [R_PORT_PB_DATA]
 
 	;; setup the serial port at 115200 baud
-	
+
 	moveq	0, $r0
-	move.d	$r0, [SERXOFF] 
+	move.d	$r0, [SERXOFF]
 
 	move.b	0x99, $r0
-	move.b	$r0, [SERBAUD]		; 115.2kbaud for both transmit and receive
+	move.b	$r0, [SERBAUD]	; 115.2kbaud for both transmit and receive
 
-	move.b	0x40, $r0		; rec enable
-	move.b	$r0, [SERRECC] 
+	move.b	0x40, $r0	; rec enable
+	move.b	$r0, [SERRECC]
 
 	moveq	0, $r1		; "timer" to clock out a LED red flash
 	move.d	CODE_START, $r3	; destination counter
 	movu.w	CODE_LENGTH, $r4; length
-	
+
 wait_ser:
 	addq	1, $r1
 #ifndef CONFIG_ETRAX_NO_LEDS
@@ -272,20 +273,20 @@ wait_ser:
 	nop
 1:	not	$r0		; clear bit
 	and.d	$r0, $r2
-2:	
+2:
 #ifdef CONFIG_ETRAX_PA_LEDS
-	move.b	$r2, [R_PORT_PA_DATA]	
-#endif	
+	move.b	$r2, [R_PORT_PA_DATA]
+#endif
 #ifdef CONFIG_ETRAX_PB_LEDS
-	move.b	$r2, [R_PORT_PB_DATA]	
+	move.b	$r2, [R_PORT_PB_DATA]
 #endif
 #ifdef CONFIG_ETRAX_90000000_LEDS
 	move.b	$r2, [0x90000000]
 #endif
 #endif
-	
+
 	;; check if we got something on the serial port
-	
+
 	move.b	[SERSTAT], $r0
 	btstq	0, $r0		; data_avail
 	bpl	wait_ser
@@ -295,14 +296,15 @@ wait_ser:
 
 	move.b	[SERRDAT], $r0
 	move.b	$r0, [$r3+]
-	
+
 	subq	1, $r4		; decrease length
 	bne	wait_ser
 	nop
 
 	;; jump into downloaded code
 
-	move.d	RAM_INIT_MAGIC, $r8	; Tell next product that DRAM is initialized
+	move.d	RAM_INIT_MAGIC, $r8	; Tell next product that DRAM is
+					; initialized
 	jump	CODE_START
 
 flash_ok:
@@ -313,7 +315,8 @@ flash_ok:
 	nop
 	move.d	PTABLE_START, $r7; otherwise use the ptable start
 1:
-	move.d	RAM_INIT_MAGIC, $r8	; Tell next product that DRAM is initialized
+	move.d	RAM_INIT_MAGIC, $r8	; Tell next product that DRAM is
+					; initialized
 	jump	$r7		; boot!
 
 
@@ -327,7 +330,7 @@ checksum:
 	moveq	0, $r0
 	moveq   CONFIG_ETRAX_FLASH1_SIZE, $r6
 
-	;; If the first physical flash memory is exceeded wrap to the second one.
+	;; If the first physical flash memory is exceeded wrap to the second one
 	btstq	26, $r1		; Are we addressing first flash?
 	bpl	1f
 	nop
@@ -351,3 +354,5 @@ checksum:
 3:	move.d	MEM_CSE1_START, $r1 ; wrap to second flash
 	ba	2b
 	nop
+
+#endif
-- 
1.5.3.6.970.gd25430

