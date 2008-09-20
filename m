Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbYITSAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYITSAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 14:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYITSAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 14:00:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:39399 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYITSAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 14:00:33 -0400
Date: Sat, 20 Sep 2008 11:00:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@elte.hu
Subject: What's in fastboot.git for 2.6.28
Message-ID: <20080920110036.302261c7@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fastboot.git tree has a set of patches (all posted and reviewed on lkml before)
that speed up the kernel boot process of the kernel.

There's 3 major pieces of this
1) The creation of an asynchronous initcall level (6a) that runs asynchronous from
   the regular driver init, and is for non-boot critical initcalls only
2) A rework of the non-initrd boot code to try mounting /, and if that fails,
   only THEN wait for all the various driver probings to finish (and then retry)
3) A tool "bootgraph.pl" that outputs a SVG graphic of where the kernel boot spends
   its time 


The following changes since commit 9824b8f11373b0df806c135a342da9319ef1d893:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git390.osdl.marist.edu/pub/scm/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-fastboot.git master

Arjan van de Ven (15):
      fastboot: create a "asynchronous" initlevel
      fastboot: turn the USB hostcontroller initcalls into async initcalls
      fastboot: convert a few non-critical ACPI drivers to async initcalls
      fastboot: hold the BKL over the async init call sequence
      fastboot: sync the async execution before late_initcall and move level 6s (sync) first
      fastboot: make fastboot a config option
      modules: extend initcall_debug functionality to the module loader
      fastboot: retry mounting the root fs if we can't find init
      fastboot: make the raid autodetect code wait for all devices to init
      fastboot: remove "wait for all devices before mounting root" delay
      fastboot: make the RAID autostart code print a message just before waiting
      fastboot: fix blackfin breakage due to vmlinux.lds change
      Add a script to visualize the kernel boot process / time
      fastboot: fix issues and improve output of bootgraph.pl
      use the fancy new printk flags to print the function pointer

Arnaud Patard (1):
      fastboot: Fix bootgraph.pl initcall name regexp

Ingo Molnar (5):
      Merge branch 'linus' into fastboot
      fastboot: fix typo in init/Kconfig text
      warning: fix init do_mounts_md c
      Merge branch 'linus' into fastboot
      Merge commit 'v2.6.27-rc6' into fastboot

Li, Shaohua (1):
      fastboot: remove duplicate unpack_to_rootfs()

Steven Noonan (1):
      init/initramfs.c: unused function when compiling without CONFIG_BLK_DEV_RAM

 drivers/acpi/battery.c            |    2 +-
 drivers/acpi/button.c             |    2 +-
 drivers/acpi/thermal.c            |    2 +-
 drivers/pci/pci.c                 |    2 +-
 drivers/usb/host/ehci-hcd.c       |    2 +-
 drivers/usb/host/ohci-hcd.c       |    2 +-
 drivers/usb/host/uhci-hcd.c       |    2 +-
 include/asm-generic/vmlinux.lds.h |    6 +-
 include/linux/init.h              |    8 ++
 init/Kconfig                      |   11 +++
 init/do_mounts.c                  |    2 +
 init/do_mounts_md.c               |   29 ++++++--
 init/initramfs.c                  |   73 +++++++++++++++----
 init/main.c                       |   84 +++++++++++++++++++--
 scripts/bootgraph.pl              |  147 +++++++++++++++++++++++++++++++++++++
 15 files changed, 337 insertions(+), 37 deletions(-)
 create mode 100644 scripts/bootgraph.pl


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
