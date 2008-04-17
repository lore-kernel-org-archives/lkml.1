Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbYDQBGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbYDQBGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbYDQBGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:06:31 -0400
Received: from sous-sol.org ([216.99.217.87]:58698 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYDQBGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:06:30 -0400
Message-Id: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:22 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/66] 2.6.24-stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.24.5 release.
There are 66 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Sat April 19 01:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.24.5-rc1.gz
and the diffstat can be found below.

thanks,

the -stable release team
-- 

 Makefile                                  |    4 -
 arch/parisc/kernel/firmware.c             |   27 +++++++----
 arch/parisc/kernel/pdc_cons.c             |   19 +++++++-
 arch/parisc/kernel/signal.c               |    3 -
 arch/sparc64/kernel/ptrace.c              |    4 +
 arch/sparc64/kernel/signal.c              |    2 
 arch/sparc64/mm/tlb.c                     |    3 -
 arch/x86/kernel/machine_kexec_64.c        |    1 
 arch/x86/xen/enlighten.c                  |   42 ++++++++++--------
 arch/x86/xen/xen-asm.S                    |    9 +++
 crypto/xcbc.c                             |   17 +++----
 drivers/acpi/bus.c                        |    7 +--
 drivers/acpi/processor_core.c             |    2 
 drivers/ata/libata-core.c                 |   38 ++++++++++------
 drivers/firmware/dmi_scan.c               |    2 
 drivers/hwmon/w83781d.c                   |   21 ++++++---
 drivers/macintosh/via-pmu.c               |    2 
 drivers/md/md.c                           |   12 -----
 drivers/md/raid5.c                        |   51 ++++++++++++----------
 drivers/media/dvb/dvb-usb/ttusb2.c        |    1 
 drivers/media/dvb/frontends/tda10086.c    |   28 +++++++++---
 drivers/media/dvb/frontends/tda10086.h    |    3 +
 drivers/media/dvb/ttpci/budget.c          |    1 
 drivers/media/video/ivtv/ivtv-driver.c    |    3 +
 drivers/media/video/saa7134/saa7134-dvb.c |    1 
 drivers/mtd/chips/cfi_cmdset_0001.c       |   10 ++--
 drivers/mtd/devices/block2mtd.c           |    1 
 drivers/net/macb.c                        |    2 
 drivers/net/plip.c                        |    7 +--
 drivers/net/pppol2tp.c                    |   69 ++++++++++++++++--------------
 drivers/net/sis190.c                      |   15 ++++--
 drivers/net/sungem.c                      |    2 
 drivers/pci/quirks.c                      |   11 ++--
 drivers/pnp/pnpacpi/rsparser.c            |    8 +--
 drivers/uio/uio.c                         |    2 
 drivers/usb/core/message.c                |    5 +-
 drivers/usb/core/quirks.c                 |    3 +
 drivers/usb/serial/keyspan.h              |    4 +
 drivers/usb/serial/ti_usb_3410_5052.c     |    4 -
 drivers/usb/serial/visor.c                |    2 
 drivers/usb/storage/transport.c           |    3 -
 drivers/usb/storage/unusual_devs.h        |   11 ++++
 drivers/video/fbmem.c                     |    1 
 fs/buffer.c                               |   13 ++---
 fs/dcache.c                               |    3 -
 fs/hfsplus/dir.c                          |   23 ++++++----
 fs/inotify.c                              |   30 ++++++-------
 fs/locks.c                                |   48 ++++++++++++--------
 fs/signalfd.c                             |    7 ++-
 include/asm-parisc/futex.h                |   10 +++-
 include/asm-parisc/pdc.h                  |    3 -
 include/asm-sparc64/backoff.h             |    3 -
 include/linux/ethtool.h                   |    1 
 include/linux/percpu.h                    |    2 
 include/linux/sched.h                     |    6 ++
 include/linux/security.h                  |    3 -
 include/linux/time.h                      |    4 +
 include/linux/usb/quirks.h                |    3 +
 include/linux/usb_usual.h                 |    4 +
 kernel/sched.c                            |   43 ++++++++++++++++++
 kernel/timer.c                            |   10 +++-
 mm/allocpercpu.c                          |   15 ++++++
 mm/slab.c                                 |    4 -
 net/8021q/vlan.c                          |    2 
 net/ax25/ax25_out.c                       |   13 ++++-
 net/bluetooth/hci_core.c                  |    4 -
 net/core/dev.c                            |    4 -
 net/core/netpoll.c                        |    6 +-
 net/ipv4/tcp.c                            |    4 -
 net/ipv4/tcp_output.c                     |    2 
 net/ipv6/netfilter/nf_conntrack_reasm.c   |    2 
 net/llc/af_llc.c                          |    3 +
 net/sched/sch_generic.c                   |   18 ++++++-
 net/sched/sch_htb.c                       |   13 +++--
 net/sctp/bind_addr.c                      |    4 +
 net/sctp/ipv6.c                           |    4 +
 net/sctp/protocol.c                       |    4 +
 net/sunrpc/clnt.c                         |    4 -
 scripts/Makefile.modpost                  |    6 ++
 scripts/mod/file2alias.c                  |    4 +
 scripts/mod/modpost.c                     |    5 +-
 scripts/mod/modpost.h                     |    1 
 security/capability.c                     |    1 
 security/commoncap.c                      |   39 ----------------
 84 files changed, 533 insertions(+), 308 deletions(-)

