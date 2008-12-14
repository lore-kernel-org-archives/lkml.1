Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbYLNAMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbYLNAMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 19:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYLNAL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 19:11:57 -0500
Received: from kroah.org ([198.145.64.141]:36221 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751372AbYLNALz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 19:11:55 -0500
Date: Sat, 13 Dec 2008 16:10:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.9
Message-ID: <20081214001029.GA915@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.27.9
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
series are strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.8 and 2.6.27.9

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 
 arch/powerpc/kernel/cpu_setup_44x.S   |    1 
 arch/powerpc/kernel/cputable.c        |    3 
 arch/powerpc/platforms/cell/smp.c     |   10 -
 arch/powerpc/platforms/pseries/smp.c  |   13 -
 arch/powerpc/sysdev/mpic.c            |    9 
 arch/sparc/include/asm/uaccess_64.h   |    4 
 arch/sparc64/kernel/pci.c             |   10 -
 arch/sparc64/kernel/ptrace.c          |    2 
 arch/sparc64/kernel/visemul.c         |    6 
 arch/sparc64/lib/user_fixup.c         |    2 
 arch/um/drivers/mconsole_kern.c       |    4 
 arch/x86/kernel/hpet.c                |    2 
 arch/x86/mm/init_64.c                 |    4 
 block/bsg.c                           |    2 
 block/scsi_ioctl.c                    |    2 
 drivers/acpi/osl.c                    |   36 ---
 drivers/acpi/sleep/main.c             |   40 +++-
 drivers/ata/libata-sff.c              |   13 +
 drivers/char/applicom.c               |    6 
 drivers/edac/cell_edac.c              |    3 
 drivers/hid/usbhid/hid-quirks.c       |    2 
 drivers/input/serio/i8042-x86ia64io.h |   29 ++
 drivers/net/cxgb3/adapter.h           |    1 
 drivers/net/cxgb3/cxgb3_main.c        |    5 
 drivers/net/cxgb3/sge.c               |   56 +----
 drivers/net/niu.c                     |    3 
 drivers/net/pppol2tp.c                |    1 
 drivers/pci/pcie/aspm.c               |   29 ++
 drivers/pci/slot.c                    |    1 
 drivers/pnp/base.h                    |    2 
 drivers/pnp/quirks.c                  |    2 
 drivers/pnp/resource.c                |    4 
 drivers/spi/spidev.c                  |    4 
 drivers/usb/serial/option.c           |  176 +++++++++++++++--
 drivers/usb/storage/unusual_devs.h    |  334 +++++++++++++++++++++++++++++++---
 drivers/watchdog/ib700wdt.c           |    2 
 fs/binfmt_em86.c                      |    2 
 fs/binfmt_misc.c                      |    4 
 fs/binfmt_script.c                    |    5 
 fs/cifs/connect.c                     |   36 ++-
 fs/exec.c                             |   10 -
 fs/fcntl.c                            |    7 
 fs/ioctl.c                            |   12 -
 fs/jbd/checkpoint.c                   |   49 +++-
 fs/jbd/journal.c                      |   28 ++
 fs/jbd/recovery.c                     |    7 
 fs/proc/task_mmu.c                    |    4 
 fs/xfs/xfs_rename.c                   |    2 
 include/linux/binfmts.h               |    2 
 include/linux/blkdev.h                |    1 
 include/linux/jbd.h                   |    2 
 include/linux/pnp.h                   |    6 
 kernel/fork.c                         |   15 -
 kernel/sched.c                        |    8 
 net/atm/svc.c                         |    6 
 net/ipv4/udp.c                        |   12 -
 net/ipv6/udp.c                        |    8 
 net/unix/af_unix.c                    |    2 
 sound/pci/emu10k1/emu10k1_main.c      |    3 
 sound/pci/hda/hda_proc.c              |    2 
 sound/pci/hda/patch_analog.c          |   10 -
 sound/pci/hda/patch_realtek.c         |  152 +++++++++++++++
 sound/pci/hda/patch_sigmatel.c        |   45 ++++
 64 files changed, 1022 insertions(+), 243 deletions(-)


Alan Cox (1):
      applicom: Fix an unchecked user ioctl range and an error return

Alan Stern (3):
      USB: storage: updates unusual_devs entry for the Nokia 6300
      USB: storage: update unusual_devs entries for Nokia 5300 and 5310
      USB: storage: unusual_devs entry for Mio C520-GPS

Alex Chiang (1):
      PCI: stop leaking 'slot_name' in pci_create_slot

Arnd Bergmann (1):
      powerpc/mpic: Don't reset affinity for secondary MPIC on boot

Balbir Singh (1):
      uml: boot broken due to buffer overrun

Benjamin Herrenschmidt (1):
      edac: fix enabling of polling cell module

Brian King (1):
      sched: CPU remove deadlock fix

Chas Williams (1):
      ATM: CVE-2008-5079: duplicate listen() on socket corrupts the vcc table

Chris Torek (1):
      sparc64: Fix bug in PTRACE_SETFPREGS64 handling.

Clive Messer (1):
      ALSA: hda - Fix another ALC889A (rev 0x100101)

Colin B Macdonald (1):
      Input: i8042 - add Thinkpad R31 to nomux list

Dan Williams (2):
      USB: option: add Ericsson F3507g and Dell 5530
      USB: option: add Pantech cards

Dave Chinner (1):
      XFS: Fix hang after disallowed rename across directory quota domains

David S. Miller (2):
      niu: Fix readq implementation when architecture does not provide one.
      sparc64: Fix offset calculation in compute_size()

Denis Joseph Barrow (1):
      USB: option.c remove duplicate device ids now supported in hso.c

Divy Le Ray (2):
      cxgb3 - fix race in EEH
      cxgb3 - remove duplicate tests in lro

Dmitry Torokhov (1):
      Input: i8042 - add Compal Hel80 laptop to nomux blacklist

Eric Dumazet (1):
      udp: multicast packets need to check namespace

Frédéric Marchal (1):
      USB: Unusual dev for Mio moov 330 gps

Frédéric Moulins (1):
      pppol2tp: Add missing sock_put() in pppol2tp_release()

Gary Hade (1):
      x86: remove debug code from arch_add_memory()

Grant Likely (1):
      powerpc/virtex5: Fix Virtex5 machine check handling

Greg Kroah-Hartman (2):
      USB: serial: add more Onda device ids to option driver
      Linux 2.6.27.9

Herton Ronaldo Krzesinski (1):
      Input: i8042 - add Dell XPS M1530 to nomux list

Hidehiro Kawai (2):
      jbd: fix error handling for checkpoint io
      jbd: test BH_Write_EIO to detect errors on metadata buffers

Hong H. Pham (1):
      sparc64: Sync FPU state in VIS emulation handler.

Hugh Dickins (2):
      sparc64: Fix __copy_{to,from}_user_inatomic defines.
      fix mapping_writably_mapped()

Jeff Layton (1):
      cifs: fix a regression in cifs umount codepath

Jens Taprogge (1):
      USB: Unusual dev for the "Kyocera / Contax SL300R T*" digital camera.

Jianjun Kong (1):
      af_unix: netns: fix problem of return value

Jon K Hellan (1):
      USB: Option / AnyData new modem, same ID

Jonathan Corbet (1):
      Fix a race condition in FASYNC handling

Joseph Myers (1):
      sparc64: Fix VIS emulation bugs

Kailang Yang (2):
      ALSA: hda - Add ALC887 support
      ALSA: hda - Add support of ALC272

Kirill A. Shutemov (1):
      Allow recursion in binfmt_script and binfmt_misc

Len Brown (1):
      ACPI: delete OSI(Linux) DMI dmesg spam

Leslie Watter (1):
      USB: Add YISO u893 usb modem vendor and product IDs to option driver

Li Zefan (1):
      sched: fix a bug in sched domain degenerate

Linus Torvalds (1):
      Enforce a minimum SG_IO timeout

Matt Fleming (1):
      x86: HPET: convert WARN_ON to WARN_ON_ONCE

Matt Mackall (1):
      pagemap: fix 32-bit pagemap regression

Matthew Ranostay (1):
      ALSA: hda: fixed hp_nid DAC for DELL_M6

Mauro Carvalho Chehab (1):
      ALSA: hda: Add support for ECS/PC Chips boards with Sigmatel codecs

Max Dmitrichenko (1):
      sparc64: Fix PCI resource mapping on sparc64

Michel Marti (1):
      ALSA: hda - Add another HP model (6730s) for AD1884A

Mikhail Gusarov (1):
      USB: add ZTE MF626 USB GSM modem entry

Milton Miller (1):
      powerpc: Use cpu_thread_in_core in smp_init for of_spin_map

Pascal Terjan (1):
      ALSA: hda - Fix sound on NEC Versa S9100

Paul Ready (1):
      USB: add Nikon D300 camera to unusual_devs

Peter Korsgaard (2):
      ALSA: hda: appletv support
      atv: hid quirk for appletv IR receiver

Rafael J. Wysocki (1):
      ACPI suspend: Blacklist boxes that require us to set SCI_EN directly on resume

Rene Herman (1):
      pnp: make the resource type an unsigned long

Ricky Wong (1):
      USB: unusual devs patch for Nokia 7610 Supernova

Robin H. Johnson (3):
      ALSA: HDA: hda_proc: Fix printf format specifier
      ALSA: HDA: patch_analog: Fix SPDIF output on AD1989B
      ALSA: HDA: patch_analog: Quirk for Asus P5Q Premium/Pro boards.

Roland McGrath (1):
      tracehook: exec double-reporting fix

Shaohua Li (1):
      x86, memory hotplug: remove wrong -1 in calling init_memory_mapping()

Stefan Bader (1):
      Input: i8042 - add Blue FB5601 to noloop exception table

Takashi Iwai (9):
      ALSA: hda - Fix ALC269 capture source
      ALSA: hda - Restore default pin configs for realtek codecs
      ALSA: hda - Add another HP model for AD1884A
      ALSA: hda - Add a quirk for another Acer Aspire (1025:0090)
      ALSA: hda - Add a quirk for MEDION MD96630
      ALSA: hda - Add a quirk for Dell Studio 15
      ALSA: hda - No 'Headphone as Line-out' swich without line-outs
      ALSA: hda - mark Dell studio 1535 quirk
      ALSA: emu10k1 - Add more invert_shared_spdif flag to Audigy models

Tejun Heo (1):
      libata: improve phantom device detection

Thomas Renninger (1):
      PCIe: ASPM: Break out of endless loop waiting for PCI config bits to switch

Tobias Kunze Briseño (1):
      USB: usb-storage: unusual_devs entry for Nikon D2H

Travis Place (2):
      ALSA: hda - Add model for Toshiba L305 laptop
      ALSA: hda - Make the HP EliteBook 8530p use AD1884A model laptop

Wim Van Sebroeck (1):
      ib700wdt.c - fix buffer_underflow bug

Wolfgang Ocker (1):
      spi: avoid spidev crash when device is removed

fangxiaozhi (2):
      USB: support Huawei data card product IDs
      USB: unusual-devs: support Huawei data card product IDs

