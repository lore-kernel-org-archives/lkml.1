Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbZCXRs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbZCXRs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZCXRsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:48:21 -0400
Received: from gw.goop.org ([64.81.55.164]:49516 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbZCXRsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:48:20 -0400
Message-ID: <49C91B17.9050105@goop.org>
Date: Tue, 24 Mar 2009 10:40:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: [GIT PULL] xen.git 2.6.30: xen dom0 core support
References: <49C915A3.3020809@goop.org>
In-Reply-To: <49C915A3.3020809@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 627b11ca44b334e201c35bf1a1582dc10efaf4a8:
  Jeremy Fitzhardinge (1):
        xen/mmu: weaken flush_tlb_other test

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push2/xen/dom0/core

Christophe Saout (1):
      paravirtualize IO permission bitmap

Ian Campbell (4):
      xen: disable PAT
      xen/dom0: Use host E820 map
      xen: implement XENMEM_machphys_mapping
      xen: clear reserved bits in l3 entries given in the initial pagetables

Jeremy Fitzhardinge (6):
      xen dom0: Make hvc_xen console work for dom0.
      xen/dom0: use _PAGE_IOMAP in ioremap to do machine mappings
      xen: allow enable use of VGA console on dom0
      xen/dom0: add XEN_DOM0 config option
      x86: make /dev/mem mappings _PAGE_IOMAP
      x86: don't need "changed" parameter for set_io_bitmap()

Juan Quintela (2):
      xen dom0: Initialize xenbus for dom0.
      xen dom0: Set up basic IO permissions for dom0.

Stephen Tweedie (2):
      xen dom0: Add support for the platform_ops hypercall
      xen mtrr: Add mtrr_ops support for Xen mtrr

 arch/x86/include/asm/paravirt.h         |    9 ++
 arch/x86/include/asm/pat.h              |    5 +
 arch/x86/include/asm/processor.h        |    4 +
 arch/x86/include/asm/xen/hypercall.h    |    8 +
 arch/x86/include/asm/xen/interface.h    |    6 +-
 arch/x86/include/asm/xen/interface_32.h |    5 +
 arch/x86/include/asm/xen/interface_64.h |   13 +--
 arch/x86/include/asm/xen/page.h         |   15 +--
 arch/x86/kernel/cpu/mtrr/Makefile       |    1 +
 arch/x86/kernel/cpu/mtrr/amd.c          |    1 +
 arch/x86/kernel/cpu/mtrr/centaur.c      |    1 +
 arch/x86/kernel/cpu/mtrr/cyrix.c        |    1 +
 arch/x86/kernel/cpu/mtrr/generic.c      |    1 +
 arch/x86/kernel/cpu/mtrr/main.c         |   11 +-
 arch/x86/kernel/cpu/mtrr/mtrr.h         |    5 +
 arch/x86/kernel/cpu/mtrr/xen.c          |   59 ++++++++
 arch/x86/kernel/ioport.c                |   29 +++-
 arch/x86/kernel/paravirt.c              |    1 +
 arch/x86/kernel/process.c               |   27 +---
 arch/x86/mm/pat.c                       |    7 +-
 arch/x86/xen/Kconfig                    |   26 ++++
 arch/x86/xen/Makefile                   |    3 +-
 arch/x86/xen/enlighten.c                |   51 ++++++-
 arch/x86/xen/mmu.c                      |  123 ++++++++++++++++-
 arch/x86/xen/setup.c                    |   51 ++++++-
 arch/x86/xen/vga.c                      |   67 +++++++++
 arch/x86/xen/xen-ops.h                  |   12 ++
 drivers/char/hvc_xen.c                  |  101 +++++++++-----
 drivers/xen/events.c                    |    2 +-
 drivers/xen/xenbus/xenbus_probe.c       |   30 ++++-
 include/xen/events.h                    |    2 +
 include/xen/interface/memory.h          |   42 ++++++
 include/xen/interface/platform.h        |  232 +++++++++++++++++++++++++++++++
 include/xen/interface/xen.h             |   41 ++++++
 34 files changed, 885 insertions(+), 107 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mtrr/xen.c
 create mode 100644 arch/x86/xen/vga.c
 create mode 100644 include/xen/interface/platform.h


