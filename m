Return-Path: <linux-kernel-owner+w=401wt.eu-S1760404AbZEHAL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbZEHAL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbZEHAJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:09:56 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52690
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753492AbZEHAJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:53 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] xen: apic support for dom0
Date: Thu,  7 May 2009 14:14:25 -0700
Message-Id: <1241730883-4917-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This branch implements the Xen dom0 hooks into the x86 apic subsystem.
These changes are needed so that hardware interrupts are delivered as
Xen events via event channels, while allowing the dom0 kernel to control
interrupt routing by programming the IO APICs.

This code is essentially unchanged from the last time I posted it.

The following changes since commit 0c96e43850feb7c7c4a4950f24533491fbd63b5a:
  Jeremy Fitzhardinge (1):
        xen: checkpatch cleanups

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen-tip/dom0/apic

Gerd Hoffmann (2):
      xen: set pirq name to something useful.
      xen: fix legacy irq setup, make ioapic-less machines work.

Ian Campbell (1):
      xen: pre-initialize legacy irqs early

Jeremy Fitzhardinge (15):
      xen/dom0: handle acpi lapic parsing in Xen dom0
      xen: hook io_apic read/write operations
      xen: create dummy ioapic mapping
      xen: implement pirq type event channels
      x86/io_apic: add get_nr_irqs_gsi()
      xen/apic: identity map gsi->irqs
      xen: direct irq registration to pirq event channels
      xen: bind pirq to vector and event channel
      xen: don't setup acpi interrupt unless there is one
      xen: use acpi_get_override_irq() to get triggering for legacy irqs
      xen: initialize irq 0 too
      xen: dynamically allocate irq & event structures
      xen: disable MSI
      xen/apic: checkpatch cleanups
      xen/apic: add pin argument to setup_ioapic_entry()

 arch/x86/include/asm/io_apic.h |    7 +
 arch/x86/include/asm/xen/pci.h |   13 ++
 arch/x86/kernel/acpi/boot.c    |   18 +++-
 arch/x86/kernel/apic/io_apic.c |   37 +++++-
 arch/x86/xen/Kconfig           |   11 ++
 arch/x86/xen/Makefile          |    3 +-
 arch/x86/xen/apic.c            |   60 +++++++++
 arch/x86/xen/enlighten.c       |    2 +
 arch/x86/xen/mmu.c             |   10 ++
 arch/x86/xen/pci.c             |   86 +++++++++++++
 arch/x86/xen/xen-ops.h         |    6 +
 drivers/pci/pci.h              |    2 -
 drivers/xen/events.c           |  274 ++++++++++++++++++++++++++++++++++++++--
 include/linux/pci.h            |    6 +
 include/xen/events.h           |   19 +++
 15 files changed, 539 insertions(+), 15 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/pci.h
 create mode 100644 arch/x86/xen/apic.c
 create mode 100644 arch/x86/xen/pci.c

Thanks,
	J
