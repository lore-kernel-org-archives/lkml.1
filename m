Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbZCMQb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbZCMQb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbZCMQaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:30:17 -0400
Received: from gw.goop.org ([64.81.55.164]:56733 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750742AbZCMQaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:30:14 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] Xen dom0 core changes
Date: Fri, 13 Mar 2009 09:29:41 -0700
Message-Id: <1236961796-13407-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the set of core changes for Xen dom0 support.  It does not by
itself implement everything needed for dom0 support, but it lays the
groundwork.

This is more or less a repost of the patches posted a few weeks ago,
but rebased to last night's push/xen/master patch posting, and with a
few bugfixes folded into it.

Thanks,
	J

The following changes since commit f33700f25a49f98835158d7f3d086dbf727f08db:
  Alex Nixon (1):
        Xen: Add virt_to_pfn helper function

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push/xen/dom0/core

Christophe Saout (1):
      Preliminary work on paravirtualizing set_io_bitmap.

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

 arch/x86/include/asm/paravirt.h         |    7 +
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
 arch/x86/kernel/ioport.c                |   30 +++-
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
 34 files changed, 883 insertions(+), 108 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mtrr/xen.c
 create mode 100644 arch/x86/xen/vga.c
 create mode 100644 include/xen/interface/platform.h

