Return-Path: <linux-kernel-owner+w=401wt.eu-S932232AbYCUW7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbYCUW7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763713AbYCUWuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:50:50 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59281 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763721AbYCUWup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:45 -0400
Message-Id: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:42:50 -0700
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
Subject: [patch 00/76] 2.6.24-stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.24.4 release.
There are 76 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Sunday, Mar 21, 2008, 22:45:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.24.4-rc1.gz
and the diffstat can be found below.

thanks,

the -stable release team
---
 Makefile                             |    2 +-
 arch/arm/mach-pxa/clock.c            |   23 ++-
 arch/mips/kernel/i8259.c             |    4 +-
 arch/mips/kernel/irq.c               |    5 +
 arch/sparc/kernel/Makefile           |    5 +-
 arch/sparc/kernel/una_asm.S          |  153 ++++++++++++++++++++
 arch/sparc/kernel/unaligned.c        |  252 +++++++---------------------------
 arch/sparc64/mm/fault.c              |   14 +--
 arch/x86/ia32/ia32_signal.c          |    4 +-
 arch/x86/kernel/apic_32.c            |    2 +-
 arch/x86/kernel/apic_64.c            |    2 +-
 arch/x86/kernel/io_apic_32.c         |    4 +-
 arch/x86/kernel/io_apic_64.c         |    6 +-
 arch/x86/kernel/process_64.c         |    3 +-
 arch/x86/kernel/signal_32.c          |    4 +-
 arch/x86/kernel/signal_64.c          |    2 +-
 arch/x86/kernel/smpboot_32.c         |    2 +-
 arch/x86/kernel/smpboot_64.c         |    2 +-
 arch/x86/pci/mmconfig-shared.c       |   35 -----
 arch/x86/pci/mmconfig_32.c           |   22 ++--
 arch/x86/pci/mmconfig_64.c           |   22 ++--
 arch/x86/pci/pci.h                   |    7 -
 crypto/async_tx/async_xor.c          |    2 +-
 crypto/xcbc.c                        |    6 +-
 crypto/xts.c                         |   13 +-
 drivers/acorn/char/defkeymap-l7200.c |   68 +++++-----
 drivers/ata/pata_hpt366.c            |    6 +-
 drivers/ata/pata_hpt37x.c            |    6 +-
 drivers/ata/pata_serverworks.c       |    2 +-
 drivers/base/platform.c              |    2 +-
 drivers/block/ub.c                   |    2 +-
 drivers/char/defkeymap.c_shipped     |   68 +++++-----
 drivers/char/vt.c                    |    1 +
 drivers/dma/ioat_dma.c               |    2 +
 drivers/message/fusion/mptsas.c      |    5 +
 drivers/net/e1000e/netdev.c          |    6 +-
 drivers/net/macb.c                   |    2 +-
 drivers/net/niu.c                    |   20 ++-
 drivers/net/niu.h                    |    2 +-
 drivers/net/wireless/b43/dma.c       |   32 +++--
 drivers/net/wireless/b43/main.c      |    3 +-
 drivers/s390/char/defkeymap.c        |    4 +-
 drivers/scsi/advansys.c              |   15 ++-
 drivers/scsi/aic94xx/aic94xx_scb.c   |   14 ++-
 drivers/scsi/arcmsr/arcmsr_hba.c     |   20 ++--
 drivers/scsi/gdth.c                  |  112 ++++++----------
 drivers/scsi/gdth.h                  |    1 +
 drivers/scsi/gdth_proc.c             |    6 +-
 drivers/scsi/ips.c                   |   20 ++-
 drivers/scsi/scsi_lib.c              |    1 -
 drivers/spi/atmel_spi.c              |   10 ++
 drivers/spi/pxa2xx_spi.c             |   41 ++++--
 drivers/usb/host/ehci-q.c            |    2 +-
 drivers/usb/serial/ftdi_sio.c        |   25 ++++
 drivers/usb/serial/ftdi_sio.h        |    7 +
 drivers/usb/storage/protocol.c       |    5 +-
 fs/aio.c                             |    8 +
 fs/ecryptfs/mmap.c                   |  102 ++++++++++----
 fs/fuse/dir.c                        |    2 +-
 fs/isofs/compress.c                  |   11 ++
 fs/jbd/recovery.c                    |    2 +-
 fs/jbd2/recovery.c                   |    2 +-
 fs/nfsd/nfsfh.c                      |    4 +-
 fs/ufs/util.h                        |    2 +-
 include/asm-arm/arch-pxa/pxa-regs.h  |    1 +
 include/asm-x86/apic_32.h            |    2 +-
 include/asm-x86/futex_32.h           |    6 +-
 include/asm-x86/futex_64.h           |    6 +-
 include/asm-x86/io_apic_64.h         |    2 +-
 include/asm-x86/processor_32.h       |    5 +-
 include/linux/Kbuild                 |    1 -
 include/linux/futex.h                |    1 +
 include/linux/irq.h                  |    3 +
 include/linux/moduleparam.h          |   12 ++-
 include/net/inet_sock.h              |    3 +-
 kernel/futex.c                       |   50 ++++++--
 kernel/futex_compat.c                |    9 ++
 kernel/irq/chip.c                    |   36 +++++
 kernel/relay.c                       |    5 +-
 kernel/sched.c                       |   36 ++---
 kernel/sysctl.c                      |    2 +-
 mm/filemap.c                         |   22 ++--
 mm/hugetlb.c                         |    2 +-
 net/bluetooth/hci_sysfs.c            |    8 +-
 net/bridge/netfilter/ebt_dnat.c      |    4 +-
 net/bridge/netfilter/ebt_redirect.c  |    4 +-
 net/bridge/netfilter/ebt_snat.c      |    4 +-
 net/core/dev.c                       |    6 +-
 net/ipv4/ip_sockglue.c               |    5 -
 net/ipv4/ipcomp.c                    |    5 +-
 net/ipv4/ipconfig.c                  |    4 +-
 net/ipv4/netfilter/arpt_mangle.c     |    2 +-
 net/ipv4/netfilter/ip_queue.c        |   12 +-
 net/ipv6/ip6_output.c                |    6 +-
 net/ipv6/ip6_tunnel.c                |    1 +
 net/ipv6/ipcomp6.c                   |    2 +
 net/ipv6/netfilter/ip6_queue.c       |   10 +-
 net/ipv6/xfrm6_output.c              |    2 +-
 net/netfilter/nfnetlink_log.c        |    2 +-
 net/netfilter/nfnetlink_queue.c      |   12 +-
 net/netfilter/xt_time.c              |    7 +-
 security/commoncap.c                 |    2 +-
 102 files changed, 873 insertions(+), 668 deletions(-)
