Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682Ab0ARR2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab0ARR2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021Ab0ARRU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:20:26 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57577 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab0ARRUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:20:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AdpDUigLkcalM52KKjLpBhzxD4HKJDIKe4T3QMb2mv39SBqpEG+XV/ZolmAI8WwD+f
         qWC2s/84LAJz/Y7318f0ruHbN3COtCzK8a/kyodXNC7xFrxjwzdN6V/Lbdo9lFhjzP6m
         +Pnq7onA1H2f8Zo0Fyex/tMz9BoskOkacI0h0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:19:06 +0100
Message-Id: <20100118171906.14623.71239.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 35/64] opti621: remove stale driver history
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] opti621: remove stale driver history

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/opti621.c |   71 --------------------------------------------------
 1 file changed, 71 deletions(-)

Index: b/drivers/ide/opti621.c
===================================================================
--- a/drivers/ide/opti621.c
+++ b/drivers/ide/opti621.c
@@ -8,77 +8,6 @@
  * Jan Harkes <jaharkes@cwi.nl>,
  * Mark Lord <mlord@pobox.com>
  * Some parts of code are from ali14xx.c and from rz1000.c.
- *
- * OPTi is trademark of OPTi, Octek is trademark of Octek.
- *
- * I used docs from OPTi databook, from ftp.opti.com, file 9123-0002.ps
- * and disassembled/traced setupvic.exe (DOS program).
- * It increases kernel code about 2 kB.
- * I don't have this card no more, but I hope I can get some in case
- * of needed development.
- * My card is Octek PIDE 1.01 (on card) or OPTiViC (program).
- * It has a place for a secondary connector in circuit, but nothing
- * is there. Also BIOS says no address for
- * secondary controller (see bellow in ide_init_opti621).
- * I've only tested this on my system, which only has one disk.
- * It's Western Digital WDAC2850, with PIO mode 3. The PCI bus
- * is at 20 MHz (I have DX2/80, I tried PCI at 40, but I got random
- * lockups). I tried the OCTEK double speed CD-ROM and
- * it does not work! But I can't boot DOS also, so it's probably
- * hardware fault. I have connected Conner 80MB, the Seagate 850MB (no
- * problems) and Seagate 1GB (as slave, WD as master). My experiences
- * with the third, 1GB drive: I got 3MB/s (hdparm), but sometimes
- * it slows to about 100kB/s! I don't know why and I have
- * not this drive now, so I can't try it again.
- * I write this driver because I lost the paper ("manual") with
- * settings of jumpers on the card and I have to boot Linux with
- * Loadlin except LILO, cause I have to run the setupvic.exe program
- * already or I get disk errors (my test: rpm -Vf
- * /usr/X11R6/bin/XF86_SVGA - or any big file).
- * Some numbers from hdparm -t /dev/hda:
- * Timing buffer-cache reads:   32 MB in  3.02 seconds =10.60 MB/sec
- * Timing buffered disk reads:  16 MB in  5.52 seconds = 2.90 MB/sec
- * I have 4 Megs/s before, but I don't know why (maybe changes
- * in hdparm test).
- * After release of 0.1, I got some successful reports, so it might work.
- *
- * The main problem with OPTi is that some timings for master
- * and slave must be the same. For example, if you have master
- * PIO 3 and slave PIO 0, driver have to set some timings of
- * master for PIO 0. Second problem is that opti621_set_pio_mode
- * got only one drive to set, but have to set both drives.
- * This is solved in compute_pios. If you don't set
- * the second drive, compute_pios use ide_get_best_pio_mode
- * for autoselect mode (you can change it to PIO 0, if you want).
- * If you then set the second drive to another PIO, the old value
- * (automatically selected) will be overrided by yours.
- * There is a 25/33MHz switch in configuration
- * register, but driver is written for use at any frequency.
- *
- * Version 0.1, Nov 8, 1996
- * by Jaromir Koutek, for 2.1.8.
- * Initial version of driver.
- *
- * Version 0.2
- * Number 0.2 skipped.
- *
- * Version 0.3, Nov 29, 1997
- * by Mark Lord (probably), for 2.1.68
- * Updates for use with new IDE block driver.
- *
- * Version 0.4, Dec 14, 1997
- * by Jan Harkes
- * Fixed some errors and cleaned the code.
- *
- * Version 0.5, Jan 2, 1998
- * by Jaromir Koutek
- * Updates for use with (again) new IDE block driver.
- * Update of documentation.
- *
- * Version 0.6, Jan 2, 1999
- * by Jaromir Koutek
- * Reversed to version 0.3 of the driver, because
- * 0.5 doesn't work.
  */
 
 #include <linux/types.h>
