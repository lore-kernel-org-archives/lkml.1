Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbYKTXNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbYKTXNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 18:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYKTXNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 18:13:06 -0500
Received: from kroah.org ([198.145.64.141]:60849 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751308AbYKTXND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 18:13:03 -0500
Date: Thu, 20 Nov 2008 15:12:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.7
Message-ID: <20081120231206.GA4063@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.27.7
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.6 and 2.6.27.7

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/arm/mm/cache-feroceon-l2.c           |    4 -
 arch/m68k/kernel/ints.c                   |    2 
 arch/powerpc/include/asm/mpic.h           |    2 
 arch/powerpc/platforms/85xx/mpc85xx_ds.c  |    3 -
 arch/powerpc/platforms/86xx/pic.c         |    3 -
 arch/powerpc/sysdev/mpic.c                |   59 +++++++++++++++++++--
 arch/s390/kernel/topology.c               |   11 ++-
 block/blk-merge.c                         |   19 ++++++
 drivers/acpi/bus.c                        |   16 ++---
 drivers/acpi/ec.c                         |   84 ++++++++++++++++++++----------
 drivers/acpi/scan.c                       |   35 ++++++++----
 drivers/acpi/system.c                     |   25 ++++++--
 drivers/char/ipmi/ipmi_msghandler.c       |   20 +++----
 drivers/char/ipmi/ipmi_si_intf.c          |   16 +++--
 drivers/hwmon/ibmaem.c                    |   18 +++---
 drivers/input/mouse/alps.c                |    1 
 drivers/md/dm-raid1.c                     |    1 
 drivers/media/video/tvaudio.c             |   15 ++---
 drivers/misc/sony-laptop.c                |    6 +-
 drivers/net/Kconfig                       |    1 
 drivers/net/bnx2x_init.h                  |    9 +--
 drivers/net/bnx2x_main.c                  |    6 +-
 drivers/net/wireless/ath5k/base.c         |   67 ++++++++++++-----------
 drivers/net/wireless/ath5k/base.h         |    3 -
 drivers/net/wireless/ath5k/hw.c           |   22 ++-----
 drivers/net/wireless/ath5k/initvals.c     |    2 
 drivers/net/wireless/hostap/hostap_wlan.h |    5 +
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    6 +-
 drivers/net/wireless/rtl8187_dev.c        |    3 +
 drivers/pnp/pnpacpi/core.c                |    6 +-
 drivers/scsi/dpt_i2o.c                    |    4 -
 drivers/scsi/qla2xxx/qla_def.h            |    1 
 drivers/scsi/qla2xxx/qla_init.c           |    2 
 drivers/scsi/qla2xxx/qla_mbx.c            |    2 
 drivers/scsi/qla2xxx/qla_os.c             |    1 
 drivers/scsi/qla2xxx/qla_sup.c            |   23 +++-----
 drivers/usb/class/cdc-acm.c               |    9 +--
 drivers/usb/core/message.c                |    1 
 drivers/usb/core/sysfs.c                  |    2 
 drivers/usb/gadget/f_acm.c                |    4 +
 drivers/usb/host/Kconfig                  |   23 ++------
 drivers/usb/host/ehci-hcd.c               |   25 ++++----
 drivers/usb/host/ehci-ps3.c               |    1 
 drivers/usb/host/ehci-sched.c             |    4 -
 drivers/usb/host/isp1760-if.c             |   22 +++----
 drivers/usb/host/ohci-ps3.c               |    3 -
 drivers/usb/storage/unusual_devs.h        |    7 ++
 fs/namespace.c                            |    7 ++
 fs/proc/proc_sysctl.c                     |    1 
 include/linux/bio.h                       |    7 ++
 include/linux/usb.h                       |    2 
 mm/hugetlb.c                              |    5 +
 mm/page_isolation.c                       |    5 +
 net/ipv4/proc.c                           |   58 ++++++++++----------
 scripts/package/builddeb                  |   24 +++++++-
 56 files changed, 451 insertions(+), 264 deletions(-)

Adam Litke (1):
      hugetlb: make unmap_ref_private multi-size-aware

Al Viro (1):
      Fix broken ownership of /proc/sys/ files

Alan Jenkins (1):
      ACPI: EC: make kernel messages more useful when GPE storm is detected

Alan Stern (4):
      USB: unusual_devs entry for Argosy USB mass-storage interface
      USB: EHCI: fix divide-by-zero bug
      USB: EHCI: fix handling of dead controllers
      USB: don't register endpoints for interfaces that are going away

Alexey Starikovskiy (5):
      ACPI: EC: revert msleep patch
      ACPI: EC: wait for last write gpe
      ACPI: EC: restart failed command
      ACPI: EC: lower interrupt storm treshold
      ACPI: EC: Don't do transaction from GPE handler in poll mode.

Bob Jolliffe (1):
      rtl8187 : support for Sitecom WL-168 0001 v4

Brandon Philips (1):
      USB: cdc-acm.c: fix recursive lock in acm_start_wb error path

Dan Williams (1):
      touch_mnt_namespace when the mount flags change

Darrick J. Wong (1):
      Fix platform drivers that crash on suspend/resume

David Brownell (1):
      USB: gadget: cdc-acm deadlock fix

Eilon Greenstein (3):
      bnx2x: Removing the PMF indication when unloading
      bnx2x: PCI configuration bug on big-endian
      bnx2x: Calling netif_carrier_off at the end of the probe

Elias Oltmanns (2):
      ath5k: fix suspend-related oops on rmmod
      ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular

Elvis Pranskevichus (1):
      Input: ALPS - add signature for DualPoint found in Dell Latitude E6500

Eric Dumazet (1):
      net: fix /proc/net/snmp as memory corruptor

FUJITA Tomonori (1):
      block: fix nr_phys_segments miscalculation bug

Francois Romieu (1):
      r8169: select MII in Kconfig

Geert Uytterhoeven (1):
      m68k: Fix off-by-one in m68k_setup_user_interrupt()

Geoff Levand (1):
      USB: Fix PS3 USB shutdown problems

Gerald Schaefer (1):
      memory hotplug: fix page_zone() calculation in test_pages_isolated()

Greg Kroah-Hartman (1):
      Linux 2.6.27.7

Heiko Carstens (1):
      S390: cpu topology: fix locking

Ivan Kuten (1):
      rtl8187: Add Abocom USB ID

Johannes Berg (1):
      hostap: pad the skb->cb usage in lieu of a proper fix

John W. Linville (1):
      iwlagn: avoid sleep in softirq context

Jonathan McDowell (1):
      kbuild: Fixup deb-pkg target to generate separate firmware deb

Kumar Gala (1):
      powerpc/mpic: Fix regression caused by change of default IRQ affinity

Lalit Chandivade (1):
      SCSI: qla2xxx: Correct Atmel flash-part handling.

Matthew Garrett (1):
      sony-laptop: ignore missing _DIS method on pic device

Mauro Carvalho Chehab (1):
      V4L/DVB (9624): CVE-2008-5033: fix OOPS on tvaudio when controlling bass/treble

Michael Reed (1):
      SCSI: qla2xxx: Return a FAILED status when abort mailbox-command fails.

Mikulas Patocka (1):
      dm raid1: flush workqueue before destruction

Miquel van Smoorenburg (1):
      SCSI: dpt_i2o: fix transferred data length for scsi_set_resid()

Nicolas Pitre (1):
      ARM: 5329/1: Feroceon: fix feroceon_l2_inv_range

Peter Gruber (1):
      ACPI: avoid empty file name in sysfs

Sebastian Andrzej Siewior (1):
      USB: remove optional bus bindings in isp1760, fixing runtime warning

Shyam Sundar (1):
      SCSI: qla2xxx: Do not honour max_vports from firmware for 2G ISPs and below.

Zhao Yakui (1):
      ACPI : Load device driver according to the status of acpi device

