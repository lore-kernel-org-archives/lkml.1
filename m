Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZCREOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZCREOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 00:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbZCREOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 00:14:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:55152 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbZCREOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 00:14:15 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 15:11:07 +1100
Message-Id: <1237349467.25062.311.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

So here's the new ps3 nvram driver for 2.6.29 that we discussed earlier
(I actually sent this days ago but screwed up the email by not actually
sending it to you :-)

In the meantime I've added a PS3 defconfig update and two patches fixing
another fallout from the changes to the way we handle the coherent bit
in our PTEs. Hopefully there should be no more regressions in that area.

Cheers,
Ben.

The following changes since commit ee568b25ee9e160b32d1aef73d8b2ee9c05d34db:
  Linus Torvalds (1):
        Avoid 64-bit "switch()" statements on 32-bit architectures

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (1):
      Merge commit 'gcl/merge' into merge

Geert Uytterhoeven (1):
      ps3/block: Replace mtd/ps3vram by block/ps3vram

Geoff Levand (1):
      powerpc/ps3: ps3_defconfig updates

Kumar Gala (1):
      powerpc/mm: Respect _PAGE_COHERENT on classic ppc32 SW

Piotr Ziecik (1):
      powerpc/5200: Enable CPU_FTR_NEED_COHERENT for MPC52xx

 arch/powerpc/configs/ps3_defconfig  |  250 ++++++++---
 arch/powerpc/include/asm/cputable.h |    4 +-
 arch/powerpc/kernel/head_32.S       |    6 +-
 arch/powerpc/platforms/ps3/Kconfig  |    7 +
 drivers/block/Makefile              |    1 +
 drivers/block/ps3vram.c             |  865 +++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/Kconfig         |    7 -
 drivers/mtd/devices/Makefile        |    1 -
 drivers/mtd/devices/ps3vram.c       |  768 -------------------------------
 9 files changed, 1069 insertions(+), 840 deletions(-)
 create mode 100644 drivers/block/ps3vram.c
 delete mode 100644 drivers/mtd/devices/ps3vram.c


