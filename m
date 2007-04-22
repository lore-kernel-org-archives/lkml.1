Return-Path: <linux-kernel-owner+w=401wt.eu-S1030727AbXDVToM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030727AbXDVToM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 15:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030801AbXDVToM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 15:44:12 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36079 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030727AbXDVToL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 15:44:11 -0400
Date: Sun, 22 Apr 2007 21:45:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mikael Starvik <mikael.starvik@axis.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.20 7/14] CRIS architecture update - Boot
Message-ID: <20070422194501.GB17258@uranus.ravnborg.org>
References: <BFECAF9E178F144FAEF2BF4CE739C66803BEEE1D@exmail1.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C66803BEEE1D@exmail1.se.axis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 09:25:23PM +0200, Mikael Starvik wrote:
> The attached patch relates to CRIS kernel booting (decompresser etc)

--- ../linux/arch/cris/arch-v32/boot/compressed/Makefile        2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6/arch/cris/arch-v32/boot/compressed/Makefile       2007-02-13 12:55:23.000000000 +0100
@@ -1,41 +1,30 @@
 #
-# lx25/arch/cris/arch-v32/boot/compressed/Makefile
+# arch/cris/arch-v32/boot/compressed/Makefile
 #
-# create a compressed vmlinux image from the original vmlinux files and romfs
-#
-
-target = $(target_compressed_dir)
-src    = $(src_compressed_dir)

-CC = gcc-cris -mlinux -march=v32 -I $(TOPDIR)/include
-CFLAGS = -O2
+CC = gcc-cris -mlinux -march=v32 -I $(TOPDIR)/include
+AFLAGS += -I $(TOPDIR)/include/asm/mach/ -I $(TOPDIR)/include/asm/arch
+CFLAGS += -O2 -I $(TOPDIR)/include/asm/mach/ -I $(TOPDIR)/include/asm/arch
 LD = gcc-cris -mlinux -march=v32 -nostdlib

Use of $(TOPDIR) is deprecated.
Please replace with $(srctree).

There was lots of other Makefile changes but they looked OK in general.
When the patch-set I would like to give to full set a review - please ping me.

	Sam
