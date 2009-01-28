Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbZA1Uj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbZA1Uj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZA1U3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:46 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32948 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbZA1U3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:31 -0500
MBOX-Line: From nobody Tue Jan 27 19:12:43 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH A 00/10] OMAP clock, A of F: preliminaries
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Date: Tue, 27 Jan 2009 19:12:43 -0700
Message-ID: <20090128020447.7244.80496.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series A is the first of six to bring the mainline kernel OMAP
clock code up-to-date with the linux-omap tree.

Major changes in this series:

. Clean up sparse, checkpatch issues in PM code
. Synchronize clock tree with what is on the hardware 
. Add DPLL programming code
. Use PRCM rates for CPUfreq

Some patches have been "compressed" together, as requested by rmk -
original commit IDs are in the patch descriptions.

Compile-tested on OSK5912 (OMAP1), H4 and 2430SDP (OMAP2), and
BeagleBoard (OMAP3).  Boot-tested on 2430SDP and BeagleBoard.

Applies on 5ee810072175042775e39bdd3eaaa68884c27805.


- Paul

---

Daniel Stone (1):
      OMAP2: Fix definition of SGX clock register bits

Kevin Hilman (1):
      OMAP2: Implement CPUfreq frequency table based on PRCM table

Paul Walmsley (6):
      OMAP: Make dpll4_m4_ck programmable with clk_set_rate()
      OMAP3 clock: fix 96MHz clocks
      OMAP3: move USBHOST SAR handling from clock framework to powerdomain layer
      OMAP24xx clock: add missing SSI L4 interface clock
      OMAP: Fix sparse, checkpatch warnings in OMAP2/3 PRCM/PM code
      OMAP2/3: Add non-CORE DPLL rate set code and M,N programming

Sergio Aguirre (1):
      OMAP: Add CSI2 clock struct for handling it with clock API.

Tony Lindgren (1):
      OMAP2/3: Remove OMAP_PRM_REGADDR, OMAP_CM_REGADDR


 arch/arm/mach-omap2/clock.c                   |   83 ++--
 arch/arm/mach-omap2/clock.h                   |    2 
 arch/arm/mach-omap2/clock24xx.c               |  145 +++++--
 arch/arm/mach-omap2/clock24xx.h               |  335 +++++++++-------
 arch/arm/mach-omap2/clock34xx.c               |  141 +++++++
 arch/arm/mach-omap2/clock34xx.h               |  516 +++++++++++++------------
 arch/arm/mach-omap2/cm-regbits-34xx.h         |   25 +
 arch/arm/mach-omap2/cm.h                      |   17 -
 arch/arm/mach-omap2/memory.c                  |    3 
 arch/arm/mach-omap2/pm.c                      |    2 
 arch/arm/mach-omap2/powerdomains34xx.h        |    1 
 arch/arm/mach-omap2/prm-regbits-34xx.h        |    9 
 arch/arm/mach-omap2/prm.h                     |  166 ++++----
 arch/arm/mach-omap2/sram242x.S                |    5 
 arch/arm/mach-omap2/sram243x.S                |    5 
 arch/arm/plat-omap/common.c                   |    1 
 arch/arm/plat-omap/cpu-omap.c                 |   57 +++
 arch/arm/plat-omap/include/mach/clock.h       |   11 -
 arch/arm/plat-omap/include/mach/common.h      |    5 
 arch/arm/plat-omap/include/mach/powerdomain.h |    1 
 arch/arm/plat-omap/include/mach/prcm.h        |    5 
 arch/arm/plat-omap/include/mach/system.h      |    4 
 22 files changed, 949 insertions(+), 590 deletions(-)


   text    data     bss     dec     hex filename
3240479  164160  100912 3505551  357d8f vmlinux.beagle.orig
3241423  164192  100912 3506527  35815f vmlinux.beagle

