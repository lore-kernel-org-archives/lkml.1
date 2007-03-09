Return-Path: <linux-kernel-owner+w=401wt.eu-S1767505AbXCITPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767505AbXCITPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767504AbXCITPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:15:07 -0500
Received: from ns.suse.de ([195.135.220.2]:38658 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbXCITPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:15:01 -0500
Date: Fri, 9 Mar 2007 11:13:17 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, torvalds@osdl.org, stable@kernel.org
Subject: Linux 2.6.20.2
Message-ID: <20070309191317.GA4982@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.20.2 kernel.
It contains a metric buttload of bugfixes and security updates, so all
2.6.20 users are recommended to upgrade.

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.20.1 and 2.6.20.2.

The updated 2.6.20.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,

greg k-h
--------

 Makefile                                       |    2 
 arch/i386/kernel/cpu/mtrr/if.c                 |   33 +++++++-----
 arch/i386/kernel/signal.c                      |    6 +-
 arch/i386/kernel/sysenter.c                    |    2 
 arch/ia64/Kconfig                              |    1 
 arch/ia64/kernel/crash.c                       |   11 ++--
 arch/ia64/kernel/machine_kexec.c               |    2 
 arch/m32r/kernel/process.c                     |    2 
 arch/m32r/kernel/signal.c                      |   26 +--------
 arch/powerpc/kernel/head_64.S                  |    2 
 arch/ppc/kernel/ppc_ksyms.c                    |    2 
 arch/sparc64/kernel/of_device.c                |   40 ++++++++++++++-
 arch/um/os-Linux/sigio.c                       |   38 +++++++-------
 arch/x86_64/ia32/ia32_signal.c                 |    7 ++
 arch/x86_64/ia32/ptrace32.c                    |    1 
 arch/x86_64/kernel/irq.c                       |   12 +++-
 block/ll_rw_blk.c                              |    2 
 drivers/Makefile                               |    2 
 drivers/ata/ahci.c                             |   14 +++++
 drivers/ata/ata_generic.c                      |    4 +
 drivers/ata/ata_piix.c                         |    4 +
 drivers/ata/pata_ali.c                         |    6 ++
 drivers/ata/pata_amd.c                         |   10 +++
 drivers/ata/pata_atiixp.c                      |    4 +
 drivers/ata/pata_cmd64x.c                      |    6 ++
 drivers/ata/pata_cs5520.c                      |    7 ++
 drivers/ata/pata_cs5530.c                      |    6 ++
 drivers/ata/pata_cs5535.c                      |    4 +
 drivers/ata/pata_cypress.c                     |    4 +
 drivers/ata/pata_efar.c                        |    4 +
 drivers/ata/pata_hpt366.c                      |    7 ++
 drivers/ata/pata_hpt3x3.c                      |    6 ++
 drivers/ata/pata_it821x.c                      |    6 ++
 drivers/ata/pata_jmicron.c                     |    8 +++
 drivers/ata/pata_marvell.c                     |    4 +
 drivers/ata/pata_mpiix.c                       |    4 +
 drivers/ata/pata_netcell.c                     |    4 +
 drivers/ata/pata_ns87410.c                     |    4 +
 drivers/ata/pata_oldpiix.c                     |    4 +
 drivers/ata/pata_opti.c                        |    4 +
 drivers/ata/pata_optidma.c                     |    4 +
 drivers/ata/pata_pdc202xx_old.c                |    4 +
 drivers/ata/pata_radisys.c                     |    4 +
 drivers/ata/pata_rz1000.c                      |    6 ++
 drivers/ata/pata_sc1200.c                      |    4 +
 drivers/ata/pata_serverworks.c                 |    6 ++
 drivers/ata/pata_sil680.c                      |    8 +++
 drivers/ata/pata_sis.c                         |    4 +
 drivers/ata/pata_triflex.c                     |    4 +
 drivers/ata/pata_via.c                         |    6 ++
 drivers/ata/sata_sil.c                         |   10 +++
 drivers/ata/sata_sil24.c                       |    2 
 drivers/block/pktcdvd.c                        |    2 
 drivers/char/agp/intel-agp.c                   |   14 +++--
 drivers/char/pcmcia/cm4040_cs.c                |    3 -
 drivers/char/specialix.c                       |    2 
 drivers/char/tty_io.c                          |   14 +++++
 drivers/hid/hid-core.c                         |    5 -
 drivers/ide/ide-iops.c                         |    2 
 drivers/ieee1394/nodemgr.c                     |   24 ++++++---
 drivers/ieee1394/video1394.c                   |    8 +++
 drivers/input/mouse/psmouse-base.c             |   28 ++++++++++
 drivers/input/mouse/psmouse.h                  |    1 
 drivers/input/mouse/synaptics.c                |    1 
 drivers/kvm/kvm.h                              |    2 
 drivers/macintosh/Kconfig                      |    2 
 drivers/md/bitmap.c                            |   22 +++++++-
 drivers/md/raid10.c                            |   38 +++++++-------
 drivers/md/raid5.c                             |   42 ++++++++++++++-
 drivers/media/dvb/dvb-core/dvbdev.c            |   13 ++++
 drivers/media/dvb/dvb-usb/cxusb.c              |    4 -
 drivers/media/dvb/dvb-usb/digitv.c             |    2 
 drivers/media/video/cx25840/cx25840-core.c     |    4 -
 drivers/media/video/cx25840/cx25840-firmware.c |    2 
 drivers/media/video/cx88/cx88-blackbird.c      |   14 +++--
 drivers/media/video/cx88/cx88.h                |    1 
 drivers/media/video/pvrusb2/pvrusb2-encoder.c  |   40 +++++++++++++++
 drivers/media/video/pvrusb2/pvrusb2-hdw.c      |   33 ++++++------
 drivers/mmc/sdhci.c                            |   22 +++++++-
 drivers/mtd/redboot.c                          |   19 +++++--
 drivers/net/forcedeth.c                        |    2 
 drivers/net/sky2.c                             |    6 --
 drivers/net/sky2.h                             |    2 
 drivers/net/tulip/dmfe.c                       |    9 ---
 drivers/net/wireless/bcm43xx/bcm43xx.h         |    2 
 drivers/net/wireless/bcm43xx/bcm43xx_main.c    |   19 +++----
 drivers/net/wireless/bcm43xx/bcm43xx_xmit.h    |   10 ---
 drivers/net/wireless/prism54/isl_ioctl.c       |    8 ++-
 drivers/rtc/rtc-pcf8563.c                      |   40 ++++++++++++---
 drivers/sbus/char/bbc_i2c.c                    |   17 +++---
 drivers/usb/atm/ueagle-atm.c                   |    1 
 drivers/usb/core/hub.c                         |    6 ++
 drivers/usb/host/ehci-hcd.c                    |   16 ++++++
 drivers/usb/host/uhci-hub.c                    |   11 ++--
 drivers/usb/input/hid-core.c                   |    4 -
 drivers/usb/misc/appledisplay.c                |    4 -
 drivers/usb/net/usbnet.c                       |    7 +-
 drivers/video/aty/mach64_ct.c                  |    3 -
 fs/9p/vfs_inode.c                              |    7 --
 fs/binfmt_elf.c                                |    3 -
 fs/buffer.c                                    |    1 
 fs/ext2/super.c                                |    4 +
 fs/ext3/super.c                                |    4 +
 fs/ext4/super.c                                |    4 +
 fs/gfs2/quota.c                                |    2 
 fs/hugetlbfs/inode.c                           |    5 +
 fs/lockd/clntproc.c                            |    9 +--
 fs/lockd/svclock.c                             |    4 -
 fs/ocfs2/journal.h                             |    4 -
 fs/ufs/dir.c                                   |   21 ++++---
 fs/ufs/super.c                                 |    5 +
 include/asm-generic/page.h                     |   38 +-------------
 include/asm-ia64/libata-portmap.h              |   12 ++++
 include/asm-x86_64/bitops.h                    |    2 
 include/linux/atmarp.h                         |    2 
 include/linux/binfmts.h                        |    1 
 include/linux/lockdep.h                        |    2 
 include/linux/pci_ids.h                        |    1 
 include/linux/raid/bitmap.h                    |    1 
 include/linux/sunrpc/svcsock.h                 |    2 
 include/linux/ufs_fs.h                         |    1 
 include/linux/writeback.h                      |    2 
 kernel/lockdep.c                               |    2 
 kernel/power/user.c                            |   19 ++++---
 kernel/sched.c                                 |    4 -
 kernel/time/clocksource.c                      |    1 
 lib/Kconfig.debug                              |    4 -
 lib/swiotlb.c                                  |    2 
 mm/hugetlb.c                                   |    2 
 mm/page-writeback.c                            |   13 ++++
 mm/vmscan.c                                    |    2 
 net/atm/common.c                               |    3 -
 net/ipv4/igmp.c                                |    2 
 net/ipv4/netfilter/ipt_REJECT.c                |    4 +
 net/ipv4/tcp.c                                 |   24 ++++-----
 net/ipv4/tcp_minisocks.c                       |    2 
 net/ipv4/tcp_output.c                          |    7 +-
 net/ipv4/xfrm4_mode_tunnel.c                   |    1 
 net/ipv6/addrconf.c                            |    2 
 net/ipv6/anycast.c                             |    1 
 net/ipv6/inet6_hashtables.c                    |    2 
 net/ipv6/ipv6_sockglue.c                       |   10 ++-
 net/ipv6/mcast.c                               |    2 
 net/ipx/af_ipx.c                               |   24 ++++++---
 net/key/af_key.c                               |   11 ++--
 net/netfilter/nfnetlink_log.c                  |   15 ++++-
 net/sunrpc/pmap_clnt.c                         |    8 +--
 net/sunrpc/svc.c                               |   29 +++++-----
 net/sunrpc/svcsock.c                           |   66 +++++++++++++++++++------
 net/xfrm/xfrm_policy.c                         |    7 ++
 net/xfrm/xfrm_user.c                           |   18 +++---
 security/keys/key.c                            |   33 +++++-------
 sound/pci/hda/hda_intel.c                      |    2 
 sound/usb/usbaudio.c                           |   51 ++++++++++++-------
 154 files changed, 1006 insertions(+), 412 deletions(-)


Summary of changes from v2.6.20.1 to v2.6.20.2
==============================================


Adrian Bunk (1):
      v9fs_vfs_mkdir(): fix a double free

Alan Stern (3):
      USB: fix concurrent buffer access in the hub driver
      EHCI: turn off remote wakeup during shutdown
      UHCI: fix port resume problem

Alexey Dobriyan (1):
      Fix allocation failure handling in multicast

Andi Kleen (2):
      x86_64: Fix wrong gcc check in bitops.h
      x86: Don't require the vDSO for handling a.out signals

Andrew Morton (2):
      throttle_vm_writeout(): don't loop on GFP_NOFS and GFP_NOIO allocations
      revert "drivers/net/tulip/dmfe: support basic carrier detection"

Aristeu Sergio Rozanski Filho (1):
      tty_io: fix race in master pty close/slave pty close path

Arnaldo Carvalho de Melo (2):
      Fix skb data reallocation handling in IPSEC
      TCP: Fix minisock tcp_create_openreq_child() typo.

Atsushi Nemoto (1):
      rtc-pcf8563: detect polarity of century bit automatically

Ayaz Abdulla (1):
      forcedeth: disable msix

Dan Williams (1):
      prism54: correct assignment of DOT1XENABLE in WE-19 codepaths

Daniel Walker (1):
      Fix ATM initcall ordering.

Darren Salt (1):
      mmc: Power quirk for ENE controllers

Dave Jones (1):
      AGP: intel-agp bugfix

David Brownell (1):
      USB: usbnet driver bugfix

David Howells (1):
      Keys: Fix key serial number collision handling

David Miller (7):
      Fix atmarp.h for userspace
      Fix oops in xfrm_audit_log()
      Fix interrupt probing on E450 sparc64 systems
      Fix xfrm_add_sa_expire() return value
      Fix %100 cpu spinning on sparc64
      Fix TCP MD5 locking.
      video/aty/mach64_ct.c: fix bogus delay loop

David Moore (2):
      Missing critical phys_to_virt in lib/swiotlb.c
      ieee1394: video1394: DMA fix

David S. Miller (1):
      IPV6: Handle np->opt being NULL in ipv6_getsockopt_sticky() [CVE-2007-1000]

David Stevens (1):
      Fix anycast procfs device leak

David Woodhouse (1):
      MTD: Fatal regression in drivers/mtd/redboot.c in 2.6.20

Eric W. Biederman (1):
      x86-64: survive having no irq mapping for a vector

Evgeniy Dushistov (1):
      ufs: restore back support of openstep

Gerhard Dirschl (1):
      pktcdvd: Correctly set cmd_len field in pkt_generic_packet

Greg Kroah-Hartman (1):
      Linux 2.6.20.2

Hans Verkuil (1):
      V4L: fix cx25840 firmware loading

Heiko Carstens (1):
      lockdep: forward declare struct task_struct

Herbert Xu (1):
      Clear TCP segmentation offload state in ipt_REJECT

Hirokazu Takata (1):
      m32r: build fix for processors without ISA_DSP_LEVEL2

Hugh Dickins (1):
      fix umask when noACL kernel meets extN tuned for ACLs

Ilpo Järvinen (1):
      Prevent pseudo garbage in SYN's advertized window

Ingo Molnar (1):
      sched: fix SMT scheduler bug

Jan Beulich (1):
      i386: Fix broken CONFIG_COMPAT_VDSO on i386

Jeff Dike (1):
      UML - Fix 2.6.20 hang

Jin-Bong lee (1):
      DVB: cxusb: fix firmware patch for big endian systems

Jiri Bohac (1):
      Fix IPX module unload

Jiri Kosina (1):
      HID: fix possible double-free on error path in hid parser

Jiri Slaby (1):
      Char: specialix, isr have 2 params

John Heffner (1):
      Fix TCP FIN handling

Josef Whiter (1):
      gfs2: fix locking mistake

Julien BLACHE (1):
      USB HID: Fix USB vendor and product IDs endianness for USB HID devices

Ken Chen (1):
      hugetlb: preserve hugetlb pte dirty state

Larry Finger (1):
      bcm43xx: Fix for oops on resume

Linus Torvalds (1):
      Revert "[PATCH] LOG2: Alter get_order() so that it can make use of ilog2() on a constant"

Livio Soares (1):
      POWERPC: Fix performance monitor exception

Magnus Damm (1):
      kexec: Fix CONFIG_SMP=n compilation V2 (ia64)

Marcel Holtmann (1):
      Fix buffer overflow in Omnikey CardMan 4040 driver (CVE-2007-0005)

Marcel Siegert (1):
      dvbdev: fix illegal re-usage of fileoperations struct

Mark Fasheh (1):
      ocfs2: ocfs2_link() journal credits update

Mathieu Desnoyers (1):
      kernel/time/clocksource.c needs struct task_struct on m68k

Michael Buesch (1):
      bcm43xx: Fix for oops on ampdu status

Michael Hanselmann (1):
      Fix null pointer dereference in appledisplay driver

Michael Krufky (2):
      DVB: digitv: open nxt6000 i2c_gate for TDED4 tuner handling
      V4L: cx88-blackbird: allow usage of 376836 and 262144 sized firmware images

Michal Wrobel (1):
      Don't add anycast reference to device multiple times

MichaÅ MirosÅaw (1):
      Fix reference counting (memory leak) problem in __nfulnl_send() and callers related to packet queueing.

Mike Isely (2):
      V4L: pvrusb2: Fix video corruption on stream start
      V4L: pvrusb2: Handle larger cx2341x firmware images

Neil Brown (3):
      Fix various bugs with aligned reads in RAID5.
      md: Avoid possible BUG_ON in md bitmap handling.
      export blk_recount_segments

NeilBrown (4):
      knfsd: Fix a race in closing NFSd connections.
      Avoid using nfsd process pools on SMP machines.
      Fix recently introduced problem with shutting down a busy NFS server.
      md: Fix raid10 recovery problem.

Nick Piggin (1):
      buffer: memorder fix

Paolo 'Blaisorblade' Giarrusso (2):
      x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted
      Kconfig: FAULT_INJECTION can be selected only if LOCKDEP is enabled.

Pavel Roskin (1):
      bcm43xx: Fix assertion failures in interrupt handler

Randy Dunlap (1):
      ueagle-atm.c needs sched.h

Rojhalat Ibrahim (1):
      Fix compile error for e500 core based processors

S.Caglar Onur (1):
      kvm: Fix asm constraint for lldt instruction

Sam Ravnborg (1):
      fix section mismatch warning in lockdep

Soeren Sonnenburg (1):
      enable mouse button 2+3 emulation for x86 macs

Stefan Richter (1):
      ieee1394: fix host device registering when nodemgr disabled

Stefan Seyfried (1):
      swsusp: Fix possible oops in userland interface

Stefano Brivio (1):
      bcm43xx: fix for 4309

Stephen Hemminger (2):
      sky2: dont flush good pause frames
      sky2: transmit timeout deadlock

Takashi Iwai (3):
      usbaudio - Fix Oops with broken usb descriptors
      usbaudio - Fix Oops with unconventional sample rates
      hda-intel - Don't try to probe invalid codecs

Tejun Heo (5):
      pata_amd: fix an obvious bug in cable detection
      ide: fix drive side 80c cable check
      sata_sil: ignore and clear spurious IRQs while executing commands by polling
      libata: add missing PM callbacks
      libata: add missing CONFIG_PM in LLDs

Thomas Gleixner (1):
      Fix posix-cpu-timer breakage caused by stale p->last_ran value

Thomas Renninger (1):
      Backport of psmouse suspend/shutdown cleanups

Trond Myklebust (2):
      RPM: fix double free in portmapper code
      NLM: Fix double free in __nlm_async_call

YOSHIFUJI Hideaki (1):
      IPV6: HASHTABLES: Use appropriate seed for caluculating ehash index.

Zhang, Yanmin (1):
      ATA: convert GSI to irq on ia64

Zwane Mwaikambo (1):
      Fix MTRR compat ioctl

