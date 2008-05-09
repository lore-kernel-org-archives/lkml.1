Return-Path: <linux-kernel-owner+w=401wt.eu-S1762976AbYEINTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762976AbYEINTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 09:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYEINTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 09:19:14 -0400
Received: from ozlabs.org ([203.10.76.45]:42462 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbYEINTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 09:19:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18468.20300.743426.133081@cargo.ozlabs.ibm.com>
Date: Fri, 9 May 2008 23:19:08 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get some bug fixes and documentation/comment updates for powerpc,
as listed below.

There is one commit there that isn't just a fix, the "Add endpoint
support to 4xx PCIe driver" one.  I think it's OK to go in because (a)
it's only adding functionality, (b) it only affects ppc4xx processors,
and (c) the 4xx maintainer (Josh Boyer) said about it: "Stefan's pci-e
endpoint driver is also included here as it is a fairly contained
change with Ben's Ack.  It should have been included in my last pull
request, but I missed it and have been out."

Thanks,
Paul.

 arch/powerpc/boot/dts/sequoia.dts            |    9 +
 arch/powerpc/kernel/btext.c                  |    1 
 arch/powerpc/kernel/cputable.c               |   53 ++++++--
 arch/powerpc/kernel/head_44x.S               |    9 +
 arch/powerpc/kernel/head_64.S                |    4 -
 arch/powerpc/kernel/isa-bridge.c             |    3 
 arch/powerpc/kernel/setup_64.c               |   10 +
 arch/powerpc/platforms/cell/interrupt.c      |   53 +++++++-
 arch/powerpc/platforms/cell/spu_base.c       |   31 +++-
 arch/powerpc/platforms/cell/spu_priv1_mmio.c |   16 ++
 arch/powerpc/platforms/cell/spufs/fault.c    |   17 ++
 arch/powerpc/platforms/cell/spufs/inode.c    |   10 +
 arch/powerpc/platforms/cell/spufs/run.c      |   38 +++--
 arch/powerpc/platforms/cell/spufs/sched.c    |    7 +
 arch/powerpc/platforms/cell/spufs/spufs.h    |    3 
 arch/powerpc/platforms/cell/spufs/switch.c   |   71 +++++++---
 arch/powerpc/sysdev/ppc4xx_pci.c             |  180 +++++++++++++++++++-------
 arch/powerpc/xmon/xmon.c                     |    6 +
 include/asm-powerpc/pgtable-ppc32.h          |    7 +
 include/asm-powerpc/spu.h                    |    9 +
 include/asm-powerpc/spu_csa.h                |    3 
 include/linux/of_i2c.h                       |    4 -
 22 files changed, 399 insertions(+), 145 deletions(-)

Benjamin Herrenschmidt (4):
      [POWERPC] Make default cputable entries reflect selected CPU family
      [POWERPC] Fix bogus paca->_current initialization
      [POWERPC] Document when printk is useable
      [POWERPC] Initialize lockdep earlier

Christian Ehrhardt (1):
      [POWERPC] 4xx: Fix PCI mem in sequoia DTS

Christoph Hellwig (3):
      [POWERPC] spufs: spu_create should send inotify IM_CREATE event
      [POWERPC] spufs: don't requeue victim contex in find_victim if it's not in spu_run
      [POWERPC] spufs: lockdep annotations for spufs_dir_close

Huang Weiyi (1):
      [POWERPC] Remove duplicate #include

Jeremy Kerr (6):
      [POWERPC] cell: Fix lost interrupts due to fasteoi handler
      [POWERPC] spufs: don't touch suspend bits when purging DMA queue
      [POWERPC] spufs: fix save of mfc_cntl register
      [POWERPC] spufs: fix post-stopped update of MFC_CNTL register
      [POWERPC] spufs: update master runcntl with context lock held
      [POWERPC] spufs: don't acquire state_mutex interruptible while performing callback

Jochen Friedrich (1):
      [POWERPC] Fix of_i2c include for module compilation

Luke Browning (4):
      [POWERPC] spufs: set SPU_CONTEXT_SWITCH_PENDING before synchronising SPU irqs
      [POWERPC] spufs: try to route SPU interrupts to local node
      [POWERPC] spufs: fix concurrent delivery of class 0 & 1 exceptions
      [POWERPC] spufs: handle faults while the context switch pending flag is set

Nate Case (1):
      [POWERPC] Remove leftover printk in isa-bridge.c

Stefan Roese (2):
      [POWERPC] 4xx: Fix problem with new TLB storage attibute fields on 440x6 core
      [POWERPC] 4xx: Add endpoint support to 4xx PCIe driver

