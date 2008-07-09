Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbYGILyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbYGILyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756304AbYGILyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:54:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:38546 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbYGILyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:54:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=JGJwbgaCA4o64YfqbW+iJTfsIldfzHZjXdO2C2+fsk0crF6Pp+UpQyaUPiZFzd4O0d
         9hS3ldzDJmBA0eLNZ5PeRYLq/Id44F0XsOcnIi2+TNzxNVGhcp+yglowmbTkIZSeIMfX
         M5N8L1DH1Eoh8c2P1V9q8SiS3IUBqkiK++7gs=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, gregkh@suse.de,
       akpm@linux-foundation.org
Date: Wed, 09 Jul 2008 20:54:28 +0900
Message-Id: <20080709115428.14144.7121.sendpatchset@rx1.opensource.se>
Subject: [PATCH 00/04] resource: type and size patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Here comes a few struct resource changes. I propose the following:

1. add a resource_size() function to avoid one-off calculation errors.
2. make space for more resource types and add resource_type().
3. add IORESOURCE_CLK so we can pass clocks to platform drivers.

[PATCH 01/04] resource: add resource_size()
[PATCH 02/04] resource: add resource_type() and IORESOURCE_TYPE_BITS
[PATCH 03/04] resource: use new resource type changes
[PATCH 04/04] resource: add new IORESOURCE_CLK type

This is not tested, so I'm surprised if this even builds. I have time
to fix this up if people agree with this change.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Applies on current linux-2.6, so this will need up-porting.
 [PATCH 03/04] needs to be extended and split up as well.

 arch/alpha/kernel/pci.c                    |   21 ++++++------
 arch/arm/kernel/bios32.c                   |   16 ++++-----
 arch/arm/mach-iop13xx/pci.c                |    6 +--
 arch/arm/mm/iomap.c                        |    5 +-
 arch/arm/plat-s3c24xx/pm.c                 |    2 -
 arch/cris/arch-v32/drivers/pci/bios.c      |    6 +--
 arch/frv/mb93090-mb00/pci-frv.c            |   10 ++---
 arch/frv/mb93090-mb00/pci-iomap.c          |    3 +
 arch/ia64/pci/pci.c                        |    7 ++--
 arch/ia64/sn/kernel/io_init.c              |    2 -
 arch/m68k/kernel/bios32.c                  |    6 +--
 arch/mips/basler/excite/excite_device.c    |   12 +------
 arch/mips/lib/iomap-pci.c                  |    5 +-
 arch/mips/pci/pci.c                        |   24 +++++++-------
 arch/mips/pmc-sierra/yosemite/ht.c         |    6 +--
 arch/mn10300/unit-asb2305/pci-asb2305.c    |    8 ++--
 arch/mn10300/unit-asb2305/pci-iomap.c      |    3 +
 arch/parisc/kernel/pci.c                   |   15 ++++----
 arch/parisc/lib/iomap.c                    |    5 +-
 arch/powerpc/kernel/iomap.c                |    5 +-
 arch/powerpc/kernel/legacy_serial.c        |    2 -
 arch/powerpc/kernel/pci-common.c           |   31 ++++++++----------
 arch/powerpc/kernel/pci_64.c               |    2 -
 arch/powerpc/kernel/prom_parse.c           |    4 +-
 arch/powerpc/platforms/fsl_uli1575.c       |    2 -
 arch/powerpc/platforms/maple/setup.c       |    2 -
 arch/powerpc/platforms/maple/time.c        |    2 -
 arch/powerpc/platforms/pseries/eeh_cache.c |    5 +-
 arch/powerpc/platforms/pseries/pci.c       |    4 +-
 arch/powerpc/sysdev/fsl_pci.c              |    4 +-
 arch/powerpc/sysdev/ppc4xx_pci.c           |    8 ++--
 arch/ppc/kernel/pci.c                      |   48 +++++++++++++---------------
 arch/ppc/syslib/ppc405_pci.c               |    2 -
 arch/ppc/syslib/ppc_sys.c                  |    2 -
 arch/sh/drivers/pci/pci.c                  |   11 +++---
 arch/sh/kernel/io_trapped.c                |   10 ++++-
 arch/sparc/kernel/of_device.c              |    1 
 arch/sparc/kernel/pcic.c                   |   12 +++----
 arch/sparc/lib/iomap.c                     |    5 +-
 arch/sparc64/kernel/of_device.c            |    5 +-
 arch/sparc64/kernel/pci.c                  |   21 ++++++------
 arch/sparc64/lib/iomap.c                   |    5 +-
 arch/v850/kernel/rte_mb_a_pci.c            |    8 ++--
 arch/x86/kernel/pci-calgary_64.c           |    2 -
 arch/x86/pci/i386.c                        |    4 +-
 arch/x86/pci/k8-bus_64.c                   |    5 +-
 arch/xtensa/kernel/pci.c                   |   12 +++----
 drivers/base/platform.c                    |   31 +++++++++---------
 drivers/pnp/manager.c                      |    5 --
 include/linux/ioport.h                     |   16 +++++++--
 kernel/resource.c                          |    2 -
 51 files changed, 232 insertions(+), 208 deletions(-)
