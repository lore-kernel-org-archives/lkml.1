Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbZCXRmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbZCXRmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZCXRmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:42:07 -0400
Received: from gw.goop.org ([64.81.55.164]:38980 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbZCXRmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:42:04 -0400
Message-ID: <49C91B6A.1090504@goop.org>
Date: Tue, 24 Mar 2009 10:42:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: [GIT PULL] xen.git 2.6.30: xen dom0 apic changes
References: <49C915A3.3020809@goop.org>
In-Reply-To: <49C915A3.3020809@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6b36d6251e178636a3c032611948a5c7af44582e:
  Jeremy Fitzhardinge (1):
        x86: don't need "changed" parameter for set_io_bitmap()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push2/xen/dom0/apic

Gerd Hoffmann (2):
      xen: set pirq name to something useful.
      xen: fix legacy irq setup, make ioapic-less machines work.

Ian Campbell (1):
      xen: pre-initialize legacy irqs early

Jeremy Fitzhardinge (13):
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
 drivers/xen/events.c           |  273 ++++++++++++++++++++++++++++++++++++++--
 include/linux/pci.h            |    6 +
 include/xen/events.h           |   22 ++++
 15 files changed, 541 insertions(+), 15 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/pci.h
 create mode 100644 arch/x86/xen/apic.c
 create mode 100644 arch/x86/xen/pci.c


