Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZGBPQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZGBPQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbZGBPQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:16:05 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:53592 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZGBPQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QJQdyUkF1QsRuKNJB5lKKjEOytN/xVwmLAUh7okZFm1uXx6ROXglf1EDtqs6HFQV75
         jqzMLUlmf1Gi05BuJK0fcKP1SpzU1kGV4LuWUxk/j1nNQ+EKTY6o48laBAZNqP6hULLw
         /gOGjJ7ifRzHOII8LmgOhJFRkQcL21oBzA71g=
From: Wu <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH v4 00/16] Cleanup Lemote FuLoong2e Support
Date: Thu,  2 Jul 2009 23:15:52 +0800
Message-Id: <cover.1246546684.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patch series is the -v4 version of the loongson-PATCH-v3 series, but it
only include the cleanup for fuloong2e support and necessary preparation for
future fuloong-2f and yeeloong-2f support.

The git branch of this patch series is:

	git://dev.lemote.com/rt4ls.git linux-loongson/dev/fuloong2e

	or

	http://dev.lemote.com/cgit/rt4ls.git/log/?h=linux-loongson/dev/fuloong2e

Wu Zhangjin (16):
  [loongson] eary_printk: Remove existing implementation
  [loongson] kgdb: Remove out-of-date board-specific source code
  [loongson] early_printk: add new implmentation
  [loongson] pm: Remove redundant source code
  [loongson] pm: clean up the reboot support
  [loongson] pci: use existing mips_io_port_base
  [loongson] split the implementation of prom,setup parts
  [loongson] clean up the coding style
  [loongson] pci: clean up pcimap setup
  [loongson] rtc: enable legacy RTC driver on fulong
  [loongson] add oprofile support
  [loongson] change naming methods
  [loongson] split common loongson source code out
  [loongson] add a machtype kernel command line argument
  [loongson] add gcc 4.4 support for Loongson2E
  [loongson] update the default config file for fuloong2e

 Documentation/kernel-parameters.txt                |    4 +
 arch/mips/Kconfig                                  |   52 +-
 arch/mips/Makefile                                 |   15 +-
 arch/mips/configs/fulong_defconfig                 | 1912 --------------------
 arch/mips/configs/fuloong2e_defconfig              | 1819 +++++++++++++++++++
 arch/mips/include/asm/bootinfo.h                   |   12 +
 .../asm/mach-lemote/cpu-feature-overrides.h        |   59 -
 arch/mips/include/asm/mach-lemote/dma-coherence.h  |   68 -
 arch/mips/include/asm/mach-lemote/mc146818rtc.h    |   36 -
 arch/mips/include/asm/mach-lemote/pci.h            |   30 -
 arch/mips/include/asm/mach-lemote/war.h            |   25 -
 .../asm/mach-loongson/cpu-feature-overrides.h      |   59 +
 .../mips/include/asm/mach-loongson/dma-coherence.h |   68 +
 arch/mips/include/asm/mach-loongson/loongson.h     |   67 +
 arch/mips/include/asm/mach-loongson/machine.h      |   22 +
 arch/mips/include/asm/mach-loongson/mc146818rtc.h  |   36 +
 arch/mips/include/asm/mach-loongson/mem.h          |   30 +
 arch/mips/include/asm/mach-loongson/pci.h          |   37 +
 arch/mips/include/asm/mach-loongson/war.h          |   25 +
 arch/mips/include/asm/mips-boards/bonito64.h       |    2 +-
 arch/mips/lemote/lm2e/Makefile                     |    7 -
 arch/mips/lemote/lm2e/bonito-irq.c                 |   74 -
 arch/mips/lemote/lm2e/dbg_io.c                     |  146 --
 arch/mips/lemote/lm2e/irq.c                        |  143 --
 arch/mips/lemote/lm2e/mem.c                        |   23 -
 arch/mips/lemote/lm2e/pci.c                        |   97 -
 arch/mips/lemote/lm2e/prom.c                       |   97 -
 arch/mips/lemote/lm2e/reset.c                      |   41 -
 arch/mips/lemote/lm2e/setup.c                      |  111 --
 arch/mips/loongson/Kconfig                         |   31 +
 arch/mips/loongson/Makefile                        |   11 +
 arch/mips/loongson/common/Makefile                 |   11 +
 arch/mips/loongson/common/bonito-irq.c             |   51 +
 arch/mips/loongson/common/cmdline.c                |   52 +
 arch/mips/loongson/common/early_printk.c           |   38 +
 arch/mips/loongson/common/env.c                    |   58 +
 arch/mips/loongson/common/init.c                   |   30 +
 arch/mips/loongson/common/irq.c                    |   74 +
 arch/mips/loongson/common/machtype.c               |   50 +
 arch/mips/loongson/common/mem.c                    |   35 +
 arch/mips/loongson/common/pci.c                    |   83 +
 arch/mips/loongson/common/reset.c                  |   39 +
 arch/mips/loongson/common/setup.c                  |   60 +
 arch/mips/loongson/common/time.c                   |   27 +
 arch/mips/loongson/fuloong-2e/Makefile             |    7 +
 arch/mips/loongson/fuloong-2e/irq.c                |   71 +
 arch/mips/loongson/fuloong-2e/reset.c              |   24 +
 arch/mips/oprofile/Makefile                        |    1 +
 arch/mips/oprofile/common.c                        |    4 +
 arch/mips/oprofile/op_model_loongson2.c            |  177 ++
 arch/mips/pci/Makefile                             |    2 +-
 arch/mips/pci/fixup-fuloong2e.c                    |  224 +++
 arch/mips/pci/fixup-lm2e.c                         |  242 ---
 arch/mips/pci/ops-bonito64.c                       |    4 +-
 54 files changed, 3372 insertions(+), 3151 deletions(-)
 delete mode 100644 arch/mips/configs/fulong_defconfig
 create mode 100644 arch/mips/configs/fuloong2e_defconfig
 delete mode 100644 arch/mips/include/asm/mach-lemote/cpu-feature-overrides.h
 delete mode 100644 arch/mips/include/asm/mach-lemote/dma-coherence.h
 delete mode 100644 arch/mips/include/asm/mach-lemote/mc146818rtc.h
 delete mode 100644 arch/mips/include/asm/mach-lemote/pci.h
 delete mode 100644 arch/mips/include/asm/mach-lemote/war.h
 create mode 100644 arch/mips/include/asm/mach-loongson/cpu-feature-overrides.h
 create mode 100644 arch/mips/include/asm/mach-loongson/dma-coherence.h
 create mode 100644 arch/mips/include/asm/mach-loongson/loongson.h
 create mode 100644 arch/mips/include/asm/mach-loongson/machine.h
 create mode 100644 arch/mips/include/asm/mach-loongson/mc146818rtc.h
 create mode 100644 arch/mips/include/asm/mach-loongson/mem.h
 create mode 100644 arch/mips/include/asm/mach-loongson/pci.h
 create mode 100644 arch/mips/include/asm/mach-loongson/war.h
 delete mode 100644 arch/mips/lemote/lm2e/Makefile
 delete mode 100644 arch/mips/lemote/lm2e/bonito-irq.c
 delete mode 100644 arch/mips/lemote/lm2e/dbg_io.c
 delete mode 100644 arch/mips/lemote/lm2e/irq.c
 delete mode 100644 arch/mips/lemote/lm2e/mem.c
 delete mode 100644 arch/mips/lemote/lm2e/pci.c
 delete mode 100644 arch/mips/lemote/lm2e/prom.c
 delete mode 100644 arch/mips/lemote/lm2e/reset.c
 delete mode 100644 arch/mips/lemote/lm2e/setup.c
 create mode 100644 arch/mips/loongson/Kconfig
 create mode 100644 arch/mips/loongson/Makefile
 create mode 100644 arch/mips/loongson/common/Makefile
 create mode 100644 arch/mips/loongson/common/bonito-irq.c
 create mode 100644 arch/mips/loongson/common/cmdline.c
 create mode 100644 arch/mips/loongson/common/early_printk.c
 create mode 100644 arch/mips/loongson/common/env.c
 create mode 100644 arch/mips/loongson/common/init.c
 create mode 100644 arch/mips/loongson/common/irq.c
 create mode 100644 arch/mips/loongson/common/machtype.c
 create mode 100644 arch/mips/loongson/common/mem.c
 create mode 100644 arch/mips/loongson/common/pci.c
 create mode 100644 arch/mips/loongson/common/reset.c
 create mode 100644 arch/mips/loongson/common/setup.c
 create mode 100644 arch/mips/loongson/common/time.c
 create mode 100644 arch/mips/loongson/fuloong-2e/Makefile
 create mode 100644 arch/mips/loongson/fuloong-2e/irq.c
 create mode 100644 arch/mips/loongson/fuloong-2e/reset.c
 create mode 100644 arch/mips/oprofile/op_model_loongson2.c
 create mode 100644 arch/mips/pci/fixup-fuloong2e.c
 delete mode 100644 arch/mips/pci/fixup-lm2e.c

