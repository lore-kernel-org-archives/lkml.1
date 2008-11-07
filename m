Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbYKGXhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbYKGXhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbYKGXgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:36:05 -0500
Received: from kroah.org ([198.145.64.141]:48322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755896AbYKGXf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:35:59 -0500
Date: Fri, 7 Nov 2008 15:34:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.5
Message-ID: <20081107233437.GA5036@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.27.5
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
series are strongly encouraged to upgrade.  Very strongly.  Did I
mention that you all should upgrade?  Seriously, what are you waiting
for?  Running those old kernel trees prior to .27?  Are you crazy?  You
really want to run this one.  It's all shiny new and has that lovely
new-kernel smell that we all know and love.

I'll also be replying to this message with a copy of the patch between
2.6.27.4 and 2.6.27.5

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/i2c/busses/i2c-sis96x              |    2 
 MAINTAINERS                                      |   20 -
 Makefile                                         |    2 
 arch/powerpc/configs/linkstation_defconfig       |    7 
 arch/powerpc/mm/hash_utils_64.c                  |    6 
 arch/powerpc/mm/numa.c                           |  113 +++++-
 arch/powerpc/platforms/embedded6xx/linkstation.c |   14 
 arch/s390/kernel/smp.c                           |   24 -
 arch/sparc64/kernel/trampoline.S                 |   18 -
 arch/x86/kernel/process_64.c                     |    4 
 arch/x86/kernel/rtc.c                            |   22 +
 arch/x86/mm/pat.c                                |    4 
 drivers/acpi/button.c                            |    3 
 drivers/acpi/ec.c                                |  374 +++++++++++------------
 drivers/acpi/hardware/hwsleep.c                  |    7 
 drivers/acpi/reboot.c                            |   25 +
 drivers/ata/libata-core.c                        |    2 
 drivers/ata/pata_it821x.c                        |    3 
 drivers/ata/sata_nv.c                            |   53 +--
 drivers/ata/sata_promise.c                       |   20 +
 drivers/base/sys.c                               |    6 
 drivers/char/agp/intel-agp.c                     |   12 
 drivers/char/ipmi/ipmi_devintf.c                 |    1 
 drivers/firewire/fw-cdev.c                       |    6 
 drivers/firewire/fw-sbp2.c                       |   38 +-
 drivers/firewire/fw-topology.c                   |    6 
 drivers/firewire/fw-transaction.h                |    2 
 drivers/hid/usbhid/hid-quirks.c                  |    4 
 drivers/i2c/busses/scx200_i2c.c                  |    1 
 drivers/input/keyboard/atkbd.c                   |   10 
 drivers/media/dvb/frontends/s5h1411.c            |   35 +-
 drivers/media/video/pvrusb2/pvrusb2-encoder.c    |    4 
 drivers/net/atlx/atl1.c                          |    7 
 drivers/net/atlx/atl1.h                          |    2 
 drivers/net/bonding/bond_alb.c                   |   13 
 drivers/net/wireless/libertas/scan.c             |    4 
 drivers/pci/probe.c                              |    2 
 drivers/rtc/rtc-cmos.c                           |   33 +-
 drivers/scsi/sd.c                                |   10 
 drivers/usb/core/hcd.c                           |   35 +-
 drivers/usb/core/hcd.h                           |    1 
 drivers/usb/core/hub.c                           |    1 
 drivers/usb/core/urb.c                           |   15 
 drivers/usb/storage/unusual_devs.h               |    9 
 fs/hfsplus/bitmap.c                              |   12 
 fs/hfsplus/catalog.c                             |    5 
 include/linux/sched.h                            |    4 
 include/math-emu/op-common.h                     |   17 -
 include/net/scm.h                                |    5 
 kernel/sched_clock.c                             |    6 
 kernel/sched_features.h                          |    2 
 net/core/scm.c                                   |   24 +
 net/ipv4/tcp_output.c                            |   33 +-
 net/ipv6/tcp_ipv6.c                              |    2 
 net/sched/sch_generic.c                          |    2 
 scripts/package/mkspec                           |    3 
 security/commoncap.c                             |    6 
 sound/core/control.c                             |    4 
 sound/pci/hda/hda_intel.c                        |   29 +
 59 files changed, 744 insertions(+), 390 deletions(-)

Alan Stern (1):
      USB: fix crash when URBs are unlinked after the device is gone

Alexey Starikovskiy (3):
      ACPI: EC: do transaction from interrupt context
      ACPI: EC: Rename some variables
      ACPI: EC: Check for IBF=0 periodically if not in GPE mode

Andi Kleen (1):
      sysfs: Fix return values for sysdev_store_{ulong, int}

Andrea Shepard (1):
      sparc64: Fix race in arch/sparc64/kernel/trampoline.S

Andy Gospodarek (1):
      bonding: fix panic when taking bond interface down before removing module

Bjorn Helgaas (2):
      rtc-cmos: look for PNP RTC first, then for platform RTC
      x86: register a platform RTC device if PNP doesn't describe it

Boris Dores (1):
      V4L: pvrusb2: Keep MPEG PTSs from drifting away

Dan Nicholson (1):
      Revert "HID: Invert HWHEEL mappings for some Logitech mice"

Dave Kleikamp (1):
      sched_clock: prevent scd->clock from moving backwards

David Miller (1):
      net: Fix recursive descent in __scm_destroy().

David Rientjes (1):
      x86: avoid dereferencing beyond stack + THREAD_SIZE

Devin Heitmueller (2):
      DVB: s5h1411: Perform s5h1411 soft reset after tuning
      DVB: s5h1411: Power down s5h1411 when not in use

Eric Anholt (1):
      agp: Fix stolen memory counting on G4X.

Eric Sesterhenn (2):
      hfsplus: fix Buffer overflow with a corrupted image
      hfsplus: check read_mapping_page() return value

Evgeniy Manachkin (1):
      kbuild: mkspec - fix build rpm

Florian Westphal (1):
      syncookies: fix inclusion of tcp options in syn-ack

Greg Kroah-Hartman (1):
      Linux 2.6.27.5

Guennadi Liakhovetski (1):
      powerpc: fix i2c on PPC linkstation / kurobox machines

Guillem Jover (1):
      ACPI: Always report a sync event after a lid state change

Heiko Carstens (1):
      S390: Fix sysdev class file creation.

Ilpo Järvinen (2):
      tcp: Restore ordering of TCP options for the sake of inter-operability
      tcpv6: fix option space offsets with md5

Ingo Molnar (1):
      sched: disable the hrtick for now

Jamie Wellnitz (1):
      SCSI: sd: Fix handling of NO_SENSE check condition

Jarek Poplawski (1):
      pkt_sched: sch_generic: Fix oops in sch_teql

Jay Cliburn (1):
      atl1: fix vlan tag regression

Jay Fenlason (3):
      firewire: Survive more than 256 bus resets
      firewire: fix struct fw_node memory leak
      firewire: fw-sbp2: fix races

Jean Delvare (1):
      i2c: The i2c mailing list is moving

Johannes Berg (1):
      libertas: fix buffer overrun

Jon Tollefson (3):
      powerpc: Reserve in bootmem lmb reserved regions that cross NUMA nodes
      powerpc/numa: Make memory reserve code more robust
      powerpc: Don't use a 16G page if beyond mem= limits

Kumar Gala (1):
      math-emu: Fix signalling of underflow and inexact while packing result.

Lennart Sorensen (1):
      scx200_i2c: Add missing class parameter

Matthew Garrett (2):
      ACPI: Clear WAK_STS on resume
      Input: atkbd - expand Latitude's force release quirk to other Dells

Mikael Pettersson (1):
      sata_promise: add ATA engine reset to reset ops

Ondrej Zary (1):
      libata: Fix LBA48 on pata_it821x RAID volumes.

Peter Chubb (1):
      PCI: fix 64-vbit prefetchable memory resource BARs

Phil Dibowitz (1):
      USB: storage: Avoid I/O errors when issuing SCSI ioctls to JMicron USB/ATA bridge

Ravikiran G Thirumalai (1):
      x86: fix /dev/mem mmap breakage when PAT is disabled

Scott James Remnant (1):
      ipmi: add MODULE_ALIAS to load ipmi_devintf with ipmi_si

Serge Hallyn (1):
      file caps: always start with clear bprm->caps_*

Stefan Richter (3):
      firewire: fix setting tag and sy in iso transmission
      firewire: fix ioctl() return code
      firewire: fw-sbp2: delay first login to avoid retries

Steven Toth (1):
      DVB: s5h1411: bugfix: Setting serial or parallel mode could destroy bits

Takashi Iwai (2):
      ALSA: hda - Add reboot notifier
      ALSA: use correct lock in snd_ctl_dev_disconnect()

Tejun Heo (2):
      libata: initialize port_task when !CONFIG_ATA_SFF
      sata_nv: fix generic, nf2/3 detection regression

Zhao Yakui (1):
      ACPI: Ingore the RESET_REG_SUP bit when using ACPI reset mechanism

