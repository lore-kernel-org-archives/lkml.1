Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbZA1Upv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbZA1Upv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbZA1UbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:31:18 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47755 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbZA1UbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:31:16 -0500
MBOX-Line: From nobody Tue Jan 27 19:44:01 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH B 00/10] OMAP clock, B of F: clockdomain, powerdomain updates
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Date: Tue, 27 Jan 2009 19:44:01 -0700
Message-ID: <20090128024301.27240.39391.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is the second of six to bring the mainline kernel OMAP
clock code up-to-date with the linux-omap tree.

Major changes in this series:

- Fix clockdomain, powerdomain code and data to match the hardware
- Add PRCM clockdomains
- Add DPLL clockdomains, powerdomains
- Mark all OMAP clocks with clockdomains
- Combine pwrdm, clkdm names and pointers into unions

Some patches have been "compressed" together, as requested by rmk -
original commit IDs are in the patch descriptions.

Compile-tested on OSK5912 (OMAP1), H4 and 2430SDP (OMAP2), and
BeagleBoard (OMAP3).  Boot-tested on 2430SDP and BeagleBoard.

Applies on top of series A, posted earlier.


- Paul

---

Jouni Hogander (1):
      OMAP3: PM: Emu_pwrdm is switched off by hardware even when sdti is in use

Paul Walmsley (8):
      OMAP2/3 clockdomains: autodeps should respect platform flags
      OMAP3 powerdomains: remove RET from SGX power states list
      OMAP3 pwrdm: add CORE SAR handling (for USBTLL module)
      OMAP2/3 clock: add clockdomains to all remaining clocks; fix clkdm init
      OMAP3 PRCM: add DPLL1-5 powerdomains, clockdomains; mark clocks
      OMAP2/3 clockdomains: add CM, PRM, virt_opp_clkdm clockdomains
      OMAP2/3 clockdomains: combine pwrdm, pwrdm_name into union in struct clockdomain
      OMAP2/3 clock: combine clkdm, clkdm_name into union in struct clk

Tomi Valkeinen (1):
      OMAP: wait for pwrdm transition after clk_enable()


 arch/arm/mach-omap2/clock.c                   |   26 +-
 arch/arm/mach-omap2/clock24xx.c               |    2 
 arch/arm/mach-omap2/clock24xx.h               |  278 ++++++++++---------
 arch/arm/mach-omap2/clock34xx.h               |  369 +++++++++++++++----------
 arch/arm/mach-omap2/clockdomain.c             |   58 ++--
 arch/arm/mach-omap2/clockdomains.h            |  125 ++++++--
 arch/arm/mach-omap2/powerdomains.h            |    8 -
 arch/arm/mach-omap2/powerdomains34xx.h        |   61 ++++
 arch/arm/plat-omap/include/mach/clock.h       |    6 
 arch/arm/plat-omap/include/mach/clockdomain.h |   24 +-
 arch/arm/plat-omap/include/mach/powerdomain.h |    4 
 11 files changed, 586 insertions(+), 375 deletions(-)

   text	   data	    bss	    dec	    hex	filename
3241423	 164192	 100912	3506527	 35815f	vmlinux.beagle.orig
3241711	 163872	 100912	3506495	 35813f	vmlinux.beagle


