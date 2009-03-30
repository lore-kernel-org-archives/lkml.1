Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbZC3Vvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbZC3Vvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZC3VvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:51:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40485 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZC3VvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:51:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM changes for 2.6.30
Date: Mon, 30 Mar 2009 23:51:23 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-rjw; KDE/4.2.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903302351.24438.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the power management updates for 2.6.30 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

This contains the patches that modify the handling of interrupts during suspend
and resume and the associated PCI PM patches.  All of them have been reviewed
and accepted by the appropriate maintainers.

 arch/x86/kernel/apm_32.c      |   15 +++-
 drivers/base/power/main.c     |   20 +++--
 drivers/base/sys.c            |    8 ++
 drivers/pci/pci-driver.c      |  177 ++++++++++++++++++++++++++---------------
 drivers/pci/pci.c             |  142 +++++++++++++++------------------
 drivers/pci/pci.h             |    1 -
 drivers/video/aty/radeon_pm.c |    2 +-
 drivers/xen/manage.c          |   16 ++--
 include/linux/interrupt.h     |    9 ++
 include/linux/irq.h           |    1 +
 include/linux/pci.h           |    1 +
 kernel/irq/Makefile           |    1 +
 kernel/irq/internals.h        |    2 +
 kernel/irq/manage.c           |   31 ++++++--
 kernel/irq/pm.c               |   79 ++++++++++++++++++
 kernel/kexec.c                |   19 ++---
 kernel/power/disk.c           |  138 ++++++++++++++++++++------------
 kernel/power/main.c           |   55 ++++++++-----
 18 files changed, 461 insertions(+), 256 deletions(-)

---------------

Frans Pop <elendil@planet.nl> (1):
      PCI PM: Consistently use variable name "error" for pm call return values

Rafael J. Wysocki <rjw@sisk.pl> (13):
      PM: Introduce functions for suspending and resuming device interrupts
      PM: Rework handling of interrupts during suspend-resume
      PM: Change suspend code ordering
      PM: Change hibernation code ordering
      kexec: Change kexec jump code ordering
      PCI PM: Use pci_set_power_state during early resume
      PCI PM: Move pci_restore_standard_config to pci-driver.c
      PCI PM: Put devices into low power states during late suspend (rev. 2)
      PCI PM: Make pci_set_power_state() handle devices with no PM support
      PCI PM: Restore config spaces of all devices during early resume
      PCI PM: Introduce __pci_[start|complete]_power_transition() (rev. 2)
      radeonfb: Use __pci_complete_power_transition()
      PCI PM: Make pci_prepare_to_sleep() disable wake-up if needed

[This is my first pull request, so please be patient ... ;-)]

Thanks,
Rafael

