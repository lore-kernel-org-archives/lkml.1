Return-Path: <linux-kernel-owner+w=401wt.eu-S1759270AbZBLSHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270AbZBLSHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 13:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbZBLSGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 13:06:51 -0500
Received: from kroah.org ([198.145.64.141]:38246 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751164AbZBLSGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 13:06:50 -0500
Date: Thu, 12 Feb 2009 10:03:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.28.5
Message-ID: <20090212180328.GA15341@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.28.5
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.28.4 and 2.6.28.5

The updated 2.6.28.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.28.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.28.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/sysfs-pci.txt |   13 +++
 Makefile                                |    2 
 arch/ia64/sn/kernel/io_acpi_init.c      |    2 
 arch/ia64/sn/kernel/io_init.c           |    2 
 arch/x86/kernel/apic.c                  |    2 
 arch/x86/mm/fault.c                     |    8 +-
 drivers/acpi/asus_acpi.c                |   16 ++++
 drivers/acpi/dock.c                     |    6 +
 drivers/acpi/tables.c                   |    7 +
 drivers/acpi/tables/tbutils.c           |    7 -
 drivers/acpi/video.c                    |   29 ++++++--
 drivers/ata/sata_via.c                  |    2 
 drivers/block/nbd.c                     |    4 +
 drivers/char/agp/intel-agp.c            |   11 ++-
 drivers/firewire/fw-ohci.c              |    2 
 drivers/firewire/fw-sbp2.c              |   43 +++++++----
 drivers/ieee1394/ohci1394.h             |    2 
 drivers/ieee1394/sbp2.c                 |   10 ++
 drivers/md/linear.c                     |    6 -
 drivers/md/md.c                         |   24 +++---
 drivers/misc/eeepc-laptop.c             |    7 +
 drivers/misc/panasonic-laptop.c         |    2 
 drivers/misc/sgi-xp/xpc.h               |    5 -
 drivers/misc/sgi-xp/xpc_uv.c            |   11 +--
 drivers/net/e1000/e1000_main.c          |    6 -
 drivers/net/wireless/ipw2200.c          |   28 ++++++-
 drivers/net/wireless/ipw2200.h          |    1 
 drivers/pci/pci-sysfs.c                 |    4 -
 drivers/pci/pcie/aspm.c                 |    4 -
 drivers/pci/rom.c                       |    8 +-
 drivers/serial/8250_pci.c               |    9 ++
 drivers/usb/serial/option.c             |   93 +++++++++++++++----------
 drivers/usb/serial/ti_usb_3410_5052.c   |   13 ++-
 drivers/usb/serial/ti_usb_3410_5052.h   |    4 +
 drivers/usb/storage/scsiglue.c          |    2 
 drivers/usb/storage/unusual_devs.h      |   15 ----
 fs/binfmt_elf.c                         |   14 +++
 fs/seq_file.c                           |  115 ++++++++++++++++----------------
 fs/xfs/linux-2.6/xfs_buf.c              |    3 
 include/acpi/pdc_intel.h                |    2 
 include/linux/module.h                  |    1 
 include/linux/pci.h                     |    2 
 include/linux/pci_ids.h                 |    1 
 include/linux/serial.h                  |    3 
 include/linux/wait.h                    |   11 ++-
 ipc/shm.c                               |    4 +
 kernel/sched.c                          |    4 -
 kernel/sys.c                            |   16 +---
 kernel/wait.c                           |   59 ++++++++++++++--
 mm/memory.c                             |    2 
 mm/mlock.c                              |    5 +
 net/sctp/input.c                        |   13 +++
 sound/pci/hda/patch_realtek.c           |    4 +
 sound/usb/usbaudio.c                    |    1 
 54 files changed, 448 insertions(+), 222 deletions(-)

Alan Stern (1):
      USB: usb-storage: add Pentax to the bad-vendor list

Alex Chiang (1):
      PCI: properly clean up ASPM link state on device remove

Alexey Dobriyan (1):
      seq_file: fix big-enough lseek() + read()

Andre Noll (1):
      md: Fix a bug in linear.c causing which_dev() to return the wrong device.

Andrew Morton (1):
      revert "rlimit: permit setting RLIMIT_NOFILE to RLIM_INFINITY"

Andy Whitcroft (1):
      serial: RS485 ioctl structure uses __u32 include linux/types.h

Borislav Petkov (1):
      x86: APIC: enable workaround on AMD Fam10h CPUs

Carsten Otte (1):
      do_wp_page: fix regression with execute in place

Clemens Ladisch (1):
      sound: usb-audio: handle wMaxPacketSize for FIXED_ENDPOINT devices

Corentin Chary (1):
      asus_acpi: Add R1F support

Darren Salt (1):
      eeepc-laptop: fix oops when changing backlight brightness during eeepc-laptop init

Dean Nelson (1):
      sgi-xp: fix writing past the end of kzalloc()'d space

Dirk De Schepper (1):
      USB: option: New mobile broadband modems to be supported

Eric Anholt (1):
      agp/intel: Fix broken ® symbol in device name.

Eric Biederman (1):
      seq_file: move traverse so it can be used from seq_read

Greg Kroah-Hartman (2):
      Revert USB: option: add Pantech cards
      Linux 2.6.28.5

Helmut Schaa (1):
      ipw2200: fix scanning while associated

Holger Macht (1):
      ACPI: dock: Don't eval _STA on every show_docked sysfs read

Hugh Dickins (1):
      mm: fix error case in mlock downgrade reversion

Jesse Brandeburg (1):
      e1000: fix bug with shared interrupt during reset

Johannes Weiner (1):
      wait: prevent exclusive waiter starvation

JosephChan@via.com.tw (1):
      sata_via: Add VT8261 support

Karsten Keil (1):
      e1000: Fix PCI enable to honor the need_ioport flag

Lachlan McIlroy (1):
      XFS: set b_error from bio error in xfs_buf_bio_end_io

Len Brown (1):
      ACPI: disable ACPI cleanly when bad RSDP found

Masami Hiramatsu (1):
      prevent kprobes from catching spurious page faults

Matthew Garrett (1):
      eeepc-laptop: Add support for extended hotkeys

Michael Bramer (1):
      Add support for '8-port RS-232 MIC-3620 from advantech'

Myron Stowe (1):
      ACPICA: Fix table entry truncation calculation

NeilBrown (1):
      md: Ensure an md array never has too many devices.

Niels de Vos (1):
      serial: set correct baud_base for Oxford Semiconductor Ltd EXSYS EX-41092 Dual 16950 Serial adapter

Oliver Neukum (2):
      USB: new id for ti_usb_3410_5052 driver
      USB: two more usb ids for ti_usb_3410_5052

Pallipadi, Venkatesh (1):
      ACPI: Enable bit 11 in _PDC to advertise hw coord

Pavel Machek (1):
      nbd: do not allow two clients at the same time

Roel Kluin (1):
      panasonic-laptop: fix X[ ARRAY_SIZE(X) ]

Roland McGrath (1):
      elf core dump: fix get_user use

Rusty Russell (1):
      module: remove over-zealous check in __module_get()

Stefan Richter (5):
      ieee1394: ohci1394: increase AT req. retries, fix ack_busy_X from Panasonic camcorders and others
      firewire: ohci: increase AT req. retries, fix ack_busy_X from Panasonic camcorders and others
      firewire: sbp2: fix DMA mapping leak on the failure path
      firewire: sbp2: add workarounds for 2nd and 3rd generation iPods
      ieee1394: sbp2: add workarounds for 2nd and 3rd generation iPods

Takashi Iwai (3):
      ALSA: hda - Add quirk for FSC Amilo Xi2550
      ALSA: hda - Add missing COEF initialization for ALC887
      ALSA: hda - Add missing initialization for ALC272

Timothy S. Nelson (1):
      PCI: return error on failure to read PCI ROMs

Tony Battersby (1):
      shm: fix shmctl(SHM_INFO) lockup with !CONFIG_SHMEM

Vlad Yasevich (1):
      sctp: Fix another socket race during accept/peeloff

Zhang Rui (1):
      ACPI: video: Fix reversed brightness behavior on ThinkPad SL series

Zhao Yakui (2):
      ACPI: Skip the first two elements in the _BCL package
      ACPI: proc_dir_entry 'video/VGA' already registered

Zhenyu Wang (1):
      agp/intel: add support for G41 chipset

