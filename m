Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbZEMAhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbZEMAhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758352AbZEMAfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:35:50 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:58532
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753013AbZEMAft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:35:49 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] xen dom0 core changes
Date: Tue, 12 May 2009 14:28:22 -0700
Message-Id: <1242163718-2934-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's a repost of the Xen dom0 core changes.  I did some minor
reformatting of the commit messages and checkpatch cleanups (including
those MTRR comments).

If this looks OK, could you pull it into a x86/xen/dom0 topic branch?

Thanks,
	J

The following changes since commit a789ed5fb6d0256c4177c2cc27e06520ddbe4d4c:
  Jeremy Fitzhardinge (1):
        xen: cache cr0 value to avoid trap'n'emulate for read_cr0

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-ingo/xen/dom0/core

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
      xen/i386: make sure initial VGA/ISA mappings are not overridden

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
 arch/x86/mm/pat.c                       |    9 +-
 arch/x86/xen/Kconfig                    |   26 ++++
 arch/x86/xen/Makefile                   |    3 +-
 arch/x86/xen/enlighten.c                |   51 +++++++-
 arch/x86/xen/mmu.c                      |  134 ++++++++++++++++++-
 arch/x86/xen/setup.c                    |   51 +++++++-
 arch/x86/xen/vga.c                      |   67 +++++++++
 arch/x86/xen/xen-ops.h                  |   12 ++
 drivers/char/hvc_xen.c                  |   99 +++++++++-----
 drivers/xen/events.c                    |    2 +-
 drivers/xen/xenbus/xenbus_probe.c       |   30 ++++-
 include/xen/events.h                    |    2 +
 include/xen/interface/memory.h          |   42 ++++++
 include/xen/interface/platform.h        |  222 +++++++++++++++++++++++++++++++
 include/xen/interface/xen.h             |   41 ++++++
 34 files changed, 882 insertions(+), 108 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mtrr/xen.c
 create mode 100644 arch/x86/xen/vga.c
 create mode 100644 include/xen/interface/platform.h

