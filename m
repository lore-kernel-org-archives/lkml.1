Return-Path: <linux-kernel-owner+w=401wt.eu-S934728AbYBHUfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728AbYBHUfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932740AbYBHUfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:35:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39611 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbYBHUfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:35:00 -0500
Date: Fri, 8 Feb 2008 12:32:14 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.15
Message-ID: <20080208203214.GA4520@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.15
kernel.

It contains a number of bugfixes all over the place, and all users of
the 2.6.23 series are encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.23.14 and 2.6.23.15

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                           |    2 
 arch/i386/kernel/apm.c             |   10 
 arch/ia64/kernel/unaligned.c       |   11 
 arch/sparc64/kernel/chmc.c         |   16 
 arch/sparc64/kernel/entry.S        |   12 
 arch/sparc64/kernel/pci.c          |   16 
 arch/sparc64/kernel/smp.c          |   19 
 arch/sparc64/mm/init.c             |   29 -
 drivers/acpi/blacklist.c           |  388 +++++++++++++++++++
 drivers/acpi/bus.c                 |    7 
 drivers/acpi/dispatcher/dsobject.c |   91 ++++
 drivers/acpi/events/evregion.c     |    8 
 drivers/acpi/osl.c                 |  173 ++++++--
 drivers/acpi/pci_irq.c             |    9 
 drivers/acpi/video.c               |    4 
 drivers/ata/libata-core.c          |   52 +-
 drivers/ata/sata_promise.c         |   87 ++++
 drivers/atm/nicstar.c              |   19 
 drivers/char/apm-emulation.c       |   15 
 drivers/char/drm/drm_vm.c          |    2 
 drivers/char/mspec.c               |    2 
 drivers/char/tty_ioctl.c           |    2 
 drivers/connector/cn_queue.c       |    2 
 drivers/crypto/padlock-aes.c       |   53 ++
 drivers/firmware/dmi-id.c          |    2 
 drivers/input/evdev.c              |  716 +++++++++++++++++++++++------------
 drivers/input/input.c              |  666 ++++++++++++++++++++++++---------
 drivers/input/joydev.c             |  746 ++++++++++++++++++++++++-------------
 drivers/input/mousedev.c           |  743 +++++++++++++++++++++++-------------
 drivers/input/tsdev.c              |  391 +++++++++++++------
 drivers/isdn/capi/capidrv.c        |    9 
 drivers/md/dm-crypt.c              |   31 -
 drivers/md/dm-ioctl.c              |   10 
 drivers/md/dm-table.c              |    7 
 drivers/md/dm.c                    |   24 -
 drivers/md/dm.h                    |    5 
 drivers/md/raid5.c                 |    6 
 drivers/misc/thinkpad_acpi.c       |    4 
 drivers/net/atl1/atl1_main.c       |    8 
 drivers/net/cassini.c              |   45 --
 drivers/net/cassini.h              |   18 
 drivers/net/chelsio/cxgb2.c        |   66 ++-
 drivers/net/chelsio/pm3393.c       |  112 ++---
 drivers/net/chelsio/sge.c          |   40 -
 drivers/net/chelsio/sge.h          |    3 
 drivers/net/forcedeth.c            |   16 
 drivers/net/sky2.c                 |   15 
 drivers/net/usb/kaweth.c           |    2 
 drivers/net/usb/mcs7830.c          |    4 
 drivers/pci/hotplug/fakephp.c      |   39 +
 drivers/pci/quirks.c               |    6 
 drivers/spi/omap2_mcspi.c          |    6 
 drivers/usb/serial/sierra.c        |    4 
 fs/cifs/inode.c                    |    1 
 fs/exec.c                          |    6 
 fs/ncpfs/mmap.c                    |    4 
 fs/nfsd/nfs3xdr.c                  |    5 
 fs/nfsd/nfsxdr.c                   |    5 
 fs/splice.c                        |    8 
 include/asm-m68k/Kbuild            |    1 
 include/asm-powerpc/systbl.h       |    2 
 include/asm-sparc64/dma-mapping.h  |   12 
 include/asm-sparc64/hypervisor.h   |    4 
 include/asm-sparc64/pci.h          |    4 
 include/linux/acpi.h               |    7 
 include/linux/dmi.h                |    2 
 include/linux/freezer.h            |   23 +
 include/linux/input.h              |  112 +++++
 include/linux/pci_ids.h            |    2 
 include/linux/pm.h                 |    9 
 include/linux/pm_legacy.h          |    6 
 include/linux/quicklist.h          |    8 
 kernel/kmod.c                      |   13 
 kernel/power/main.c                |    3 
 kernel/power/pm.c                  |    4 
 kernel/relay.c                     |    1 
 kernel/time/tick-broadcast.c       |   56 +-
 mm/mmap.c                          |   14 
 mm/quicklist.c                     |   12 
 mm/truncate.c                      |    4 
 net/8021q/vlan.c                   |    2 
 net/atm/mpc.c                      |    7 
 net/ax25/ax25_in.c                 |    2 
 net/bridge/br_netfilter.c          |   45 +-
 net/ipv4/devinet.c                 |    2 
 net/ipv4/ip_gre.c                  |    2 
 net/ipv4/raw.c                     |    4 
 net/ipv4/route.c                   |    8 
 net/irda/af_irda.c                 |    2 
 net/key/af_key.c                   |   14 
 net/netrom/nr_dev.c                |    2 
 net/x25/x25_forward.c              |    5 
 net/xfrm/xfrm_policy.c             |    9 
 sound/oss/via82cxxx_audio.c        |   14 
 sound/usb/usx2y/usX2Yhwdep.c       |    2 
 sound/usb/usx2y/usx2yhwdeppcm.c    |    2 
 96 files changed, 3689 insertions(+), 1534 deletions(-)

Summary of changes from v2.6.23.14 to v2.6.23.15
================================================

Al Viro (1):
      CASSINI: Fix endianness bug.

Alan Cox (1):
      ACPI: Not register gsi for PCI IDE controller in legacy mode

Ayaz Abdulla (1):
      forcedeth: mac address mcp77/79

Björn Steinbrink (1):
      Fix dirty page accounting leak with ext3 data=journal

Bob Moore (2):
      ACPICA: fix acpi-cpufreq boot crash due to _PSD return-by-reference
      ACPICA: fix acpi_serialize hang regression

Chas Williams (1):
      ATM: [nicstar] delay irq setup until card is configured

Christoph Lameter (2):
      quicklists: do not release off node pages early
      quicklists: Only consider memory that can be used with GFP_KERNEL

Cory T. Tusar (1):
      tty: fix logic change introduced by wait_event_interruptible_timeout()

Dan Williams (1):
      md: fix data corruption when a degraded raid5 array is reshaped

David Miller (8):
      SPARC64: Fix sparc64 cpu cross call hangs.
      SPARC64: Fix memory controller register access when non-SMP.
      SPARC64: Fix two kernel linear mapping setup bugs.
      NET: Correct two mistaken skb_reset_mac_header() conversions.
      CASSINI: Revert 'dont touch page_count'.
      CASSINI: Set skb->truesize properly on receive packets.
      SPARC64: Fix OOPS in dma_sync_*_for_device()
      SPARC64: Implement pci_resource_to_user()

Divy Le Ray (3):
      chelsio: Fix skb->dev setting
      cxgb: fix T2 GSO
      cxgb: fix stats

Dmitry Torokhov (5):
      Input: implement proper locking in input core
      Input: evdev - implement proper locking
      Input: mousedev - implement proper locking
      Input: joydev - implement proper locking
      Input: tsdev - implement proper locking

Eric Dumazet (1):
      IPV4 ROUTE: ip_rt_dump() is unecessary slow

Eric Paris (2):
      VM/Security: add security hook to do_brk (CVE-2007-6434)
      security: protect from stack expantion into low vm addresses

Greg Kroah-Hartman (2):
      USB: update sierra.c with latest device ids that are in 2.6.24-rc7
      Linux 2.6.23.15

Henrique de Moraes Holschuh (1):
      ACPI: thinkpad-acpi: fix lenovo keymap for brightness

Herbert Xu (5):
      IPSEC: Fix potential dst leak in xfrm_lookup
      IPV4 raw: Strengthen check on validity of iph->ihl
      ATM: Check IP header validity in mpc_send_packet
      IPSEC: Avoid undefined shift operation when testing algorithm ID
      CRYPTO: padlock: Fix spurious ECB page fault

Ian Abbott (1):
      PCI: Fix fakephp deadlock

Ingo Molnar (1):
      vfs: coredumping fix (CVE-2007-6206)

Jay Cliburn (1):
      atl1: fix frame length bug

Jens Axboe (1):
      splice: missing user pointer access verification (CVE-2008-0009/10)

Julia Lawall (1):
      X25: Add missing x25_neigh_put

Jun'ichi Nomura (1):
      dm: table detect io beyond device

Kalle Valo (1):
      spi: omap2_mcspi PIO RX fix

Karsten Keil (1):
      fix oops on rmmod capidrv

Len Brown (2):
      PM: ACPI and APM must not be enabled at the same time
      ACPI: sync blacklist w/ latest

Li Zefan (1):
      CONNECTOR: Don't touch queue dev after decrement of ref count.

Mark McLoughlin (1):
      INET: Fix netdev renaming and inet address labels

Matthew Wilcox (1):
      m68k: Export cachectl.h

Mikael Pettersson (1):
      sata_promise: ASIC PRD table bug workaround

Milan Broz (2):
      dm crypt: fix write endio
      dm crypt: use bio_add_page

NeilBrown (1):
      knfsd: Allow NFSv2/3 WRITE calls to succeed when krb5i etc is used.

Nick Piggin (1):
      vm audit: add VM_DONTEXPAND to mmap for drivers that need it (CVE-2008-0007)

Nigel Cunningham (1):
      Fix unbalanced helper_lock in kernel/kmod.c

Oliver Neukum (1):
      Input: fix open count handling in input interfaces

Patrick Mansfield (1):
      POWERPC: Change fallocate to match unistd.h on powerpc

Patrick McHardy (2):
      Netfilter: bridge: fix double POST_ROUTING invocation
      Netfilter: bridge-netfilter: fix net_device refcnt leaks

Pavel Emelyanov (1):
      VLAN: Lost rtnl_unlock() in vlan_ioctl()

Rafael J. Wysocki (1):
      Freezer: Fix APM emulation breakage

Russ Dill (2):
      NET: mcs7830 passes msecs instead of jiffies to usb_control_msg
      NET: kaweth was forgotten in msec switchover of usb_start_wait_urb

Stephen Hemminger (2):
      sky2: disable rx checksum on Yukon XL
      sky2: RX lockup fix

Steve French (1):
      CIFS: Respect umask when using POSIX mkdir

Tejun Heo (1):
      libata: port and host should be stopped before hardware resources are released

Thomas Gleixner (1):
      clockevents: fix reprogramming decision in oneshot broadcast

Timo Teras (1):
      IPV4: ip_gre: set mac_header correctly in receive path

Tony Luck (1):
      ia64: Fix unaligned handler for floating point instructions with base update

William Lee Irwin III (1):
      ACPI: video_device_list corruption

Zhao Yakui (1):
      ACPI: apply quirk_ich6_lpc_acpi to more ICH8 and ICH9

maximilian attems (1):
      IRDA: irda_create() nuke user triggable printk

