Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbXBEJhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbXBEJhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 04:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXBEJhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 04:37:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38565 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbXBEJhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 04:37:18 -0500
Date: Mon, 5 Feb 2007 09:45:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205084523.GA21858@elte.hu>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The half-time entertainment is provided by randomly inserted trivial 
> syntax errors that nerds are expected to fix at home before completing 
> the compile, but most people actually seem to mostly enjoy watching 
> the compile warnings, sponsored by Anheuser-Busch, scroll past.

i am honored to present the very first build fix for v2.6.20, as a
tribute to the Colts.

	Ingo

-------------------->
Subject: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: Ingo Molnar <mingo@elte.hu>

The very first "make ARCH=i386 randconfig" gave this build error:

    LD      vmlinux
  drivers/built-in.o: In function `cafe_nand_remove':
  cafe.c:(.text+0x19277a): undefined reference to `nand_release'
  drivers/built-in.o: In function `cafe_nand_cmdfunc':
  cafe.c:(.text+0x193036): undefined reference to `nand_wait_ready'
  drivers/built-in.o: In function `cafe_nand_probe':
  cafe.c:(.text+0x19359e): undefined reference to `nand_scan_ident'
  cafe.c:(.text+0x193658): undefined reference to `nand_scan_tail'
  distcc[1703] ERROR: compile (null) on localhost failed
  make: *** [vmlinux] Error 1

which i suspect was a side-effect of the late and optimistic MTD merge.

but hey, we always knew Linux was better at offense than at defense, and 
good offense is what wins the game in the end, as the Bears had to find 
out the hard way ;-)

so here's the fix for the 3 affected MTD drivers: DOC2000, DOC2001 and 
DOC2001PLUS.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/mtd/devices/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/drivers/mtd/devices/Kconfig
===================================================================
--- linux.orig/drivers/mtd/devices/Kconfig
+++ linux/drivers/mtd/devices/Kconfig
@@ -152,6 +152,7 @@ config MTD_DOC2000
 	tristate "M-Systems Disk-On-Chip 2000 and Millennium (DEPRECATED)"
 	depends on MTD
 	select MTD_DOCPROBE
+	select MTD_NAND
 	select MTD_NAND_IDS
 	---help---
 	  This provides an MTD device driver for the M-Systems DiskOnChip
@@ -175,6 +176,7 @@ config MTD_DOC2001
 	tristate "M-Systems Disk-On-Chip Millennium-only alternative driver (DEPRECATED)"
 	depends on MTD
 	select MTD_DOCPROBE
+	select MTD_NAND
 	select MTD_NAND_IDS
 	---help---
 	  This provides an alternative MTD device driver for the M-Systems
@@ -197,6 +199,7 @@ config MTD_DOC2001PLUS
 	tristate "M-Systems Disk-On-Chip Millennium Plus"
 	depends on MTD
 	select MTD_DOCPROBE
+	select MTD_NAND
 	select MTD_NAND_IDS
 	---help---
 	  This provides an MTD device driver for the M-Systems DiskOnChip
