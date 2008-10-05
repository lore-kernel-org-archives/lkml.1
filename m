Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbYJEQgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbYJEQgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759942AbYJEQfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:35:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35277 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758906AbYJEQfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:35:05 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 00/19] Alan's Miscellaneous Tree
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:34:59 +0100
Message-ID: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This basically comes from trawling the kernel bugzilla for trivial fixes and
stuff that needs doing. These patches I hope to get into 2.6.28 but via the
relevant tree maintainers when applicable.

---

Alan Cox (19):
      fdomain_cs: Sort out modules with duplicate description
      modinfo: Remove duplicate modinfo from some drivers
      cdc-acm: Add another conexant modem to the quirks
      mptsas: remove unneeded check
      email: sort out a consistent email address for my contributions and stuff
      parport: quickfix the proc registration bug
      serial_8250: pci_enable_device fail is not fully handled
      pxa27x_udc: leak fix
      mptlan: Kill unused NAA workaround code
      ibmtr: PCMCIA IBMTR is ok on 64bit
      mtd: map_rom has NULL erase pointer
      qla2xxx: Switch to ROM API
      mtd: intel_dc21285 switch to ROM API
      hfsplus: O_LARGEFILE checking is missing
      aic7xxx: MHz not Mhz for SI unit pedants
      ib700wdt: Fix off by one
      pcmcia: Whine harder about use of EXCLUSIVE
      pcmcia: IRQ_TYPE_EXCLUSIVE is long obsoleted
      pcmcia: Fix wireless drivers


 Documentation/DocBook/deviceiobook.tmpl     |    2 -
 Documentation/DocBook/mcabook.tmpl          |    2 -
 Documentation/DocBook/videobook.tmpl        |    2 -
 Documentation/DocBook/wanbook.tmpl          |    2 -
 Documentation/DocBook/z8530book.tmpl        |    2 -
 Documentation/isdn/CREDITS                  |    2 -
 Documentation/networking/dmfe.txt           |    2 -
 Documentation/scsi/aacraid.txt              |    2 -
 Documentation/video4linux/bttv/CONTRIBUTORS |    2 -
 arch/m32r/kernel/smp.c                      |    2 -
 arch/m32r/kernel/smpboot.c                  |    2 -
 arch/um/drivers/harddog_kern.c              |    3 -
 arch/x86/kernel/apm_32.c                    |    4 +
 arch/x86/kernel/cpu/mcheck/mce_32.c         |    2 -
 arch/x86/kernel/cpu/mcheck/p5.c             |    2 -
 arch/x86/kernel/cpu/mcheck/p6.c             |    2 -
 arch/x86/kernel/cpu/mcheck/winchip.c        |    2 -
 arch/x86/kernel/mpparse.c                   |    2 -
 arch/x86/kernel/smp.c                       |    2 -
 arch/x86/kernel/smpboot.c                   |    2 -
 drivers/ata/ata_generic.c                   |    2 -
 drivers/ata/ata_piix.c                      |    2 -
 drivers/ata/pata_acpi.c                     |    2 -
 drivers/ata/pata_ali.c                      |    1 
 drivers/ata/pata_amd.c                      |    1 
 drivers/ata/pata_artop.c                    |    2 -
 drivers/ata/pata_atiixp.c                   |    1 
 drivers/ata/pata_cmd640.c                   |    1 
 drivers/ata/pata_cmd64x.c                   |    2 -
 drivers/ata/pata_cs5530.c                   |    1 
 drivers/ata/pata_cs5535.c                   |    2 -
 drivers/ata/pata_cypress.c                  |    2 -
 drivers/ata/pata_efar.c                     |    2 -
 drivers/ata/pata_isapnp.c                   |    2 -
 drivers/ata/pata_it821x.c                   |    4 +
 drivers/ata/pata_jmicron.c                  |    2 -
 drivers/ata/pata_legacy.c                   |    2 -
 drivers/ata/pata_marvell.c                  |    2 -
 drivers/ata/pata_mpiix.c                    |    2 -
 drivers/ata/pata_netcell.c                  |    2 -
 drivers/ata/pata_ninja32.c                  |    1 
 drivers/ata/pata_ns87410.c                  |    1 
 drivers/ata/pata_ns87415.c                  |    2 -
 drivers/ata/pata_oldpiix.c                  |    2 -
 drivers/ata/pata_opti.c                     |    1 
 drivers/ata/pata_optidma.c                  |    1 
 drivers/ata/pata_pcmcia.c                   |    2 -
 drivers/ata/pata_pdc202xx_old.c             |    2 -
 drivers/ata/pata_platform.c                 |    2 -
 drivers/ata/pata_qdi.c                      |    2 -
 drivers/ata/pata_radisys.c                  |    2 -
 drivers/ata/pata_sc1200.c                   |    2 -
 drivers/ata/pata_scc.c                      |    2 -
 drivers/ata/pata_serverworks.c              |    1 
 drivers/ata/pata_sil680.c                   |    1 
 drivers/ata/pata_sis.c                      |    2 -
 drivers/ata/pata_sl82c105.c                 |    1 
 drivers/ata/pata_triflex.c                  |    2 -
 drivers/ata/pata_via.c                      |    1 
 drivers/ata/pata_winbond.c                  |    2 -
 drivers/bluetooth/bluecard_cs.c             |    2 -
 drivers/bluetooth/bt3c_cs.c                 |    6 +-
 drivers/bluetooth/btuart_cs.c               |    6 +-
 drivers/bluetooth/dtl1_cs.c                 |    7 +-
 drivers/char/applicom.c                     |    6 +-
 drivers/char/hw_random/amd-rng.c            |    2 -
 drivers/char/hw_random/geode-rng.c          |    2 -
 drivers/char/hw_random/intel-rng.c          |    2 -
 drivers/char/hw_random/via-rng.c            |    2 -
 drivers/char/isicom.c                       |    6 +-
 drivers/char/mxser.c                        |    3 +
 drivers/char/pcmcia/synclink_cs.c           |    2 -
 drivers/ide/ide-disk.c                      |    2 -
 drivers/ide/ide-iops.c                      |    2 -
 drivers/ide/ide-proc.c                      |    2 -
 drivers/ide/pci/alim15x3.c                  |    2 -
 drivers/ide/pci/generic.c                   |    2 -
 drivers/ide/pci/hpt366.c                    |    2 -
 drivers/ide/pci/it821x.c                    |    2 -
 drivers/ide/pci/jmicron.c                   |    2 -
 drivers/ide/pci/piix.c                      |    2 -
 drivers/ide/pci/scc_pata.c                  |    2 -
 drivers/ide/pci/siimage.c                   |    2 -
 drivers/input/tablet/wacom_sys.c            |    4 +
 drivers/input/touchscreen/mk712.c           |    2 -
 drivers/media/radio/radio-aimslab.c         |    2 -
 drivers/media/radio/radio-cadet.c           |    2 -
 drivers/media/radio/radio-gemtek.c          |    2 -
 drivers/media/radio/radio-rtrack2.c         |    2 -
 drivers/media/radio/radio-sf16fmi.c         |    2 -
 drivers/media/video/cpia2/cpia2_core.c      |    2 -
 drivers/media/video/cpia2/cpia2_usb.c       |    2 -
 drivers/media/video/cpia2/cpia2_v4l.c       |    2 -
 drivers/media/video/cx23885/cx23885-video.c |    4 -
 drivers/media/video/pms.c                   |    4 +
 drivers/media/video/saa5246a.c              |    2 -
 drivers/media/video/saa5249.c               |    2 -
 drivers/media/video/v4l2-common.c           |    2 -
 drivers/media/video/v4l2-dev.c              |    2 -
 drivers/media/video/v4l2-ioctl.c            |    2 -
 drivers/message/fusion/mptlan.c             |  108 ---------------------------
 drivers/message/fusion/mptsas.c             |    5 +
 drivers/message/i2o/exec-osm.c              |    2 -
 drivers/message/i2o/i2o_config.c            |    2 -
 drivers/message/i2o/iop.c                   |    2 -
 drivers/message/i2o/pci.c                   |    2 -
 drivers/mtd/chips/map_rom.c                 |    8 ++
 drivers/mtd/maps/pci.c                      |   16 +---
 drivers/net/3c501.c                         |   12 ++-
 drivers/net/3c515.c                         |    2 -
 drivers/net/appletalk/cops.c                |    2 -
 drivers/net/eexpress.c                      |    2 -
 drivers/net/ibmlana.c                       |    2 -
 drivers/net/macmace.c                       |    2 -
 drivers/net/pcmcia/3c589_cs.c               |    2 -
 drivers/net/pcmcia/Kconfig                  |    2 -
 drivers/net/pcmcia/nmclan_cs.c              |    2 -
 drivers/net/tlan.c                          |    3 +
 drivers/net/tokenring/smctr.c               |    2 -
 drivers/net/tulip/dmfe.c                    |    4 +
 drivers/net/via-velocity.c                  |    2 -
 drivers/net/wan/z85230.c                    |    3 +
 drivers/net/wan/z85230.h                    |    2 -
 drivers/net/wireless/airo_cs.c              |    2 -
 drivers/net/wireless/atmel_cs.c             |    2 -
 drivers/net/wireless/netwave_cs.c           |    2 -
 drivers/net/wireless/orinoco_cs.c           |    2 -
 drivers/net/wireless/ray_cs.c               |    2 -
 drivers/net/wireless/spectrum_cs.c          |    2 -
 drivers/net/wireless/wavelan.c              |    2 -
 drivers/net/wireless/wavelan.p.h            |    2 -
 drivers/net/wireless/wavelan_cs.c           |    2 -
 drivers/net/wireless/wl3501_cs.c            |    2 -
 drivers/parisc/lasi.c                       |    2 -
 drivers/parport/parport_cs.c                |    2 -
 drivers/parport/share.c                     |   13 +++
 drivers/pci/rom.c                           |    6 +-
 drivers/pcmcia/pcmcia_resource.c            |    3 +
 drivers/pnp/pnpbios/core.c                  |    2 -
 drivers/scsi/NCR5380.c                      |    2 -
 drivers/scsi/a100u2w.c                      |    2 -
 drivers/scsi/aacraid/aachba.c               |    2 -
 drivers/scsi/aacraid/commctrl.c             |    2 -
 drivers/scsi/aacraid/comminit.c             |    2 -
 drivers/scsi/aacraid/commsup.c              |    2 -
 drivers/scsi/aacraid/dpcsup.c               |    2 -
 drivers/scsi/aacraid/linit.c                |    2 -
 drivers/scsi/aacraid/rkt.c                  |    2 -
 drivers/scsi/aacraid/rx.c                   |    2 -
 drivers/scsi/aacraid/sa.c                   |    2 -
 drivers/scsi/aha1740.c                      |    2 -
 drivers/scsi/aic7xxx/aic79xx_core.c         |    2 -
 drivers/scsi/aic7xxx/aic79xx_pci.c          |    8 +-
 drivers/scsi/atp870u.c                      |    4 +
 drivers/scsi/eata_pio.c                     |    4 +
 drivers/scsi/fdomain.c                      |    4 +
 drivers/scsi/ibmmca.c                       |    2 -
 drivers/scsi/in2000.c                       |    2 -
 drivers/scsi/initio.c                       |    2 -
 drivers/scsi/initio.h                       |    2 -
 drivers/scsi/ipr.h                          |    2 -
 drivers/scsi/qla2xxx/qla_init.c             |   20 +----
 drivers/scsi/qlogicfas408.c                 |    2 -
 drivers/scsi/sym53c416.c                    |    2 -
 drivers/scsi/wd7000.c                       |    4 +
 drivers/serial/8250_pci.c                   |    4 +
 drivers/telephony/phonedev.c                |    2 -
 drivers/usb/class/cdc-acm.c                 |    3 +
 drivers/usb/gadget/pxa27x_udc.c             |    4 +
 drivers/usb/serial/ftdi_sio.c               |    6 +-
 drivers/usb/serial/ir-usb.c                 |    2 -
 drivers/video/sstfb.c                       |    2 -
 drivers/watchdog/acquirewdt.c               |    6 +-
 drivers/watchdog/advantechwdt.c             |    6 +-
 drivers/watchdog/bfin_wdt.c                 |    2 -
 drivers/watchdog/eurotechwdt.c              |    4 +
 drivers/watchdog/ib700wdt.c                 |    8 +-
 drivers/watchdog/indydog.c                  |    2 -
 drivers/watchdog/mpcore_wdt.c               |    4 +
 drivers/watchdog/omap_wdt.c                 |    2 -
 drivers/watchdog/pcwd_pci.c                 |    2 -
 drivers/watchdog/pcwd_usb.c                 |    2 -
 drivers/watchdog/rc32434_wdt.c              |    3 +
 drivers/watchdog/s3c2410_wdt.c              |    2 -
 drivers/watchdog/sa1100_wdt.c               |    2 -
 drivers/watchdog/sb_wdog.c                  |    4 +
 drivers/watchdog/sbc8360.c                  |    6 +-
 drivers/watchdog/sbc_epx_c3.c               |    2 -
 drivers/watchdog/smsc37b787_wdt.c           |    2 -
 drivers/watchdog/softdog.c                  |    3 -
 drivers/watchdog/w83627hf_wdt.c             |    6 +-
 drivers/watchdog/w83697hf_wdt.c             |    4 +
 drivers/watchdog/wafer5823wdt.c             |    4 +
 drivers/watchdog/wdt.c                      |    4 +
 drivers/watchdog/wdt285.c                   |    3 +
 drivers/watchdog/wdt_pci.c                  |    4 +
 fs/coda/psdev.c                             |    2 -
 fs/hfsplus/inode.c                          |    2 +
 fs/nfs/inode.c                              |    2 -
 fs/nfs/super.c                              |    2 -
 fs/proc/array.c                             |    2 -
 include/asm-x86/apicdef.h                   |    2 -
 include/asm-x86/ipi.h                       |    2 -
 include/linux/if_ether.h                    |    2 -
 include/linux/if_fddi.h                     |    2 -
 include/linux/if_hippi.h                    |    2 -
 include/linux/igmp.h                        |    2 -
 include/linux/netdevice.h                   |    2 -
 include/linux/notifier.h                    |    2 -
 include/linux/parport.h                     |    4 +
 include/linux/pci.h                         |    2 +
 include/linux/smp.h                         |    2 -
 include/linux/telephony.h                   |    2 -
 ipc/sem.c                                   |    2 -
 mm/mmap.c                                   |    2 -
 mm/mprotect.c                               |    2 -
 mm/mremap.c                                 |    2 -
 net/802/psnap.c                             |    2 -
 net/appletalk/ddp.c                         |    4 +
 net/core/datagram.c                         |    2 -
 net/core/dev_mcast.c                        |    2 -
 net/core/skbuff.c                           |    2 -
 net/core/stream.c                           |    2 -
 net/ipv4/icmp.c                             |    2 -
 net/ipv4/igmp.c                             |    2 -
 net/ipv4/ip_fragment.c                      |    2 -
 net/ipv4/ip_input.c                         |    2 -
 net/ipv4/ipip.c                             |    2 -
 net/ipv4/ipmr.c                             |    2 -
 net/ipv4/udp.c                              |    2 -
 net/netlink/af_netlink.c                    |    2 -
 net/sunrpc/xprtsock.c                       |    4 +
 net/unix/af_unix.c                          |    2 -
 sound/oss/kahlua.c                          |    2 -
 sound/pci/cs5530.c                          |    2 -
 sound/sound_core.c                          |    2 -
 236 files changed, 318 insertions(+), 419 deletions(-)

-- 
Signature
