Return-Path: <linux-kernel-owner+w=401wt.eu-S968262AbXGaEcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968262AbXGaEcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932268AbXGaEaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:30:19 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42299 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936189AbXGaEaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:30:15 -0400
Date: Mon, 30 Jul 2007 21:31:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Geller Sandor <wildy@petra.hos.u-szeged.hu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 06/26] hpt366: disallow Ultra133 for HPT374
Message-ID: <20070731043144.GG3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hpt366-disallow-ultra133-for-hpt374.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------

Eliminate UltraATA/133 support for HPT374 -- the chip isn't capable of this mode
according to the manual, and doesn't even seem to tolerate 66 MHz DPLL clock...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Geller Sandor <wildy@petra.hos.u-szeged.hu>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/pci/hpt366.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.21.6.orig/drivers/ide/pci/hpt366.c
+++ linux-2.6.21.6/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.03	May 4, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.04	Jun 4, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -106,7 +106,8 @@
  *   switch  to calculating  PCI clock frequency based on the chip's base DPLL
  *   frequency
  * - switch to using the  DPLL clock and enable UltraATA/133 mode by default on
- *   anything  newer than HPT370/A
+ *   anything  newer than HPT370/A (except HPT374 that is not capable of this
+ *   mode according to the manual)
  * - fold PCI clock detection and DPLL setup code into init_chipset_hpt366(),
  *   also fixing the interchanged 25/40 MHz PCI clock cases for HPT36x chips;
  *   unify HPT36x/37x timing setup code and the speedproc handlers by joining
@@ -365,7 +366,6 @@ static u32 sixty_six_base_hpt37x[] = {
 };
 
 #define HPT366_DEBUG_DRIVE_INFO		0
-#define HPT374_ALLOW_ATA133_6		1
 #define HPT371_ALLOW_ATA133_6		1
 #define HPT302_ALLOW_ATA133_6		1
 #define HPT372_ALLOW_ATA133_6		1
@@ -450,7 +450,7 @@ static struct hpt_info hpt370a __devinit
 
 static struct hpt_info hpt374 __devinitdata = {
 	.chip_type	= HPT374,
-	.max_mode	= HPT374_ALLOW_ATA133_6 ? 4 : 3,
+	.max_mode	= 3,
 	.dpll_clk	= 48,
 	.settings	= hpt37x_settings
 };

-- 
