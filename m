Return-Path: <linux-kernel-owner+w=401wt.eu-S934312AbYBHJ50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312AbYBHJ50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 04:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760351AbYBHJ5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 04:57:11 -0500
Received: from ozlabs.org ([203.10.76.45]:33350 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760270AbYBHJ5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 04:57:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18348.10091.120122.608010@cargo.ozlabs.ibm.com>
Date: Fri, 8 Feb 2008 20:56:59 +1100
From: Paul Mackerras <paulus@samba.org>
To: torvalds@linux-foundation.org
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Please pull powerpc.git for-2.6.25 branch
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please do

git pull \
git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git for-2.6.25

to get some bug-fixes for powerpc (1 for powermac and 8 for Cell),
plus 3 commits from Badari Pulavarty that implement memory hot-remove
for 64-bit powerpc.  These 3 commits have been signed-off by Andrew
Morton.  One of them touches generic code (kernel/resource.c), and it
has been acked by KAMEZAWA Hiroyuki.

Thanks,
Paul.

 arch/powerpc/Kconfig                            |    6 +++
 arch/powerpc/mm/mem.c                           |   33 +++++++++++++++
 arch/powerpc/platforms/cell/iommu.c             |   48 +++++++++++++----------
 arch/powerpc/platforms/cell/spufs/backing_ops.c |    6 +++
 arch/powerpc/platforms/cell/spufs/fault.c       |   12 ++----
 arch/powerpc/platforms/cell/spufs/file.c        |   49 ++++++++++++++---------
 arch/powerpc/platforms/cell/spufs/run.c         |   21 ++++++----
 arch/powerpc/platforms/cell/spufs/spufs.h       |    5 ++
 arch/powerpc/platforms/powermac/feature.c       |   11 +++++
 drivers/macintosh/smu.c                         |   25 +++++++++++-
 include/asm-powerpc/pmac_feature.h              |    8 ++++
 kernel/resource.c                               |    2 -
 12 files changed, 166 insertions(+), 60 deletions(-)

Badari Pulavarty (3):
      [POWERPC] Add remove_memory() for 64-bit powerpc
      [POWERPC] Enable hotplug memory remove for 64-bit powerpc
      [POWERPC] Add arch-specific walk_memory_remove() for 64-bit powerpc

Benjamin Herrenschmidt (1):
      [POWERPC] Disable G5 NAP mode during SMU commands on U3

Christoph Hellwig (1):
      [POWERPC] spufs: Fix state_mutex leaks

Luke Browning (2):
      [POWERPC] spufs: No need to have a runnable SPU for libassist update
      [POWERPC] spufs: Fix timing dependent false return from spufs_run_spu

Masato Noguchi (1):
      [POWERPC] spufs: Update SPU_Status[CISHP] in backing runcntl write

Michael Ellerman (4):
      [POWERPC] Fix cell IOMMU null pointer explosion on old firmwares
      [POWERPC] Don't enable cell IOMMU fixed mapping if there are no dma-ranges
      [POWERPC] Fix potential cell IOMMU bug when switching back to default DMA ops
      [POWERPC] Make cell IOMMU fixed mapping printk more useful

