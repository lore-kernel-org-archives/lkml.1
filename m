Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZJ0XHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZJ0XHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 19:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbZJ0XHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 19:07:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:57072 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbZJ0XHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 19:07:48 -0400
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1256627452.11607.90.camel@pasglop>
References: <1256627452.11607.90.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Oct 2009 10:07:23 +1100
Message-ID: <1256684843.11607.115.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 18:11 +1100, Benjamin Herrenschmidt wrote:
> Hi Linus !
> 
> Some of these might have been better in -rc4 or earlier, all my fault
> for having some backlog that I'm still going through. So we have some
> bug fixes (not necessarily regressions but also generally simple
> enough that I decided to go for 2.6.32 anyways) and a few very trivial
> Kconfig cleanups (outside of arch/powerpc but related to our symbols)
> from Kumar that could go anytime.

I also had a pending pull request from Grant that I had forgotten. I
added that, it's also minor stuff (device-tree and defconfig updates
mostly and a couple of bug fixes).

New consolidated pull request below.

Cheers,
Ben.

The following changes since commit 964fe080d94db82a3268443e9b9ece4c60246414:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Andreas Schwab (2):
      powerpc: Fix segment mapping in vdso32
      powerpc: Align vDSO base address

Benjamin Herrenschmidt (2):
      powerpc/ppc64: Use preempt_schedule_irq instead of preempt_schedule
      Merge commit 'gcl/merge' into merge

Grant Likely (1):
      powerpc/5200: Update defconfigs

Heiko Schocher (2):
      mpc5200: support for the MAN mpc5200 based board uc101
      mpc5200: support for the MAN mpc5200 based board mucmc52

Josh Boyer (1):
      powerpc/booke: Fix xmon single step on PowerPC Book-E

Julia Lawall (1):
      drivers/serial/mpc52xx_uart.c: Use UPIO_MEM rather than SERIAL_IO_MEM

Jérôme Pouiller (1):
      of: Remove nested function

Kumar Gala (7):
      powerpc: Add a Book-3E 64-bit defconfig
      powerpc: Fix compile errors found by new ppc64e_defconfig
      powerpc: Limit hugetlbfs support to PPC64 Book-3S machines
      powerpc: Limit memory hotplug support to PPC64 Book-3S machines
      powerpc: Minor cleanup to init/Kconfig
      powerpc: Minor cleanup to sound/ppc/Kconfig
      powerpc: Minor cleanup to lib/Kconfig.debug

Michael Neuling (1):
      powerpc/perf_events: Fix priority of MSR HV vs PR bits

Stephen Rothwell (1):
      powerpc/iseries: Remove compiler version dependent hack

Wolfram Sang (1):
      powerpc/boot/dts: drop obsolete 'fsl5200-clocking'

 arch/powerpc/boot/dts/cm5200.dts              |    1 -
 arch/powerpc/boot/dts/digsy_mtc.dts           |    1 -
 arch/powerpc/boot/dts/lite5200.dts            |    2 -
 arch/powerpc/boot/dts/lite5200b.dts           |    2 -
 arch/powerpc/boot/dts/media5200.dts           |    2 -
 arch/powerpc/boot/dts/motionpro.dts           |    1 -
 arch/powerpc/boot/dts/mpc5121ads.dts          |    3 -
 arch/powerpc/boot/dts/mucmc52.dts             |  332 ++++
 arch/powerpc/boot/dts/pcm030.dts              |    2 -
 arch/powerpc/boot/dts/pcm032.dts              |    2 -
 arch/powerpc/boot/dts/tqm5200.dts             |    1 -
 arch/powerpc/boot/dts/uc101.dts               |  284 ++++
 arch/powerpc/configs/52xx/cm5200_defconfig    |  136 +-
 arch/powerpc/configs/52xx/lite5200b_defconfig |  153 ++-
 arch/powerpc/configs/52xx/motionpro_defconfig |  146 +-
 arch/powerpc/configs/52xx/pcm030_defconfig    |  142 +-
 arch/powerpc/configs/52xx/tqm5200_defconfig   |  148 +-
 arch/powerpc/configs/mpc5200_defconfig        |  192 ++-
 arch/powerpc/configs/ppc64e_defconfig         | 2199 +++++++++++++++++++++++++
 arch/powerpc/kernel/entry_64.S                |   41 +-
 arch/powerpc/kernel/pci_64.c                  |    2 +
 arch/powerpc/kernel/perf_event.c              |   17 +-
 arch/powerpc/kernel/process.c                 |    2 +-
 arch/powerpc/kernel/setup_64.c                |    1 -
 arch/powerpc/kernel/vdso.c                    |   11 +-
 arch/powerpc/kernel/vdso32/vdso32.lds.S       |    4 +-
 arch/powerpc/platforms/52xx/mpc5200_simple.c  |    2 +
 arch/powerpc/platforms/iseries/Makefile       |   11 +-
 arch/powerpc/platforms/iseries/dt.c           |   56 +-
 arch/powerpc/xmon/xmon.c                      |   20 +-
 drivers/of/of_mdio.c                          |   13 +-
 drivers/serial/mpc52xx_uart.c                 |    2 +-
 fs/Kconfig                                    |    2 +-
 init/Kconfig                                  |    2 +-
 lib/Kconfig.debug                             |    2 +-
 mm/Kconfig                                    |    2 +-
 sound/ppc/Kconfig                             |    2 +-
 37 files changed, 3490 insertions(+), 451 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/mucmc52.dts
 create mode 100644 arch/powerpc/boot/dts/uc101.dts
 create mode 100644 arch/powerpc/configs/ppc64e_defconfig


