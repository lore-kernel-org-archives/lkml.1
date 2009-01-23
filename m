Return-Path: <linux-kernel-owner+w=401wt.eu-S1759196AbZAWK7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196AbZAWK7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZAWK7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:59:24 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:5663 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZAWK7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:59:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=iQf1JaD/HcC8i6oUi+2U3mu7tXNNRhhDXD9jA7RItVuuvLfnAbOZBu0HfOrIXPJc44
         MgE5Tmg71IoFEd31xDvinS28D1+J28hAkdT/os8u1YVjfUgF2EFAnbRazyxcjk9NhNWV
         tng0m2ygK+nNAJpx1GNASgv6jQQ5rzex3cq5E=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, lethal@linux-sh.org, johnstul@us.ibm.com,
       gregkh@suse.de, roel.kluin@gmail.com, mingo@redhat.com,
       Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de
Date: Fri, 23 Jan 2009 19:57:21 +0900
Message-Id: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
Subject: [PATCH 000/011] early platform patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early platform patches

[PATCH 001/011] early platform driver V3
[PATCH 002/011] sh: add plat_early_device_setup() function
[PATCH 003/011] sh: plat_early_device_setup() for sh2
[PATCH 004/011] sh: plat_early_device_setup() for sh2a
[PATCH 005/011] sh: plat_early_device_setup() for sh3
[PATCH 006/011] sh: plat_early_device_setup() for sh4
[PATCH 007/011] sh: plat_early_device_setup() for sh4a
[PATCH 008/011] sh: add early platform support for earlyprintk
[PATCH 009/011] sh-sci: add early platform support
[PATCH 010/011] sh: add early platform support for earlytimer
[PATCH 011/011] sh_cmt: add early platform support

These patches add early platform driver support to the serial port
driver and the CMT timer driver on the SuperH architecture.

The following patch sets posted to linuxsh-dev are required:

- [PATCH 000/013] sh-sci: platform device, clock and console changes
- [PATCH 00/05] sh: timer patches

The early platform driver V3 patch is a replacement for V2 in -mm.

Thanks for the feedback so far, more is always welcome. =)

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Documentation/driver-model/platform.txt |   59 +++++++
 arch/sh/Kconfig.debug                   |   27 ---
 arch/sh/include/asm/device.h            |    2 
 arch/sh/kernel/cpu/sh2/setup-sh7619.c   |    5 
 arch/sh/kernel/cpu/sh2a/setup-mxg.c     |    5 
 arch/sh/kernel/cpu/sh2a/setup-sh7201.c  |    5 
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c  |    5 
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c  |    5 
 arch/sh/kernel/cpu/sh3/setup-sh7705.c   |    5 
 arch/sh/kernel/cpu/sh3/setup-sh770x.c   |    5 
 arch/sh/kernel/cpu/sh3/setup-sh7710.c   |    5 
 arch/sh/kernel/cpu/sh3/setup-sh7720.c   |    5 
 arch/sh/kernel/cpu/sh4/setup-sh4-202.c  |    5 
 arch/sh/kernel/cpu/sh4/setup-sh7750.c   |    5 
 arch/sh/kernel/cpu/sh4/setup-sh7760.c   |    5 
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c  |    5 
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c  |    5 
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c  |    5 
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c  |    5 
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c  |    5 
 arch/sh/kernel/cpu/sh4a/setup-sh7770.c  |    5 
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c  |    5 
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c  |    5 
 arch/sh/kernel/cpu/sh4a/setup-shx3.c    |    5 
 arch/sh/kernel/early_printk.c           |  142 ------------------
 arch/sh/kernel/setup.c                  |   10 +
 arch/sh/kernel/time_32.c                |   11 +
 drivers/base/platform.c                 |  239 +++++++++++++++++++++++++++++++
 drivers/clocksource/sh_cmt.c            |   18 ++
 drivers/serial/sh-sci.c                 |   49 +++++-
 include/linux/init.h                    |    1 
 include/linux/platform_device.h         |   42 +++++
 init/main.c                             |    7 
 33 files changed, 533 insertions(+), 179 deletions(-)
