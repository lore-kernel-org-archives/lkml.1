Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab0CCFH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:07:56 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:37573 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab0CCFHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:07:53 -0500
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, armando.visconti@st.com, amit.goel@st.com,
       shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
       deepak.sikri@st.com, ashish.priyadarshi@st.com,
       Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 00/11] Adding Support for SPEAr Platform under ARM architecture
Date: Wed,  3 Mar 2010 10:37:30 +0530
Message-Id: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following set of patches are for adding ST Microelctronics SPEAr Platform under
ARM architecture in Linux.

Hierarchy in SPEAr is as follows:
SPEAr (Platform)
	- SPEAr3XX (3XX SOC series, based on ARM9)
		- SPEAr300 (SOC)
			- SPEAr300_EVB (Evaluation Board)
		- SPEAr310 (SOC)
			- SPEAr310_EVB (Evaluation Board)
		- SPEAr320 (SOC)
			- SPEAr320_EVB (Evaluation Board)
	- SPEAr6XX (6XX SOC series, based on ARM9)
		- SPEAr600 (SOC)
			- SPEAr600_EVB (Evaluation Board)
	- SPEAr13XX (13XX SOC series, based on ARM CORTEXA9)
		- SPEAr1300 (SOC)

Current patch will add support for SPEAr3XX and SPEAr6XX family. SPEAr13XX is
under development phase.

Viresh Kumar (11):
  ST SPEAr: Added ARM PrimeXsys System Controller SP810 header file
  ST SPEAr: Added basic header files for SPEAr3xx machine family
  ST SPEAr: Added basic header files for SPEAr6xx machine family
  ST SPEAr: Added basic header files for SPEAr platform
  ST SPEAr: Added clock framework for SPEAr platform and machines
  ST SPEAr: Added source files for SPEAr platform
  ST SPEAr: Added source files for SPEAr3xx machine family
  ST SPEAr: Added source files for SPEAr6xx machine family
  ST SPEAr: Added support for SPEAr platform and machines in arch/arm/
  ST SPEAr: Added default configuration files for SPEAr machines
  ST SPEAr: Updated Maintainers and added Documentation/arm/SPEAr

 Documentation/arm/SPEAr/overview.txt              |   60 +
 MAINTAINERS                                       |   27 +
 arch/arm/Kconfig                                  |   11 +
 arch/arm/Makefile                                 |    5 +
 arch/arm/configs/spear300_defconfig               | 1409 ++++++++++++++++++++
 arch/arm/configs/spear310_defconfig               | 1410 ++++++++++++++++++++
 arch/arm/configs/spear320_defconfig               | 1410 ++++++++++++++++++++
 arch/arm/configs/spear600_defconfig               | 1451 +++++++++++++++++++++
 arch/arm/mach-spear3xx/Kconfig                    |   33 +
 arch/arm/mach-spear3xx/Kconfig300                 |   17 +
 arch/arm/mach-spear3xx/Kconfig310                 |   17 +
 arch/arm/mach-spear3xx/Kconfig320                 |   17 +
 arch/arm/mach-spear3xx/Makefile                   |   26 +
 arch/arm/mach-spear3xx/Makefile.boot              |    3 +
 arch/arm/mach-spear3xx/clock.c                    |  525 ++++++++
 arch/arm/mach-spear3xx/include/mach/clkdev.h      |   19 +
 arch/arm/mach-spear3xx/include/mach/debug-macro.S |   38 +
 arch/arm/mach-spear3xx/include/mach/dma.h         |   18 +
 arch/arm/mach-spear3xx/include/mach/entry-macro.S |   46 +
 arch/arm/mach-spear3xx/include/mach/generic.h     |   39 +
 arch/arm/mach-spear3xx/include/mach/hardware.h    |   20 +
 arch/arm/mach-spear3xx/include/mach/io.h          |   22 +
 arch/arm/mach-spear3xx/include/mach/irqs.h        |   57 +
 arch/arm/mach-spear3xx/include/mach/memory.h      |   20 +
 arch/arm/mach-spear3xx/include/mach/misc_regs.h   |  163 +++
 arch/arm/mach-spear3xx/include/mach/spear.h       |  136 ++
 arch/arm/mach-spear3xx/include/mach/spear300.h    |   64 +
 arch/arm/mach-spear3xx/include/mach/spear310.h    |   43 +
 arch/arm/mach-spear3xx/include/mach/spear320.h    |   69 +
 arch/arm/mach-spear3xx/include/mach/system.h      |   41 +
 arch/arm/mach-spear3xx/include/mach/timex.h       |   19 +
 arch/arm/mach-spear3xx/include/mach/uncompress.h  |   43 +
 arch/arm/mach-spear3xx/include/mach/vmalloc.h     |   22 +
 arch/arm/mach-spear3xx/spear300.c                 |   23 +
 arch/arm/mach-spear3xx/spear300_evb.c             |   47 +
 arch/arm/mach-spear3xx/spear310.c                 |   23 +
 arch/arm/mach-spear3xx/spear310_evb.c             |   47 +
 arch/arm/mach-spear3xx/spear320.c                 |   23 +
 arch/arm/mach-spear3xx/spear320_evb.c             |   47 +
 arch/arm/mach-spear3xx/spear3xx.c                 |  118 ++
 arch/arm/mach-spear6xx/Kconfig                    |   20 +
 arch/arm/mach-spear6xx/Kconfig600                 |   17 +
 arch/arm/mach-spear6xx/Makefile                   |   12 +
 arch/arm/mach-spear6xx/Makefile.boot              |    3 +
 arch/arm/mach-spear6xx/clock.c                    |  656 ++++++++++
 arch/arm/mach-spear6xx/include/mach/clkdev.h      |   19 +
 arch/arm/mach-spear6xx/include/mach/debug-macro.S |   38 +
 arch/arm/mach-spear6xx/include/mach/dma.h         |   17 +
 arch/arm/mach-spear6xx/include/mach/entry-macro.S |   55 +
 arch/arm/mach-spear6xx/include/mach/generic.h     |   37 +
 arch/arm/mach-spear6xx/include/mach/hardware.h    |   21 +
 arch/arm/mach-spear6xx/include/mach/io.h          |   23 +
 arch/arm/mach-spear6xx/include/mach/irqs.h        |   92 ++
 arch/arm/mach-spear6xx/include/mach/memory.h      |   20 +
 arch/arm/mach-spear6xx/include/mach/misc_regs.h   |  173 +++
 arch/arm/mach-spear6xx/include/mach/spear.h       |  165 +++
 arch/arm/mach-spear6xx/include/mach/spear600.h    |   21 +
 arch/arm/mach-spear6xx/include/mach/system.h      |   41 +
 arch/arm/mach-spear6xx/include/mach/timex.h       |   19 +
 arch/arm/mach-spear6xx/include/mach/uncompress.h  |   43 +
 arch/arm/mach-spear6xx/include/mach/vmalloc.h     |   22 +
 arch/arm/mach-spear6xx/spear600.c                 |   23 +
 arch/arm/mach-spear6xx/spear600_evb.c             |   48 +
 arch/arm/mach-spear6xx/spear6xx.c                 |  149 +++
 arch/arm/plat-spear/Kconfig                       |   31 +
 arch/arm/plat-spear/Makefile                      |    6 +
 arch/arm/plat-spear/clock.c                       |  433 ++++++
 arch/arm/plat-spear/gpt.c                         |  537 ++++++++
 arch/arm/plat-spear/include/plat/clkdev.h         |   20 +
 arch/arm/plat-spear/include/plat/clock.h          |  130 ++
 arch/arm/plat-spear/include/plat/gpt.h            |  108 ++
 arch/arm/plat-spear/time.c                        |  197 +++
 include/linux/sysctl_sp810.h                      |   59 +
 73 files changed, 10883 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/arm/SPEAr/overview.txt
 create mode 100644 arch/arm/configs/spear300_defconfig
 create mode 100644 arch/arm/configs/spear310_defconfig
 create mode 100644 arch/arm/configs/spear320_defconfig
 create mode 100644 arch/arm/configs/spear600_defconfig
 create mode 100644 arch/arm/mach-spear3xx/Kconfig
 create mode 100644 arch/arm/mach-spear3xx/Kconfig300
 create mode 100644 arch/arm/mach-spear3xx/Kconfig310
 create mode 100644 arch/arm/mach-spear3xx/Kconfig320
 create mode 100644 arch/arm/mach-spear3xx/Makefile
 create mode 100644 arch/arm/mach-spear3xx/Makefile.boot
 create mode 100755 arch/arm/mach-spear3xx/clock.c
 create mode 100644 arch/arm/mach-spear3xx/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-spear3xx/include/mach/dma.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-spear3xx/include/mach/generic.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/hardware.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/io.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/irqs.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/memory.h
 create mode 100755 arch/arm/mach-spear3xx/include/mach/misc_regs.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/spear.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/spear300.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/spear310.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/spear320.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/system.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/timex.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-spear3xx/spear300.c
 create mode 100644 arch/arm/mach-spear3xx/spear300_evb.c
 create mode 100644 arch/arm/mach-spear3xx/spear310.c
 create mode 100644 arch/arm/mach-spear3xx/spear310_evb.c
 create mode 100644 arch/arm/mach-spear3xx/spear320.c
 create mode 100644 arch/arm/mach-spear3xx/spear320_evb.c
 create mode 100644 arch/arm/mach-spear3xx/spear3xx.c
 create mode 100644 arch/arm/mach-spear6xx/Kconfig
 create mode 100644 arch/arm/mach-spear6xx/Kconfig600
 create mode 100644 arch/arm/mach-spear6xx/Makefile
 create mode 100644 arch/arm/mach-spear6xx/Makefile.boot
 create mode 100755 arch/arm/mach-spear6xx/clock.c
 create mode 100644 arch/arm/mach-spear6xx/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-spear6xx/include/mach/dma.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-spear6xx/include/mach/generic.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/hardware.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/io.h
 create mode 100755 arch/arm/mach-spear6xx/include/mach/irqs.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/memory.h
 create mode 100755 arch/arm/mach-spear6xx/include/mach/misc_regs.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/spear.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/spear600.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/system.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/timex.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-spear6xx/spear600.c
 create mode 100644 arch/arm/mach-spear6xx/spear600_evb.c
 create mode 100644 arch/arm/mach-spear6xx/spear6xx.c
 create mode 100644 arch/arm/plat-spear/Kconfig
 create mode 100644 arch/arm/plat-spear/Makefile
 create mode 100755 arch/arm/plat-spear/clock.c
 create mode 100644 arch/arm/plat-spear/gpt.c
 create mode 100644 arch/arm/plat-spear/include/plat/clkdev.h
 create mode 100755 arch/arm/plat-spear/include/plat/clock.h
 create mode 100644 arch/arm/plat-spear/include/plat/gpt.h
 create mode 100644 arch/arm/plat-spear/time.c
 create mode 100644 include/linux/sysctl_sp810.h

