Return-Path: <linux-kernel-owner+w=401wt.eu-S1762799AbZEHA11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762799AbZEHA11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758842AbZEHAKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:41 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52728
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757202AbZEHAKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:10:06 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] xen: core dom0 support
Date: Thu,  7 May 2009 14:10:37 -0700
Message-Id: <1241730653-4688-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This branch has the basics of Xen dom0 support.  It is not sufficient
to get a booting system (it implements no access to physical devices),
but it is enough to at least get the kernel to start and print some
console messages.

This is essentially unchanged from the last time I posted it.

The following changes since commit e7c064889606aab3569669078c69b87b2c527e72:
  Jeremy Fitzhardinge (1):
        xen: add FIX_TEXT_POKE to fixmap

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen-tip/dom0/core

Christophe Saout (1):
      paravirtualize IO permission bitmap

Ian Campbell (4):
      xen: disable PAT
      xen/dom0: Use host E820 map
      xen: implement XENMEM_machphys_mapping
      xen: clear reserved bits in l3 entries given in the initial pagetables

Jeremy Fitzhardinge (7):
      xen dom0: Make hvc_xen console work for dom0.
      xen/dom0: use _PAGE_IOMAP in ioremap to do machine mappings
      xen: allow enable use of VGA console on dom0
      xen/dom0: add XEN_DOM0 config option
      x86: make /dev/mem mappings _PAGE_IOMAP
      x86: don't need "changed" parameter for set_io_bitmap()
      xen: checkpatch cleanups

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
 arch/x86/kernel/cpu/mtrr/xen.c          |   56 ++++++++
 arch/x86/kernel/ioport.c                |   29 +++-
 arch/x86/kernel/paravirt.c              |    1 +
 arch/x86/kernel/process.c               |   27 +---
 arch/x86/mm/pat.c                       |    7 +-
 arch/x86/xen/Kconfig                    |   26 ++++
 arch/x86/xen/Makefile                   |    3 +-
 arch/x86/xen/enlighten.c                |   51 +++++++-
 arch/x86/xen/mmu.c                      |  123 +++++++++++++++++-
 arch/x86/xen/setup.c                    |   51 +++++++-
 arch/x86/xen/vga.c                      |   68 ++++++++++
 arch/x86/xen/xen-ops.h                  |   12 ++
 drivers/char/hvc_xen.c                  |   99 +++++++++-----
 drivers/xen/events.c                    |    2 +-
 drivers/xen/xenbus/xenbus_probe.c       |   30 ++++-
 include/xen/events.h                    |    2 +
 include/xen/interface/memory.h          |   42 ++++++
 include/xen/interface/platform.h        |  222 +++++++++++++++++++++++++++++++
 include/xen/interface/xen.h             |   41 ++++++
 34 files changed, 873 insertions(+), 105 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mtrr/xen.c
 create mode 100644 arch/x86/xen/vga.c
 create mode 100644 include/xen/interface/platform.h

Thanks,
	J
