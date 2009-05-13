Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbZEMAH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbZEMAH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755765AbZEMAHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:07:38 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56373 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZEMAHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:07:37 -0400
MBOX-Line: From nobody Tue May 12 18:05:09 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 00/10] OMAP clock/SDRC patches on v2.6.30-rc5
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Date: Tue, 12 May 2009 18:05:09 -0600
Message-ID: <20090512235713.10349.49339.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

This series contains OMAP clock and SDRAM controller patches against
v2.6.30-rc5.  If you are happy with these, Tony will merge them into
his for-next branch for you to pull.

This series includes the clk_init_one() to clk_preinit() rename that
we've discussed recently.  Most of the patches prepare for CORE DPLL
M2 rate changing support.


regards,

- Paul

---

Artem Bityutskiy (1):
      OMAP3 clock: lessen amount of noisy messages

Paul Walmsley (9):
      OMAP2xxx clock: rename clk_init_one() to clk_preinit()
      OMAP3 clock: use pr_debug() rather than pr_info() in some clock change code
      OMAP3 clock: only unlock SDRC DLL if SDRC clk < 83MHz
      OMAP3 SRAM: renumber registers to make space for argument passing
      OMAP3 SDRC: initialize SDRC_POWER at boot
      OMAP3 SRAM: clear the SDRC PWRENA bit during SDRC frequency change
      OMAP3 clock: add interconnect barriers to CORE DPLL M2 change
      OMAP3 SRAM: add ARM barriers to omap3_sram_configure_core_dpll
      OMAP3 SRAM: mark OCM RAM as Non-cacheable Normal memory


 arch/arm/mach-omap1/clock.c             |    2 
 arch/arm/mach-omap2/clock.c             |   14 ++-
 arch/arm/mach-omap2/clock24xx.c         |    2 
 arch/arm/mach-omap2/clock34xx.c         |   20 +++--
 arch/arm/mach-omap2/sdrc.c              |   19 ++++-
 arch/arm/mach-omap2/sram34xx.S          |  129 ++++++++++++++++---------------
 arch/arm/plat-omap/clock.c              |    4 -
 arch/arm/plat-omap/include/mach/clock.h |    2 
 arch/arm/plat-omap/include/mach/sram.h  |    6 +
 arch/arm/plat-omap/sram.c               |   16 +++-
 10 files changed, 128 insertions(+), 86 deletions(-)

