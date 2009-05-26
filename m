Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZEZWWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZEZWWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598AbZEZWW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:22:26 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:33543 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987AbZEZWWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:22:24 -0400
MBOX-Line: From nobody Tue May 26 16:12:26 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 00/10] OMAP clock/powerdomain/SDRC patches for post-2.6.30
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Date: Tue, 26 May 2009 16:12:26 -0600
Message-ID: <20090526220517.25381.75976.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

here is the next set of OMAP clock patches for review for the
post-2.6.30 merge window.  They apply on top of the previous set
("OMAP clock/SDRC patches on v2.6.30-rc5").  If you're happy with
these patches, Tony will queue them up into his for-next branch.

This series completes basic support for OMAP3 CORE DVFS.  A few other
minor bugs are fixed by the off-by-one patch and the GPIO debounce
clock patch.


regards,

- Paul

---

Paul Walmsley (8):
      OMAP3 clock: GPIO de-bounce clocks don't affect module idle state
      OMAP3 SDRC: set FIXEDDELAY when disabling SDRC DLL
      OMAP3 SRAM: convert SRAM code to use macros rather than magic numbers
      OMAP3 SRAM: add more comments on the SRAM code
      OMAP3 clock/SDRC: program SDRC_MR register during SDRC clock change
      OMAP3 clock: add a short delay when lowering CORE clk rate
      OMAP3 clock: initialize SDRC timings at kernel start
      OMAP3 clock: remove wait for DPLL3 M2 clock to stabilize

Roel Kluin (1):
      OMAP2 clock/powerdomain: off by 1 error in loop timeout comparisons

Tero Kristo (1):
      OMAP3: Add support for DPLL3 divisor values higher than 2


 arch/arm/mach-omap2/clock.c            |    2 
 arch/arm/mach-omap2/clock34xx.c        |   42 ++++++++--
 arch/arm/mach-omap2/clock34xx.h        |   12 +--
 arch/arm/mach-omap2/io.c               |   38 +++++++++
 arch/arm/mach-omap2/powerdomain.c      |    2 
 arch/arm/mach-omap2/sram34xx.S         |  129 +++++++++++++++++++++-----------
 arch/arm/plat-omap/include/mach/sram.h |    6 +
 arch/arm/plat-omap/sram.c              |    8 +-
 8 files changed, 171 insertions(+), 68 deletions(-)

