Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbXHIVow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbXHIVow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXHIVoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:44:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44191 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbXHIVom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:44:42 -0400
Date: Thu, 9 Aug 2007 14:47:16 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.2
Message-ID: <20070809214716.GA31414@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.2 kernel.
This release has a lot of bugfixes and some security updates so all
users of the 2.6.22 series should update to it.

I'll also be replying to this message with a copy of the patch between
2.6.22.1 and 2.6.22.2

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                                       |    2 
 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c    |   13 --
 arch/i386/kernel/hpet.c                        |   24 +++
 arch/sparc/kernel/entry.S                      |   14 +-
 arch/sparc/lib/memset.S                        |    2 
 arch/sparc64/kernel/head.S                     |    1 
 arch/um/drivers/ubd_kern.c                     |    2 
 arch/um/os-Linux/user_syms.c                   |   20 +--
 block/cfq-iosched.c                            |   39 +++++-
 drivers/acpi/dock.c                            |    7 +
 drivers/ata/ata_piix.c                         |    2 
 drivers/ata/libata-core.c                      |    1 
 drivers/ata/libata-sff.c                       |    2 
 drivers/ata/pata_scc.c                         |    2 
 drivers/base/cpu.c                             |    2 
 drivers/char/drm/i915_dma.c                    |   14 +-
 drivers/char/drm/i915_drv.h                    |    1 
 drivers/char/sx.c                              |    4 
 drivers/firewire/fw-ohci.c                     |    2 
 drivers/firewire/fw-sbp2.c                     |    5 
 drivers/firewire/fw-transaction.c              |    4 
 drivers/firewire/fw-transaction.h              |    6 
 drivers/ieee1394/sbp2.c                        |    5 
 drivers/input/mouse/lifebook.c                 |    2 
 drivers/kvm/svm.c                              |    6 
 drivers/kvm/svm.h                              |    3 
 drivers/md/dm-crypt.c                          |    5 
 drivers/md/dm-exception-store.c                |   11 -
 drivers/md/dm-io.c                             |    5 
 drivers/md/dm-mpath.c                          |    3 
 drivers/md/dm-raid1.c                          |    4 
 drivers/md/dm-snap.c                           |   11 -
 drivers/md/dm.c                                |    9 +
 drivers/md/raid10.c                            |   10 +
 drivers/media/video/ivtv/ivtv-driver.c         |    1 
 drivers/media/video/ivtv/ivtv-driver.h         |    2 
 drivers/media/video/ivtv/ivtv-irq.c            |    7 -
 drivers/media/video/ivtv/ivtv-streams.c        |   30 ++--
 drivers/media/video/ivtv/ivtv-vbi.c            |   31 +---
 drivers/media/video/v4l2-common.c              |   19 ++
 drivers/media/video/wm8739.c                   |    2 
 drivers/media/video/wm8775.c                   |    2 
 drivers/misc/sony-laptop.c                     |   30 +++-
 drivers/net/forcedeth.c                        |  162 +++++++++++++++++++++++--
 drivers/pcmcia/cs.c                            |    3 
 drivers/scsi/aacraid/linit.c                   |    4 
 drivers/serial/sunhv.c                         |   30 ++++
 drivers/serial/sunsab.c                        |   19 ++
 drivers/serial/sunsu.c                         |   14 ++
 drivers/serial/sunzilog.c                      |   17 ++
 drivers/usb/class/cdc-acm.c                    |   12 +
 drivers/usb/core/hub.c                         |   10 -
 drivers/usb/serial/ftdi_sio.c                  |  104 ++++++----------
 drivers/usb/serial/io_edgeport.c               |   19 +-
 drivers/video/backlight/cr_bllcd.c             |    2 
 drivers/video/macmodes.c                       |    5 
 drivers/video/macmodes.h                       |    8 -
 fs/9p/conv.c                                   |    1 
 fs/ecryptfs/inode.c                            |    5 
 fs/ext4/extents.c                              |    2 
 fs/jbd/commit.c                                |    3 
 fs/jbd2/commit.c                               |    3 
 fs/nfsd/vfs.c                                  |    2 
 fs/splice.c                                    |    5 
 fs/sysfs/file.c                                |    1 
 fs/timerfd.c                                   |    6 
 include/linux/Kbuild                           |    1 
 include/linux/ioprio.h                         |    6 
 include/linux/netfilter_ipv4/ipt_iprange.h     |    2 
 include/net/bluetooth/rfcomm.h                 |    1 
 include/net/xfrm.h                             |    1 
 ipc/shm.c                                      |    2 
 kernel/futex.c                                 |    4 
 kernel/lockdep_proc.c                          |    2 
 kernel/time/timer_list.c                       |    2 
 kernel/time/timer_stats.c                      |    2 
 kernel/workqueue.c                             |   11 -
 mm/hugetlb.c                                   |   15 +-
 mm/mlock.c                                     |    5 
 mm/readahead.c                                 |   12 +
 net/bluetooth/rfcomm/tty.c                     |   34 ++++-
 net/bridge/netfilter/ebt_log.c                 |    6 
 net/bridge/netfilter/ebt_ulog.c                |    8 -
 net/core/gen_estimator.c                       |   82 +++++++-----
 net/core/netpoll.c                             |    2 
 net/ieee80211/softmac/ieee80211softmac_assoc.c |    5 
 net/ipv4/netfilter/ipt_LOG.c                   |    6 
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   22 ---
 net/ipv4/tcp_input.c                           |    4 
 net/ipv6/addrconf.c                            |    1 
 net/ipv6/anycast.c                             |    1 
 net/ipv6/icmp.c                                |    2 
 net/ipv6/ip6_tunnel.c                          |    4 
 net/ipv6/netfilter/ip6t_LOG.c                  |    6 
 net/ipv6/tcp_ipv6.c                            |    1 
 net/rfkill/rfkill-input.c                      |    2 
 net/sched/sch_api.c                            |    6 
 net/sctp/ipv6.c                                |    4 
 net/sunrpc/auth_gss/svcauth_gss.c              |    9 -
 net/xfrm/xfrm_policy.c                         |    2 
 100 files changed, 729 insertions(+), 348 deletions(-)

Summary of changes from v2.6.21.2 to v2.6.21.3
============================================

Adam Kropelin (1):
      usb-serial: Fix edgeport regression on non-EPiC devices

Adrian Bunk (2):
      Missing header include in ipt_iprange.h
      drivers/video/macmodes.c:mac_find_mode() mustn't be __devinit

Al Viro (1):
      Fix ipv6 tunnel endianness bug.

Alan Cox (1):
      aacraid: fix security hole

Alan Stern (2):
      USB: cdc-acm: fix sysfs attribute registration bug
      USB: fix warning caused by autosuspend counter going negative

Alexander Shmelev (1):
      Fix sparc32 memset()

Alexey Dobriyan (2):
      Fix leak on /proc/lockdep_stats
      Fix leaks on /proc/{*/sched, sched_debug, timer_list, timer_stats}

Andreas Schwab (1):
      futex: pass nr_wake2 to futex_wake_op

Arne Redlich (1):
      md: handle writes to broken raid10 arrays gracefully

Ayaz Abdulla (3):
      forcedeth bug fix: cicada phy
      forcedeth bug fix: vitesse phy
      forcedeth bug fix: realtek phy

Christian Lamparter (1):
      Add a PCI ID for santa rosa's PATA controller.

Chuck Ebbert (1):
      ACPI: dock: fix opps after dock driver fails to initialize

Daniel Ritz (1):
      pcmcia: give socket time to power down

Dave Airlie (1):
      drm/i915: Fix i965 secured batchbuffer usage (CVE-2007-3851)

David S. Miller (2):
      Fix console write locking in sparc drivers.
      Sparc64 bootup assembler bug

David Stevens (1):
      IPV6: /proc/net/anycast6 unbalanced inet6_dev refcnt

Davide Libenzi (1):
      make timerfd return a u64 and fix the __put_user

Dmitry Butskoy (1):
      Fix error queue socket lookup in ipv6

Dmitry Torokhov (1):
      Input: lifebook - fix an oops on Panasonic CF-18

Fengguang Wu (1):
      readahead: MIN_RA_PAGES/MAX_RA_PAGES macros

Greg Kroah-Hartman (1):
      Linux 2.6.22.2

Hans Verkuil (5):
      V4L: Add check for valid control ID to v4l2_ctrl_next
      V4L: ivtv: fix broken VBI output support
      V4L: ivtv: fix DMA timeout when capturing VBI + another stream
      V4L: ivtv: Add locking to ensure stream setup is atomic
      V4L: wm8775/wm8739: Fix memory leak when unloading module

Herbert van den Bergh (1):
      do not limit locked memory when RLIMIT_MEMLOCK is RLIM_INFINITY

Herton Ronaldo Krzesinski (1):
      Include serial_reg.h with userspace headers

Ilpo Järvinen (1):
      TCP FRTO retransmit bug fix

Ingo Molnar (1):
      Fix rfkill IRQ flags.

J. Bruce Fields (2):
      nfsd: fix possible read-ahead cache and export table corruption
      nfsd: fix possible oops on re-insertion of rpcsec_gss modules

Jan Kara (2):
      jbd commit: fix transaction dropping
      jbd2 commit: fix transaction dropping

Jean Tourrilhes (1):
      softmac: Fix ESSID problem

Jeff Dike (2):
      uml: limit request size on COWed devices
      UML: exports for hostfs

Jens Axboe (2):
      splice: fix double page unlock
      cfq-iosched: fix async queue behaviour

Jesper Juhl (1):
      cr_backlight_probe() allocates too little storage for struct cr_panel

Jiri Slaby (1):
      sx: switch subven and subid values

Joe Jin (1):
      hugetlb: fix race in alloc_fresh_huge_page()

Joerg Roedel (1):
      KVM: SVM: Reliably detect if SVM was disabled by BIOS

Jun'ichi Nomura (1):
      dm io: fix another panic on large request

Maik Hampel (1):
      md: raid10: fix use-after-free of bio

Mariusz Kozlowski (1):
      fs: 9p/conv.c error path fix

Mark Fortescue (1):
      Fix sparc32 udelay() rounding errors.

Mattia Dongili (1):
      sony-laptop: fix bug in event handling

Michael Halcrow (1):
      eCryptfs: ecryptfs_setattr() bugfix

Mikko Rapeli (1):
      Hangup TTY before releasing rfcomm_dev

Milan Broz (3):
      dm io: fix panic on large request
      dm raid1: fix status
      dm snapshot: permit invalid activation

Mingming Cao (1):
      "ext4_ext_put_in_cache" uses __u32 to receive physical block number

Oleg Nesterov (1):
      destroy_workqueue() can livelock

Oliver Neukum (1):
      USB: fix for ftdi_sio quirk handling

Patrick McHardy (4):
      Fix TC deadlock.
      Fix IPCOMP crashes.
      gen estimator timer unload race
      Netfilter: Fix logging regression

Pavel Emelianov (1):
      Fix user struct leakage with locked IPC shem segment

Petr Vandrovec (1):
      Fix reported task file values in sense data

Ranko Zivojnovic (1):
      gen estimator deadlock fix

Satyam Sharma (1):
      Netpoll leak

Stefan Bader (1):
      dm: disable barriers

Stefan Richter (4):
      firewire: fw-sbp2: set correct maximum payload (fixes CardBus adapters)
      fw-ohci: fix "scheduling while atomic"
      firewire: fix memory leak of fw_request instances
      ieee1394: revert "sbp2: enforce 32bit DMA mapping"

Tejun Heo (1):
      libata: add FUJITSU MHV2080BH to NCQ blacklist

Thomas Gleixner (1):
      i386: HPET, check if the counter works

Ulrich Drepper (1):
      CPU online file permission

Venki Pallipadi (1):
      acpi-cpufreq: Proper ReadModifyWrite of PERF_CTL MSR

Ville Tervo (1):
      Keep rfcomm_dev on the list until it is freed

Vlad Yasevich (2):
      SCTP scope_id handling fix
      Fix ipv6 link down handling.

YOSHIFUJI Hideaki (2):
      Fix TCP IPV6 MD5 bug.
      sysfs: release mutex when kmalloc() failed in sysfs_open_file().

Yasuyuki Kozakai (1):
      nf_conntrack: don't track locally generated special ICMP error

