Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbZCWSHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbZCWSHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758368AbZCWSEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:04:32 -0400
Received: from adsl-69-107-72-54.dsl.pltn13.pacbell.net ([69.107.72.54]:35011
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758022AbZCWSE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:04:27 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] xen domU control interfaces
Date: Mon, 23 Mar 2009 10:55:00 -0700
Message-Id: <1237830911-6249-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <49C45238.7050007@zytor.com>
References: <49C45238.7050007@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series adds some usermode interfaces for interfacing with Xen from
an unprivileged domain:
	- Xen support for /sys/hypervisor
	- /dev/evtchn, to allow usermode to block on and send events via
	  event channels
	- updates to xenfs (/proc/xen)
	- updates to the xenbus interface

Thanks,
	J

The following changes since commit 627b11ca44b334e201c35bf1a1582dc10efaf4a8:
  Jeremy Fitzhardinge (1):
        xen/mmu: weaken flush_tlb_other test

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push2/xen/control

Ian Campbell (6):
      xen: add irq_from_evtchn
      xen: add /dev/xen/evtchn driver
      xen: export ioctl headers to userspace
      xen: drop kexec bits from /sys/hypervisor since kexec isn't implemented yet
      xen: remove suspend_cancel hook
      xen: use device model for suspending xenbus devices

Jeremy Fitzhardinge (9):
      xen/dev-evtchn: clean up locking in evtchn
      xen: add "capabilities" file
      xen: add /sys/hypervisor support
      xen/sys/hypervisor: change writable_pt to features
      xen/xenbus: export xenbus_dev_changed
      Merge branch 'push2/xen/xenbus' into push2/xen/control
      Merge branch 'push2/xen/dev-evtchn' into push2/xen/control
      Merge branch 'push2/xen/sys-hypervisor' into push2/xen/control
      Merge branch 'push2/xen/xenfs' into push2/xen/control

 drivers/xen/Kconfig               |   20 ++
 drivers/xen/Makefile              |    4 +-
 drivers/xen/events.c              |    6 +
 drivers/xen/evtchn.c              |  507 +++++++++++++++++++++++++++++++++++++
 drivers/xen/manage.c              |    9 +-
 drivers/xen/sys-hypervisor.c      |  445 ++++++++++++++++++++++++++++++++
 drivers/xen/xenbus/xenbus_probe.c |   61 +----
 drivers/xen/xenbus/xenbus_xs.c    |    2 +
 drivers/xen/xenfs/super.c         |   19 ++-
 include/Kbuild                    |    1 +
 include/xen/Kbuild                |    1 +
 include/xen/events.h              |    3 +
 include/xen/evtchn.h              |   88 +++++++
 include/xen/interface/version.h   |    3 +
 include/xen/xenbus.h              |    3 +-
 15 files changed, 1112 insertions(+), 60 deletions(-)
 create mode 100644 drivers/xen/evtchn.c
 create mode 100644 drivers/xen/sys-hypervisor.c
 create mode 100644 include/xen/Kbuild
 create mode 100644 include/xen/evtchn.h

