Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbXFKUOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbXFKUOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbXFKUOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:14:36 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:39939 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbXFKUOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:14:35 -0400
Date: Mon, 11 Jun 2007 13:14:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.21.5
Message-ID: <20070611201418.GA3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.21.5 kernel.
This has a variety of important fixes, see below for the summary.

I'll also be replying to this message with a copy of the patch between
2.6.21.4 and 2.6.21.5

The updated 2.6.21.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.21.y.git;a=summary

thanks,
-chris

---------

 Documentation/hrtimer/timer_stats.txt        |    7 -
 Makefile                                     |    2 
 arch/i386/kernel/hpet.c                      |   24 ++++-
 arch/i386/kernel/reboot.c                    |    8 +
 arch/i386/oprofile/nmi_int.c                 |   17 +++
 arch/sparc64/kernel/head.S                   |   29 +++++-
 arch/sparc64/kernel/itlb_miss.S              |    4 
 arch/sparc64/kernel/pci_sun4v.c              |   36 ++-----
 arch/sparc64/mm/init.c                       |    7 +
 arch/um/os-Linux/start_up.c                  |   24 +++--
 arch/x86_64/mm/init.c                        |    6 +
 drivers/acpi/numa.c                          |    8 -
 drivers/ata/ahci.c                           |   10 +-
 drivers/block/cciss.c                        |   45 ++++++---
 drivers/char/cyclades.c                      |    1 
 drivers/char/n_tty.c                         |    1 
 drivers/char/tty_io.c                        |    3 
 drivers/ide/pci/hpt366.c                     |    7 +
 drivers/ieee1394/eth1394.c                   |    7 -
 drivers/input/serio/i8042.c                  |   35 ++++++-
 drivers/md/bitmap.c                          |   17 ++-
 drivers/md/raid0.c                           |    3 
 drivers/media/dvb/ttpci/budget-ci.c          |    2 
 drivers/net/e1000/e1000_main.c               |   11 +-
 drivers/net/tg3.c                            |    5 -
 drivers/net/wireless/zd1211rw/zd_chip.c      |    5 -
 drivers/net/wireless/zd1211rw/zd_rf.c        |    2 
 drivers/net/wireless/zd1211rw/zd_rf.h        |    2 
 drivers/net/wireless/zd1211rw/zd_rf_al2230.c |   89 +++++++++++++++---
 drivers/pci/quirks.c                         |    1 
 drivers/scsi/aacraid/aacraid.h               |    1 
 drivers/scsi/aacraid/rx.c                    |    2 
 drivers/scsi/aacraid/sa.c                    |    3 
 drivers/serial/suncore.c                     |    6 -
 drivers/usb/core/message.c                   |    9 -
 drivers/video/neofb.c                        |   30 +++---
 fs/compat_ioctl.c                            |   33 +++++--
 fs/fuse/dir.c                                |    2 
 fs/ntfs/inode.c                              |    2 
 include/acpi/acpi_numa.h                     |    7 -
 include/asm-sparc64/tsb.h                    |    2 
 include/linux/bootmem.h                      |    1 
 include/linux/mii.h                          |    4 
 include/linux/pci_ids.h                      |    5 -
 include/linux/raid/bitmap.h                  |    1 
 include/linux/workqueue.h                    |    2 
 include/net/af_unix.h                        |    8 -
 kernel/sched.c                               |    4 
 kernel/time/tick-broadcast.c                 |   17 ++-
 kernel/time/tick-sched.c                     |   12 +-
 kernel/time/timer_stats.c                    |   44 +++++----
 lib/Kconfig.debug                            |    5 -
 mm/sparse.c                                  |   11 ++
 net/bluetooth/hci_sock.c                     |    6 -
 net/core/dev.c                               |   10 +-
 net/core/net-sysfs.c                         |    8 +
 net/core/sock.c                              |   14 ++
 net/core/utils.c                             |    6 -
 net/ipv4/Kconfig                             |    6 -
 net/ipv4/icmp.c                              |   12 +-
 net/ipv4/inet_connection_sock.c              |    4 
 net/ipv4/tcp.c                               |    3 
 net/ipv4/xfrm4_input.c                       |    6 -
 net/ipv4/xfrm4_mode_tunnel.c                 |    2 
 net/ipv6/ip6_fib.c                           |    8 -
 net/ipv6/xfrm6_input.c                       |    6 -
 net/ipv6/xfrm6_mode_tunnel.c                 |    1 
 net/unix/af_unix.c                           |  127 +++++++++++++++++----------
 sound/pci/hda/hda_intel.c                    |   25 ++++-
 sound/soc/codecs/wm8750.c                    |    2 
 sound/usb/usbquirks.h                        |   23 ++++
 71 files changed, 610 insertions(+), 288 deletions(-)

Summary of changes from v2.6.21.4 to v2.6.21.5
==============================================

Aaron Durbin (1):
      acpi: fix potential call to a freed memory section.

Alan Stern (1):
      USB: set the correct Interrupt interval in usb_bulk_msg

Andi Kleen (1):
      i386: Fix K8/core2 oprofile on multiple CPUs

Andrew Morton (2):
      ntfs_init_locked_inode(): fix array indexing
      ALSA: wm8750 typo fix

Antonino A. Daplas (1):
      neofb: Fix pseudo_palette array overrun in neofb_setcolreg

Auke Kok (1):
      e1000: disable polling before registering netdevice

Björn Steinbrink (1):
      timer statistics: fix race

Chris Wright (2):
      x86: fix oprofile double free
      Linux 2.6.21.5

Daniel Drake (2):
      ALSA: usb-audio: explicitly match Logitech QuickCam
      zd1211rw: Add AL2230S RF support

Dave Jones (1):
      IPV4: Correct rp_filter help text.

David Miller (5):
      Fix AF_UNIX OOPS
      ICMP: Fix icmp_errors_use_inbound_ifaddr sysctl
      NET: Fix BMSR_100{HALF,FULL}2 defines in linux/mii.h
      SPARC64: Fix _PAGE_EXEC_4U check in sun4u I-TLB miss handler.
      SPARC64: Don't be picky about virtual-dma values on sun4v.

David S. Miller (1):
      SPARC64: Fix two bugs wrt. kernel 4MB TSB.

Gerald Britton (1):
      cciss: fix pci_driver.shutdown while device is still active

Hugh Dickins (1):
      fix compat console unimap regression

Ingo Molnar (1):
      timer stats: speedups

Jan Engelhardt (1):
      SPARC: Linux always started with 9600 8N1

Jason Gaston (1):
      pci_ids: update patch for Intel ICH9M

Jay Cliburn (1):
      PCI: quirk disable MSI on via vt3351

Jeff Dike (1):
      UML - Improve host PTRACE_SYSEMU check

Jerome Borsboom (1):
      NET: parse ip:port strings correctly in in4_pton

Jiri Slaby (1):
      Char: cyclades, fix deadlock

Kazunori MIYAZAWA (1):
      IPSEC: Fix panic when using inter address familiy IPsec on loopback.

Mark Glines (1):
      TCP: Use default 32768-61000 outgoing port range in all cases.

Michael Chan (1):
      TG3: Fix link problem on Dell's onboard 5906.

Miklos Szeredi (1):
      fuse: fix mknod of regular file

NeilBrown (2):
      md: Avoid overflow in raid0 calculation with large components.
      md: Don't write more than is required of the last page of a bitmap

Oleg Nesterov (2):
      make freezeable workqueues singlethread
      tty: fix leakage of -ERESTARTSYS to userland

Oliver Endriss (1):
      V4L/DVB (5593): Budget-ci: Fix tuning for TDM 1316 (160..200 MHz)

Roland Scheidegger (1):
      Input: i8042 - fix AUX port detection with some chips

Salyzyn, Mark (1):
      SCSI: aacraid: Correct sa platform support. (Was: [Bug 8469] Bad EIP value on pentium3 SMP kernel-2.6.21.1)

Satyam Sharma (1):
      BLUETOOTH: Fix locking in hci_sock_dev_event().

Sergei Shtylyov (1):
      hpt366: don't check enablebits for HPT36x

Stefan Richter (1):
      ieee1394: eth1394: bring back a parent device

Stephen Hemminger (1):
      NET: Fix race condition about network device name allocation.

Takashi Iwai (2):
      ALSA: hda-intel - Probe additional slots only if necessary
      ALSA: hda-intel - Fix detection of audio codec on Toshiba A100

Tejun Heo (1):
      ahci: disable 64bit dma on sb600

Thomas Gleixner (4):
      i386: HPET, check if the counter works
      Ignore bogus ACPI info for offline CPUs
      NOHZ: Rate limit the local softirq pending warning output
      Prevent going idle with softirq pending

Tim Gardner (1):
      Work around Dell E520 BIOS reboot bug

Vasily Averin (1):
      NET: "wrong timeout value" in sk_wait_data() v2

YOSHIFUJI Hideaki (1):
      IPV6 ROUTE: No longer handle ::/0 specially.

Zou Nan hai (1):
      x86_64: allocate sparsemem memmap above 4G

