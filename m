Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab0BCFQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 00:16:41 -0500
Received: from adelie.canonical.com ([91.189.90.139]:33838 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab0BCFQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 00:16:40 -0500
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, Dinh.Nguyen@freescale.com,
       r.herring@freescale.com, bryan.wu@canonical.com
Subject: [PATCHv2 00/11] Base support for Freescale i.MX51 SoC platform
Date: Tue,  2 Feb 2010 21:16:22 -0800
Message-Id: <cover.1265173246.git.amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches adds basic support for i.MX5 family to the kernel. The
target device is the i.MX51-based Babbage board (v2.5+) since that is the
hardware I have access to.

This is a result of dropping a lot of functionality from the existing
Freescale codebase that is shipping as part of the Ubuntu ARM enablement. A
lot of the code was refactored to use facilities that were already available
upstream in arch/arm/plat-mxc/. The hope is to get this base port into
mainline and then start working on mainlining the drivers.

With regards to the splitting of the patches, I felt that the following
patchset made it easy to review code. But if this is not acceptable and some
of these patches need to be merged into a single patch, I can do that too.

Changelog:

V1: Initial submission of base port
V2: - Split core code enabling i.MX51 and the babbage board
    - Refactor timer code to use version 1 or 2 of timer (patch by Sascha)
    - Fixes from review of V1

Regards,
Amit

Amit Kucheria (9):
  arm: mxc: TrustZone interrupt controller (TZIC) for i.MX5 family
  mxc: Fix Drive Strength Field in the IOMUX controller
  mxc: changes to common plat-mxc code to add support for i.MX5
  mxc: Core support for i.MX5 series of processors from Freescale
  mxc: enable support for Freescale i.MX5 series of processors
  mxc: Add support for the Babbage board
  fec: Add LAN8700 phy support
  fec: Add ARCH_MX5 as a dependency
  mxc: Add imx51_defconfig

Rob Herring (1):
  fec: fix uninitialized rx buffer usage

Sascha Hauer (1):
  mxc timer: refactor timer code to use timer versions

 arch/arm/Makefile                            |    1 +
 arch/arm/configs/imx51_defconfig             | 1286 ++++++++++++++++++++++++++
 arch/arm/mach-mx5/Kconfig                    |   17 +
 arch/arm/mach-mx5/Makefile                   |    9 +
 arch/arm/mach-mx5/Makefile.boot              |    3 +
 arch/arm/mach-mx5/board-mx51_babbage.c       |   99 ++
 arch/arm/mach-mx5/clock.c                    |  848 +++++++++++++++++
 arch/arm/mach-mx5/cpu.c                      |   45 +
 arch/arm/mach-mx5/crm_regs.h                 |  583 ++++++++++++
 arch/arm/mach-mx5/devices.c                  |   96 ++
 arch/arm/mach-mx5/devices.h                  |    4 +
 arch/arm/mach-mx5/mm.c                       |   88 ++
 arch/arm/plat-mxc/Kconfig                    |   16 +
 arch/arm/plat-mxc/Makefile                   |    3 +
 arch/arm/plat-mxc/include/mach/common.h      |    6 +
 arch/arm/plat-mxc/include/mach/debug-macro.S |    9 +
 arch/arm/plat-mxc/include/mach/entry-macro.S |   34 +-
 arch/arm/plat-mxc/include/mach/hardware.h    |    4 +
 arch/arm/plat-mxc/include/mach/iomux-mx51.h  |  340 +++++++
 arch/arm/plat-mxc/include/mach/iomux-v3.h    |    8 +-
 arch/arm/plat-mxc/include/mach/irqs.h        |    9 +-
 arch/arm/plat-mxc/include/mach/memory.h      |    3 +
 arch/arm/plat-mxc/include/mach/mx51.h        |  454 +++++++++
 arch/arm/plat-mxc/include/mach/mxc.h         |   13 +
 arch/arm/plat-mxc/include/mach/timex.h       |    2 +
 arch/arm/plat-mxc/time.c                     |   23 +-
 arch/arm/plat-mxc/tzic.c                     |  182 ++++
 drivers/net/Kconfig                          |    3 +-
 drivers/net/fec.c                            |   78 +-
 29 files changed, 4222 insertions(+), 44 deletions(-)
 create mode 100644 arch/arm/configs/imx51_defconfig
 create mode 100644 arch/arm/mach-mx5/Kconfig
 create mode 100644 arch/arm/mach-mx5/Makefile
 create mode 100644 arch/arm/mach-mx5/Makefile.boot
 create mode 100644 arch/arm/mach-mx5/board-mx51_babbage.c
 create mode 100644 arch/arm/mach-mx5/clock.c
 create mode 100644 arch/arm/mach-mx5/cpu.c
 create mode 100644 arch/arm/mach-mx5/crm_regs.h
 create mode 100644 arch/arm/mach-mx5/devices.c
 create mode 100644 arch/arm/mach-mx5/devices.h
 create mode 100644 arch/arm/mach-mx5/mm.c
 create mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx51.h
 create mode 100644 arch/arm/plat-mxc/include/mach/mx51.h
 create mode 100644 arch/arm/plat-mxc/tzic.c

