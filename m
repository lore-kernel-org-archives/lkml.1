Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833Ab0A1Mq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0A1Mq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122Ab0A1Mq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:46:59 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:41181 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab0A1Mq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:46:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=u9h84wkOF2/3lkN2/EFZU8nbyBNtn/KwPHxEbuKyUA7jTv7ciSD9or9OfnFPGm5Ioj
         GRcG6ydjq6B6pXX7lbwskNDDc/oK97JTLPo37jkh1DmIbekwsL1ThKSqifUa+P1SJBUX
         on1lYiph04ywHOFvbL3XTrIRUkydJhh+PiBU4=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux@arm.linux.org.uk
Cc: eric.y.miao@gmail.com, tony@atomide.com, linux-kernel@vger.kernel.org,
       khilman@deeprootsystems.com, lethal@linux-sh.org, ben-linux@fluff.org,
       Magnus Damm <magnus.damm@gmail.com>,
       linux-arm-kernel@lists.infradead.org
Date: Thu, 28 Jan 2010 21:40:28 +0900
Message-Id: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se>
Subject: [PATCH 00/06] ARM: Initial SuperH Mobile ARM support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM: Initial SuperH Mobile ARM support

[PATCH 01/06] ARM: SuperH Mobile ARM, sh7367 and G3EVM support
[PATCH 02/06] ARM: Add sh7377 and G4EVM support
[PATCH 03/06] ARM: Add sh7372 and AP4EVB support
[PATCH 04/06] sh: Build drivers/sh for SuperH Mobile ARM
[PATCH 05/06] sh: Let INTC set IRQF_VALID on ARM platforms
[PATCH 06/06] sh-sci: Preliminary SuperH Mobile ARM support

Here comes a set of SuperH Mobile ARM patches. Nothing ground
breaking really, just the bare minimum to get a kernel up and
running with serial and timer on G3EVM, G4EVM and AP4EVB.

Features:
 - Console: Serial console using drivers/serial/sh-sci.c
 - Timer: Early platform driver using drivers/clocksource/sh_cmt.c
 - Interrupts: Minimal INTC support using drivers/sh/intc.c
 - Clocks: Dummy static implementation to enable above drivers
 - Defconfigs: Omitted for now to simplify review

On top of this there will be a bunch of feature patches for
the interrupt controller, gpio, clock framework, runtime pm
and of course driver support.

I intend to throw this into a git repository at some point,
but I may have to rework these patches a bit first depending
on feedback.

Please let me know if there is anything you want me to rework
and perhaps if you have some shared ARM code that you want me
to spend time on. Thanks!

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/Kconfig                                  |    7 
 arch/arm/Makefile                                 |    1 
 arch/arm/mach-shmobile/Kconfig                    |   81 ++++++
 arch/arm/mach-shmobile/Makefile                   |   16 +
 arch/arm/mach-shmobile/Makefile.boot              |    9 
 arch/arm/mach-shmobile/board-ap4evb.c             |  127 ++++++++++
 arch/arm/mach-shmobile/board-g3evm.c              |  127 ++++++++++
 arch/arm/mach-shmobile/board-g4evm.c              |  127 ++++++++++
 arch/arm/mach-shmobile/clock-sh7367.c             |   89 +++++++
 arch/arm/mach-shmobile/include/mach/clkdev.h      |    7 
 arch/arm/mach-shmobile/include/mach/common.h      |   19 +
 arch/arm/mach-shmobile/include/mach/dma.h         |    1 
 arch/arm/mach-shmobile/include/mach/entry-macro.S |   39 +++
 arch/arm/mach-shmobile/include/mach/gpio.h        |    1 
 arch/arm/mach-shmobile/include/mach/hardware.h    |    7 
 arch/arm/mach-shmobile/include/mach/io.h          |    9 
 arch/arm/mach-shmobile/include/mach/irqs.h        |   10 
 arch/arm/mach-shmobile/include/mach/memory.h      |    7 
 arch/arm/mach-shmobile/include/mach/system.h      |   14 +
 arch/arm/mach-shmobile/include/mach/timex.h       |    6 
 arch/arm/mach-shmobile/include/mach/uncompress.h  |   21 +
 arch/arm/mach-shmobile/include/mach/vmalloc.h     |    6 
 arch/arm/mach-shmobile/setup-sh7367.c             |  241 +++++++++++++++++++
 arch/arm/mach-shmobile/setup-sh7372.c             |  241 +++++++++++++++++++
 arch/arm/mach-shmobile/setup-sh7377.c             |  260 +++++++++++++++++++++
 arch/arm/mach-shmobile/timer.c                    |   46 +++
 arch/arm/tools/mach-types                         |    1 
 drivers/Makefile                                  |    1 
 drivers/serial/Kconfig                            |    2 
 drivers/serial/sh-sci.h                           |   23 +
 drivers/sh/intc.c                                 |    5 
 31 files changed, 1545 insertions(+), 6 deletions(-)
