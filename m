Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbZCMQnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbZCMQnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758757AbZCMQmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:42:47 -0400
Received: from gw.goop.org ([64.81.55.164]:57233 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752447AbZCMQmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:42:47 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] Xen dom0 apic changes
Date: Fri, 13 Mar 2009 09:42:21 -0700
Message-Id: <1236962558-13748-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series implements the hooks into the x86 platform apic code that
Xen dom0 support requires.  This is a tidied-up repost of the series
posted a couple of weeks ago, with only a few small changes.

Thanks,
	J

The following changes since commit 089faa06184f85284ba6c4164dd7b4741ca5d5c5:
  Jeremy Fitzhardinge (1):
        x86: don't need "changed" parameter for set_io_bitmap()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push/xen/dom0/apic

Gerd Hoffmann (2):
      xen: set pirq name to something useful.
      xen: fix legacy irq setup, make ioapic-less machines work.

Ian Campbell (1):
      xen: pre-initialize legacy irqs early

Jeremy Fitzhardinge (14):
      xen/dom0: handle acpi lapic parsing in Xen dom0
      xen: hook io_apic read/write operations
      xen: create dummy ioapic mapping
      xen: implement pirq type event channels
      x86/io_apic: add get_nr_irqs_gsi()
      xen/apic: identity map gsi->irqs
      xen: direct irq registration to pirq event channels
      xen: bind pirq to vector and event channel
      xen/apic: program the apic triggering and polarity properly
      xen: don't setup acpi interrupt unless there is one
      xen: use acpi_get_override_irq() to get triggering for legacy irqs
      xen: initialize irq 0 too
      xen: dynamically allocate irq & event structures
      xen: disable MSI

 arch/x86/include/asm/io_apic.h |    7 +
 arch/x86/include/asm/xen/pci.h |   13 ++
 arch/x86/kernel/acpi/boot.c    |   18 +++-
 arch/x86/kernel/apic/io_apic.c |   37 +++++-
 arch/x86/xen/Kconfig           |   11 ++
 arch/x86/xen/Makefile          |    3 +-
 arch/x86/xen/apic.c            |   60 +++++++++
 arch/x86/xen/enlighten.c       |    2 +
 arch/x86/xen/mmu.c             |   10 ++
 arch/x86/xen/pci.c             |   85 +++++++++++++
 arch/x86/xen/xen-ops.h         |    6 +
 drivers/pci/pci.h              |    2 -
 drivers/xen/events.c           |  273 ++++++++++++++++++++++++++++++++++++++--
 include/linux/pci.h            |    6 +
 include/xen/events.h           |   22 ++++
 15 files changed, 540 insertions(+), 15 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/pci.h
 create mode 100644 arch/x86/xen/apic.c
 create mode 100644 arch/x86/xen/pci.c

