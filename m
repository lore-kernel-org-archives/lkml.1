Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbZA1Uqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbZA1Uqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbZA1Ubt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:31:49 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47765 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbZA1Ubs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:31:48 -0500
MBOX-Line: From nobody Wed Jan 28 12:08:05 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH C 00/13] OMAP clock, C of F: DPLL updates
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Date: Wed, 28 Jan 2009 12:08:05 -0700
Message-ID: <20090128190724.12092.22239.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is the third of six to bring the mainline kernel OMAP
clock code up-to-date with the linux-omap tree.

Major changes in this series:

- Fix DPLL jitter compensation (FREQSEL).
- Calculate correct rates when DPLL is in bypass.
- Remove the virtual "bypass clocks."
- Optimize DPLL rate rounding algorithm.

Some patches have been "compressed" together, as requested by rmk -
original commit IDs are in the patch descriptions.

Compile-tested on OSK5912 (OMAP1), H4 and 2430SDP (OMAP2), and
BeagleBoard (OMAP3).  Boot-tested on 2430SDP and BeagleBoard.

Applies on top of series B, posted earlier.


- Paul

---

Paul Walmsley (12):
      OMAP3 clock: disable DPLL autoidle while waiting for DPLL to lock
      OMAP3 clock: avoid invalid FREQSEL values during DPLL rate rounding
      OMAP3 clock: optimize DPLL rate rounding algorithm
      OMAP3 clock: remove unnecessary dpll_data dereferences
      OMAP3 clock: fix non-CORE DPLL rate assignment bugs
      OMAP3 clock: put DPLL into bypass if bypass rate = clk->rate, not hardware rate
      OMAP3 clock: recalculate DPLL subtree after bypass entry/exit
      OMAP3 clock: DPLLs should enter bypass if new rate is sys_ck
      OMAP3 clock: note the bypass source clock for DPLLs
      OMAP3 clock: convert dpll_data.idlest_bit to idlest_mask
      OMAP3 clock: DPLL{1,2}_FCLK clksel can divide by 4
      OMAP3 clock: fix DPLL jitter correction and rate programming

Tero Kristo (1):
      OMAP2/3 clock: fix DPLL rate calculation


 arch/arm/mach-omap2/clock.c             |  162 +++++++++++++++++++-----
 arch/arm/mach-omap2/clock.h             |   15 ++
 arch/arm/mach-omap2/clock24xx.c         |   43 ++++--
 arch/arm/mach-omap2/clock24xx.h         |    3 
 arch/arm/mach-omap2/clock34xx.c         |   95 +++++++++-----
 arch/arm/mach-omap2/clock34xx.h         |  213 +++++++------------------------
 arch/arm/mach-omap2/memory.c            |    2 
 arch/arm/plat-omap/include/mach/clock.h |   15 +-
 8 files changed, 296 insertions(+), 252 deletions(-)

   text    data     bss     dec     hex filename
3241711  163872  100912 3506495  35813f vmlinux.beagle.orig
3241515  163680  100912 3506107  357fbb vmlinux.beagle


