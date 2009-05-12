Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbZELX0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbZELX0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZELXZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:25:26 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36156
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752732AbZELXZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:25:24 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] Xen APIC hooks (with io_apic_ops)
Date: Tue, 12 May 2009 16:25:07 -0700
Message-Id: <1242170724-13349-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's a revised set of the Xen APIC changes which adds io_apic_ops
to allow Xen to intercept IO APIC access operations.

Thanks,
	J

The following changes since commit ce791368bb4a53d05e78e1588bac0aacde8db84c:
  Jeremy Fitzhardinge (1):
        xen/i386: make sure initial VGA/ISA mappings are not overridden

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-ingo/xen/dom0/apic-ops

Gerd Hoffmann (2):
      xen: set pirq name to something useful.
      xen: fix legacy irq setup, make ioapic-less machines work.

Ian Campbell (1):
      xen: pre-initialize legacy irqs early

Jeremy Fitzhardinge (14):
      xen/dom0: handle acpi lapic parsing in Xen dom0
      x86: add io_apic_ops to allow interception
      xen: implement io_apic_ops
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

 arch/x86/include/asm/io_apic.h |   10 ++
 arch/x86/include/asm/xen/pci.h |   13 ++
 arch/x86/kernel/acpi/boot.c    |   18 +++-
 arch/x86/kernel/apic/io_apic.c |   55 ++++++++-
 arch/x86/xen/Kconfig           |   11 ++
 arch/x86/xen/Makefile          |    3 +-
 arch/x86/xen/apic.c            |   69 ++++++++++
 arch/x86/xen/enlighten.c       |    2 +
 arch/x86/xen/mmu.c             |   10 ++
 arch/x86/xen/pci.c             |   86 +++++++++++++
 arch/x86/xen/xen-ops.h         |    6 +
 drivers/pci/pci.h              |    2 -
 drivers/xen/events.c           |  273 ++++++++++++++++++++++++++++++++++++++--
 include/linux/pci.h            |    6 +
 include/xen/events.h           |   19 +++
 15 files changed, 568 insertions(+), 15 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/pci.h
 create mode 100644 arch/x86/xen/apic.c
 create mode 100644 arch/x86/xen/pci.c

