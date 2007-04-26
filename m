Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbXDZD3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbXDZD3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 23:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbXDZD3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 23:29:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754270AbXDZD3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 23:29:31 -0400
Date: Wed, 25 Apr 2007 20:29:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.21
Message-ID: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-484642057-1177558168=:9964"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-484642057-1177558168=:9964
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


If the goal for 2.6.20 was to be a stable release (and it was), the goal 
for 2.6.21 is to have just survived the big timer-related changes and some 
of the other surprises (just as an example: we were apparently unlucky 
enough to hit what looks like a previously unknown hardware errata in one 
of the ethernet drivers that got updated etc).

So it's been over two and a half months, and while it's certainly not the 
longest release cycle ever, it still dragged out a bit longer than I'd 
have hoped for and it should have. As usual, I'd like to thank Adrian (and 
the people who jumped on the entries Adrian had) for keeping everybody on 
their toes with the regression list - there's a few entries there still, 
but it got to the point where we didn't even know if they were real 
regressions, and delaying things further just wasn't going to help.

So the big change during 2.6.21 is all the timer changes to support a 
tickless system (and even with ticks, more varied time sources). Thanks 
(when it no longer broke for lots of people ;) go to Thomas Gleixner and 
Ingo Molnar and a cadre of testers and coders.

Of course, the timer stuff was just the most painful and core part (and 
thus the one that I remember most): there's a lot of changes all over. The 
appended changelog is just for the fixes since -rc7, so that doesn't look 
very impressive, the full changes since 2.6.20 are obviously a *lot* 
bigger (and you're better off reading the individual -rc changelogs).

We now return you to your regular scheduler discussions,

		Linus

---
Akinobu Mita (1):
      fault injection: add entry to MAINTAINERS

Alan Cox (3):
      exec.c: fix coredump to pipe problem and obscure "security hole"
      pata_sis: Fix oops on boot
      [SPARC] openprom: Switch to ref counting PCI API

Alexey Dobriyan (1):
      paride drivers: initialize spinlocks

Alexey Kuznetsov (1):
      [NETLINK]: Infinite recursion in netlink.

Andi Kleen (5):
      x86: Fix gcc 4.2 _proxy_pda workaround
      x86: Fix potential overflow in perfctr reservation
      x86: Remove noreplacement option
      x86-64: Always flush all pages in change_page_attr
      i386: Fix some warnings added by earlier patch

Andrea Righi (1):
      [netdrvr] depca: handle platform_device_add() failure

Andrew Morton (4):
      drivers/macintosh/smu.c: fix locking snafu
      acpi-thermal: fix mod_timer() interval
      drivers/net/hamradio/baycom_ser_fdx build fix
      packet: fix error handling

Atsushi Nemoto (3):
      [MIPS] Disallow CpU exception in kernel again.
      [MIPS] Retry {save,restore}_fp_context if failed in atomic context.
      [MIPS] Fix BUG(), BUG_ON() handling

Aubrey.Li (1):
      [NET]: Fix UDP checksum issue in net poll mode.

Avi Kivity (1):
      KVM: Fix off-by-one when writing to a nonpae guest pde

Badari Pulavarty (1):
      cache_k8_northbridges() overflows beyond allocation

Balbir Singh (1):
      Taskstats fix the structure members alignment issue

Bartlomiej Zolnierkiewicz (2):
      ide/Kconfig: add missing range check for IDE_MAX_HWIFS
      Revert "adjust legacy IDE resource setting (v2)"

Bastian Blank (1):
      Allow reading tainted flag as user

Ben Dooks (2):
      [ARM] 4313/1: S3C24XX: Update s3c2410 defconfig to 2.6.21-rc6
      spi: fix use of set_cs in spi_s3c24xx driver

Benjamin Herrenschmidt (1):
      fix bogon in /dev/mem mmap'ing on nommu

Christoph Lameter (1):
      page migration: fix NR_FILE_PAGES accounting

Dan Williams (1):
      usb-net/pegasus: fix pegasus carrier detection

Dave Jiang (1):
      gianfar needs crc32 lib dependency

Dave Johnson (1):
      [MIPS] Fix wrong checksum for split TCP packets on 64-bit MIPS

Dave Jones (1):
      Longhaul - Revert ACPI C3 on Longhaul ver. 2

David Brownell (1):
      MAINTAINERS: use lists.linux-foundation.org

David Rientjes (1):
      oom: kill all threads that share mm with killed task

David S. Miller (2):
      [IPSEC] af_key: Fix thinko in pfkey_xfrm_policy2msg()
      [PARPORT] SUNBPP: Fix OOPS when debugging is enabled.

Denis Lunev (1):
      [NETLINK]: Don't attach callback to a going-away netlink socket

Divy Le Ray (2):
      cxgb3 - Fix low memory conditions
      cxgb3 - PHY interrupts and GPIO pins.

Don Zickus (1):
      allow vmsplice to work in 32-bit mode on ppc64

Evgeniy Dushistov (1):
      ufs proper handling of zero link case

Evgeny Kravtsunov (1):
      [BRIDGE]: Unaligned access when comparing ethernet addresses

Herbert Xu (1):
      [NET]: Get rid of alloc_skb_from_cache

Hugh Dickins (1):
      fix OOM killing processes wrongly thought MPOL_BIND

Ivan Kokshaysky (3):
      alpha: fixes for specific machine types
      alpha: more fixes for specific machine types
      alpha: build fixes - force architecture

Jan Yenya Kasprzak (1):
      Char: mxser_new, fix recursive locking

Jean Delvare (3):
      hwmon/w83627ehf: Fix the fan5 clock divider write
      i2c-pasemi: Depend on PPC_PASEMI again
      hwmon/w83627ehf: Don't redefine REGION_OFFSET

Jeff Mahoney (1):
      reiserfs: fix xattr root locking/refcount bug

Jens Axboe (2):
      cfq-iosched: fix sequential write regression
      cfq-iosched: fix alias + front merge bug

Jiri Kosina (1):
      8250: fix possible deadlock between serial8250_handle_port() and serial8250_interrupt()

Jiri Slaby (3):
      Char: mxser_new, fix TIOCMIWAIT
      Char: mxser, fix TIOCMIWAIT
      Char: icom, mark __init as __devinit

Joachim Deguara (1):
      x86-64: make GART PTEs uncacheable

Kazunori MIYAZAWA (1):
      [KEY]: Fix conversion between IPSEC_MODE_xxx and XFRM_MODE_xxx.

Latchesar Ionkov (1):
      v9fs: don't use primary fid when removing file

Linas Vepstas (1):
      spidernet: Fix problem sending IP fragments

Linus Torvalds (2):
      Revert "e1000: fix NAPI performance on 4-port adapters"
      Linux 2.6.21

Marcel van Nies (3):
      [SUNQE]: Fix MAC address assignment.
      [SUNLANCE]: Fix module unload.
      [SUNHME]: Fix module unload.

Mark Lord (1):
      ide/pci/delkin_cb.c: add new PCI ID

Mark Mason (1):
      [MIPS] Add missing silicon revisions for BCM112x

Michael Buesch (1):
      Add mbuesch to .mailmap

Michael Chan (1):
      [BNX2]: Fix occasional NETDEV WATCHDOG on 5709.

Michael S. Tsirkin (1):
      IB/mthca: Fix data corruption after FMR unmap on Sinai

Miguel Ojeda (1):
      Fix spelling in drivers/video/Kconfig

Neil Horman (1):
      sis900: Allocate rx replacement buffer before rx operation

NeilBrown (1):
      knfsd: use a spinlock to protect sk_info_authunix

Olaf Hering (1):
      do not truncate irq number for icom adapter

Olaf Kirch (1):
      [IrDA]: Correctly handling socket error

Olof Johansson (1):
      Minor bug fixes to i2c-pasemi

Paolo Galtieri (1):
      [SCTP]: Unmap v4mapped addresses during SCTP_BINDX_REM_ADDR operation.

Patrick McHardy (1):
      [XFRM]: beet: fix pseudo header length value

Paul Mackerras (1):
      [PPP]: Fix skbuff.c:BUG due incorrect logic in process_input_packet()

Pavel Emelianov (1):
      [NET]: Set a separate lockdep class for neighbour table's proxy_queue

Ralf Baechle (1):
      [MIPS] Fix oprofile logic to physical counter remapping

Randy Dunlap (1):
      kernel-doc: fix plist.h comments

Russell King (2):
      [ARM] Update mach-types
      Provide dummy devm_ioport_* if !HAS_IOPORT

S.Çağlar Onur (1):
      Add missing USRobotics Wireless Adapter (Model 5423) id into zd1211rw

Sergei Shtylyov (1):
      hpt366: fix kernel oops with HPT302N

Stefan Richter (1):
      ieee1394: update MAINTAINERS database

Stephen Hemminger (7):
      sky2: disable support for 88E8056
      sky2: handle descriptor errors
      sky2: disable ASF on all chip types
      sky2: EC-U performance and jumbo support
      sky2: no jumbo on Yukon FE
      sky2: version 1.14
      [TCP]: Congestion control initialization.

Taku Izumi (1):
      Fix possible NULL pointer access in 8250 serial driver

Trond Myklebust (5):
      NFS: clean up the unstable write code
      NFS: Don't clear PG_writeback until after we've processed unstable writes
      NFS: Fix the 'desynchronized value of nfs_i.ncommit' error
      NFS: Fix race in nfs_set_page_dirty
      RPC: Fix the TCP resend semantics for NFSv4

Tsutomu Fujii (1):
      [SCTP]: Fix assertion (!atomic_read(&sk->sk_rmem_alloc)) failed message

Vlad Yasevich (1):
      [SCTP]: Do not interleave non-fragments when in partial delivery

YOSHIFUJI Hideaki (2):
      [IPV6]: Disallow RH0 by default.
      IPv6: fix Routing Header Type 0 handling thinko

vignesh babu (1):
      [SBUS] vfc_dev.c: kzalloc

---
 .mailmap                                |    2 +
 Documentation/networking/ip-sysctl.txt  |    9 ++
 Documentation/x86_64/boot-options.txt   |    4 -
 MAINTAINERS                             |   39 +++----
 Makefile                                |    2 +-
 arch/alpha/kernel/core_mcpcia.c         |    2 -
 arch/alpha/kernel/err_titan.c           |    1 +
 arch/alpha/kernel/module.c              |    8 +-
 arch/alpha/kernel/sys_nautilus.c        |    6 +
 arch/alpha/kernel/sys_noritake.c        |    9 ++-
 arch/alpha/kernel/sys_rawhide.c         |   15 +++
 arch/alpha/kernel/sys_sio.c             |   14 ++-
 arch/alpha/kernel/sys_sx164.c           |    2 +-
 arch/alpha/kernel/sys_titan.c           |    3 +-
 arch/arm/configs/s3c2410_defconfig      |   11 +-
 arch/arm/tools/mach-types               |   99 ++++++++++++++++-
 arch/i386/kernel/alternative.c          |   21 +---
 arch/i386/kernel/cpu/cpufreq/longhaul.c |    2 +-
 arch/i386/kernel/nmi.c                  |   17 ++--
 arch/i386/kernel/vmlinux.lds.S          |    2 +-
 arch/mips/kernel/r2300_switch.S         |   10 +-
 arch/mips/kernel/r4k_switch.S           |   10 +-
 arch/mips/kernel/signal-common.h        |    9 ++
 arch/mips/kernel/signal.c               |   52 +++++++--
 arch/mips/kernel/signal32.c             |   52 +++++++--
 arch/mips/kernel/traps.c                |   25 +----
 arch/mips/oprofile/op_model_mipsxx.c    |    2 +-
 arch/mips/sibyte/sb1250/setup.c         |   12 ++
 arch/x86_64/kernel/functionlist         |    1 -
 arch/x86_64/kernel/k8.c                 |    4 +-
 arch/x86_64/kernel/nmi.c                |   10 +-
 arch/x86_64/kernel/pci-gart.c           |    6 +-
 arch/x86_64/kernel/vmlinux.lds.S        |    2 +-
 arch/x86_64/mm/pageattr.c               |    2 +-
 block/cfq-iosched.c                     |   46 ++++----
 drivers/acpi/thermal.c                  |    3 +-
 drivers/ata/pata_sis.c                  |   10 +-
 drivers/block/paride/pcd.c              |    2 +-
 drivers/block/paride/pf.c               |    2 +-
 drivers/block/pktcdvd.c                 |    3 +-
 drivers/char/mem.c                      |    2 +-
 drivers/char/mxser.c                    |   48 +++------
 drivers/char/mxser_new.c                |   45 +++-----
 drivers/hwmon/w83627ehf.c               |   20 ++--
 drivers/i2c/busses/Kconfig              |    3 +-
 drivers/i2c/busses/i2c-pasemi.c         |    6 +-
 drivers/ide/Kconfig                     |    1 +
 drivers/ide/pci/delkin_cb.c             |    1 +
 drivers/ide/pci/hpt366.c                |    5 +-
 drivers/infiniband/hw/mthca/mthca_mr.c  |    1 +
 drivers/kvm/mmu.c                       |    1 +
 drivers/macintosh/smu.c                 |    4 +-
 drivers/net/Kconfig                     |    1 +
 drivers/net/bnx2.c                      |    7 +-
 drivers/net/bnx2.h                      |    1 +
 drivers/net/cxgb3/cxgb3_defs.h          |    5 +-
 drivers/net/cxgb3/cxgb3_offload.c       |   69 +++++++++---
 drivers/net/cxgb3/t3_hw.c               |   18 ++-
 drivers/net/depca.c                     |    3 +-
 drivers/net/e1000/e1000_main.c          |   13 +--
 drivers/net/hamradio/baycom_ser_fdx.c   |    6 +-
 drivers/net/ppp_async.c                 |    4 +-
 drivers/net/sis900.c                    |   44 ++++----
 drivers/net/sky2.c                      |  176 ++++++++++++++++++-----------
 drivers/net/sky2.h                      |   11 ++
 drivers/net/spider_net.c                |    2 +-
 drivers/net/sunhme.c                    |    2 +-
 drivers/net/sunlance.c                  |    4 +-
 drivers/net/sunqe.c                     |    4 +-
 drivers/net/wireless/zd1211rw/zd_usb.c  |    1 +
 drivers/parport/parport_sunbpp.c        |   10 +-
 drivers/pci/probe.c                     |   45 ++------
 drivers/sbus/char/openprom.c            |    3 +-
 drivers/sbus/char/vfc_dev.c             |    3 +-
 drivers/serial/8250.c                   |    8 +-
 drivers/serial/icom.c                   |    9 +-
 drivers/serial/icom.h                   |    1 -
 drivers/spi/spi_s3c24xx.c               |    4 +-
 drivers/usb/net/pegasus.c               |   17 ++-
 drivers/usb/net/pegasus.h               |    3 +-
 drivers/video/Kconfig                   |    2 +-
 fs/9p/vfs_inode.c                       |    2 +-
 fs/exec.c                               |   18 ++-
 fs/nfs/write.c                          |  185 ++++++++++++++++++-------------
 fs/reiserfs/xattr.c                     |   92 ++++-----------
 fs/ufs/inode.c                          |   29 ++++-
 include/asm-alpha/compiler.h            |   47 ++++++--
 include/asm-alpha/core_mcpcia.h         |    2 +
 include/asm-alpha/io.h                  |    1 +
 include/asm-mips/bug.h                  |    3 +-
 include/asm-mips/checksum.h             |    2 +-
 include/asm-mips/fpu.h                  |   25 +---
 include/asm-mips/sibyte/sb1250_scd.h    |    1 +
 include/asm-mips/thread_info.h          |    1 -
 include/asm-powerpc/systbl.h            |    2 +-
 include/linux/io.h                      |   13 ++
 include/linux/ipv6.h                    |    3 +
 include/linux/nfs_page.h                |   30 -----
 include/linux/plist.h                   |   54 ++++-----
 include/linux/skbuff.h                  |   10 +-
 include/linux/sysctl.h                  |    1 +
 include/linux/taskstats.h               |   13 ++-
 kernel/sysctl.c                         |    2 +-
 mm/migrate.c                            |   15 +++-
 mm/oom_kill.c                           |    4 +-
 net/bridge/br_stp_if.c                  |    9 +-
 net/core/neighbour.c                    |    5 +-
 net/core/netpoll.c                      |    7 +
 net/core/skbuff.c                       |   55 ---------
 net/ipv4/fib_frontend.c                 |    8 +-
 net/ipv4/tcp_cong.c                     |   23 ++--
 net/ipv4/xfrm4_mode_beet.c              |    4 +-
 net/ipv6/addrconf.c                     |   11 ++
 net/ipv6/exthdrs.c                      |   40 ++++++-
 net/irda/af_irda.c                      |    3 +-
 net/key/af_key.c                        |   90 +++++++++++++---
 net/netlink/af_netlink.c                |    6 +-
 net/sctp/socket.c                       |   54 ++++++++-
 net/sctp/ulpqueue.c                     |    9 ++-
 net/sunrpc/clnt.c                       |    4 +
 net/sunrpc/svcauth_unix.c               |   21 +++-
 net/sunrpc/xprt.c                       |   10 --
 122 files changed, 1230 insertions(+), 828 deletions(-)
---1463790079-484642057-1177558168=:9964--
