Return-Path: <linux-kernel-owner+w=401wt.eu-S1763597AbXKPSpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763597AbXKPSpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXKPSpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:45:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35634 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbXKPSpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:45:30 -0500
Date: Fri, 16 Nov 2007 10:44:30 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.3
Message-ID: <20071116184430.GE9807@kroah.com>
References: <20071116183752.GA9807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116183752.GA9807@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.3 kernel.
It contains a number of bugfixes for a number of architecture specific
issues.

I'll also be replying to this message with a copy of the patch between
2.6.23.2 and 2.6.23.3

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                               |    2 -
 arch/i386/boot/boot.h                  |    8 ++--
 arch/i386/boot/header.S                |   62 +++++++++++++++++++++++----------
 arch/i386/boot/video-bios.c            |    2 -
 arch/i386/boot/video-vesa.c            |    2 -
 arch/i386/boot/video.c                 |    2 -
 arch/i386/kernel/tsc.c                 |    5 +-
 arch/i386/xen/enlighten.c              |   57 ++++++++++++++++++++----------
 arch/i386/xen/mmu.c                    |   29 +++++++++++++--
 arch/i386/xen/multicalls.c             |   29 +++++++++++++--
 arch/i386/xen/multicalls.h             |    3 +
 arch/i386/xen/xen-ops.h                |    1 
 arch/mips/mm/c-r4k.c                   |   21 +++++++++--
 arch/powerpc/math-emu/math.c           |   13 ++++--
 arch/powerpc/platforms/cell/axon_msi.c |    4 +-
 arch/sparc64/kernel/sys_sparc.c        |    2 -
 arch/sparc64/lib/xor.S                 |   12 +++---
 arch/um/Makefile                       |    3 +
 arch/um/include/common-offsets.h       |    1 
 arch/um/include/sysdep-i386/stub.h     |    3 -
 arch/um/kernel/skas/clone.c            |    1 
 arch/um/os-Linux/main.c                |    1 
 arch/um/os-Linux/skas/mem.c            |    1 
 arch/um/os-Linux/skas/process.c        |    2 -
 arch/um/os-Linux/start_up.c            |    1 
 arch/um/os-Linux/tt.c                  |    1 
 arch/um/os-Linux/util.c                |   38 ++++++++++++++++++++
 arch/um/sys-i386/user-offsets.c        |    6 +--
 arch/um/sys-x86_64/user-offsets.c      |    9 ----
 arch/x86_64/mm/init.c                  |    6 ---
 arch/x86_64/mm/pageattr.c              |    9 +++-
 fs/xfs/linux-2.6/xfs_buf.c             |   13 ++++++
 include/asm-mips/hazards.h             |   54 ++++++++++++++++++++++++++++
 include/linux/bootmem.h                |    1 
 include/xen/interface/vcpu.h           |    5 +-
 mm/sparse.c                            |   11 -----
 36 files changed, 308 insertions(+), 112 deletions(-)

Summary of changes from v2.6.23.2 to v2.6.23.3
==============================================

Chris Wright (1):
      Fix sparc64 MAP_FIXED handling of framebuffer mmaps

Dave Johnson (1):
      x86: fix TSC clock source calibration error

David Miller (1):
      Fix sparc64 niagara optimized RAID xor asm

Greg Kroah-Hartman (1):
      Linux 2.6.23.3

H. Peter Anvin (2):
      x86 setup: handle boot loaders which set up the stack incorrectly
      x86 setup: sizeof() is unsigned, unbreak comparisons

Ingo Molnar (1):
      x86: fix global_flush_tlb() bug

Jeff Dike (3):
      UML - Stop using libc asm/page.h
      UML - Fix kernel vs libc symbols clash
      UML - stop using libc asm/user.h

Jeremy Fitzhardinge (4):
      xen: add batch completion callbacks
      xen: deal with stale cr3 values when unpinning pagetables
      xen: fix incorrect vcpu_register_vcpu_info hypercall argument
      xfs: eagerly remove vmap mappings to avoid upsetting Xen

Kumar Gala (1):
      POWERPC: Fix handling of stfiwx math emulation

Lepton Wu (1):
      UML - kill subprocesses on exit

Linus Torvalds (1):
      revert "x86_64: allocate sparsemem memmap above 4G"

Michael Ellerman (1):
      POWERPC: Make sure to of_node_get() the result of pci_device_to_OF_node()

Ralf Baechle (2):
      MIPS: MT: Fix bug in multithreaded kernels.
      MIPS: R1: Fix hazard barriers to make kernels work on R2 also.

