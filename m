Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZLDCrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZLDCrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 21:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZLDCrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 21:47:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:52133 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbZLDCrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 21:47:08 -0500
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com
Subject: [RFC][PATCH 00/10] Base support for Freescale i.MX51 SoC platform
Date: Fri,  4 Dec 2009 04:47:00 +0200
Message-Id: <cover.1259893118.git.amit.kucheria@canonical.com>
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

Regards,
Amit

Amit Kucheria (8):
  arm: mxc: New interrupt controller (TZIC) for i.MX5 family
  arm: mxc: base support for Freescale i.MX51 processor
  arm: mxc: changes to common plat-mxc code to add support for i.MX5
  arm: mxc: Fix Drive Strength Field in the IOMUX controller
  mxc: Add board support for the i.MX51 babbage board
  fec: Add LAN8700 phy support
  fec: Add ARCH_MX5 as a dependency
  arm: mxc: Add imx51_defconfig

Dinh Nguyen (1):
  arm: mxc: Add IO multiplexing support for FEC

Rob Herring (1):
  fec: fix uninitialized rx buffer usage

 arch/arm/Makefile                            |    1 +
 arch/arm/configs/imx51_defconfig             | 1383 ++++++++++++++++++++++++++
 arch/arm/mach-mx5/Kconfig                    |   17 +
 arch/arm/mach-mx5/Makefile                   |    9 +
 arch/arm/mach-mx5/Makefile.boot              |    3 +
 arch/arm/mach-mx5/board-mx51_babbage.c       |  184 ++++
 arch/arm/mach-mx5/clock.c                    |  817 +++++++++++++++
 arch/arm/mach-mx5/cpu.c                      |   46 +
 arch/arm/mach-mx5/crm_regs.h                 |  685 +++++++++++++
 arch/arm/mach-mx5/devices.c                  |   90 ++
 arch/arm/mach-mx5/devices.h                  |    4 +
 arch/arm/mach-mx5/mm.c                       |   86 ++
 arch/arm/plat-mxc/Kconfig                    |   12 +
 arch/arm/plat-mxc/Makefile                   |    9 +-
 arch/arm/plat-mxc/include/mach/common.h      |    3 +
 arch/arm/plat-mxc/include/mach/debug-macro.S |    9 +
 arch/arm/plat-mxc/include/mach/entry-macro.S |   34 +-
 arch/arm/plat-mxc/include/mach/hardware.h    |    4 +
 arch/arm/plat-mxc/include/mach/iomux-mx51.h  |  309 ++++++
 arch/arm/plat-mxc/include/mach/iomux-v3.h    |   16 +-
 arch/arm/plat-mxc/include/mach/irqs.h        |    9 +-
 arch/arm/plat-mxc/include/mach/memory.h      |    3 +
 arch/arm/plat-mxc/include/mach/mx51.h        |  481 +++++++++
 arch/arm/plat-mxc/include/mach/mxc.h         |   13 +
 arch/arm/plat-mxc/include/mach/timex.h       |    2 +
 arch/arm/plat-mxc/time.c                     |   52 +-
 arch/arm/plat-mxc/tzic.c                     |  180 ++++
 drivers/net/Kconfig                          |    3 +-
 drivers/net/fec.c                            |   78 +-
 29 files changed, 4506 insertions(+), 36 deletions(-)
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

