Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZCMIM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZCMIM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZCMIMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:09 -0400
Received: from gw.goop.org ([64.81.55.164]:34776 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750897AbZCMIMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:06 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] 2.6.30 Xen core updates
Date: Fri, 13 Mar 2009 01:11:36 -0700
Message-Id: <1236931920-6861-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series updates the kernel's baseline domU Xen functionality.
It's mostly bugfixes, but there are a couple of new Xen-specific drivers.

The series depends on the earlier x86/brk and x86/paravirt patches I
posted a couple of days ago.

Thanks,
	J

The following changes since commit 6b3933081104945c557d8fe678301cc1bdefdcc8:
  Jeremy Fitzhardinge (1):
        Merge branch 'push/x86/brk' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push/xen/master

Alex Nixon (1):
      Xen: Add virt_to_pfn helper function

Hannes Eder (1):
      NULL noise: arch/x86/xen/smp.c

Ian Campbell (6):
      xen: add irq_from_evtchn
      xen: add /dev/xen/evtchn driver
      xen: export ioctl headers to userspace
      xen: drop kexec bits from /sys/hypervisor since kexec isn't implemented yet
      xen: remove suspend_cancel hook
      xen: use device model for suspending xenbus devices

Jeremy Fitzhardinge (18):
      xen: disable preempt for leave_lazy_mmu
      xen: separate p2m allocation from setting
      xen: dynamically allocate p2m tables
      xen: split construction of p2m mfn tables from registration
      xen: clean up xen_load_gdt
      xen: make xen_load_gdt simpler
      xen: remove xen_load_gdt debug
      xen: reserve i386 Xen pagetables
      xen: mask XSAVE from cpuid
      xen: add FIX_TEXT_POKE to fixmap
      x86-64: remove PGE from must-have feature list
      xen/dev-evtchn: clean up locking in evtchn
      xen: add "capabilities" file
      xen: add /sys/hypervisor support
      xen/sys/hypervisor: change writable_pt to features
      xen/xenbus: export xenbus_dev_changed
      Merge branches 'push/xen/dev-evtchn', 'push/xen/xenfs' and 'push/xen/sys-hypervisor' into push/xen/control
      Merge branches 'push/xen/control' and 'push/xen/xenbus' into push/xen/master

 arch/x86/include/asm/required-features.h |    2 +-
 arch/x86/include/asm/xen/page.h          |    3 +-
 arch/x86/xen/enlighten.c                 |   76 ++++-
 arch/x86/xen/mmu.c                       |  116 ++++++--
 arch/x86/xen/mmu.h                       |    3 +
 arch/x86/xen/smp.c                       |    4 +-
 drivers/xen/Kconfig                      |   20 ++
 drivers/xen/Makefile                     |    4 +-
 drivers/xen/events.c                     |    6 +
 drivers/xen/evtchn.c                     |  507 ++++++++++++++++++++++++++++++
 drivers/xen/manage.c                     |    9 +-
 drivers/xen/sys-hypervisor.c             |  445 ++++++++++++++++++++++++++
 drivers/xen/xenbus/xenbus_probe.c        |   61 +---
 drivers/xen/xenbus/xenbus_xs.c           |    2 +
 drivers/xen/xenfs/super.c                |   19 +-
 include/Kbuild                           |    1 +
 include/xen/Kbuild                       |    1 +
 include/xen/events.h                     |    3 +
 include/xen/evtchn.h                     |   88 +++++
 include/xen/interface/version.h          |    3 +
 include/xen/xenbus.h                     |    3 +-
 21 files changed, 1269 insertions(+), 107 deletions(-)
 create mode 100644 drivers/xen/evtchn.c
 create mode 100644 drivers/xen/sys-hypervisor.c
 create mode 100644 include/xen/Kbuild
 create mode 100644 include/xen/evtchn.h

