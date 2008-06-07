Return-Path: <linux-kernel-owner+w=401wt.eu-S1763768AbYFGBWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763768AbYFGBWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760472AbYFGBJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:39 -0400
Received: from sous-sol.org ([216.99.217.87]:42530 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbYFGBJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:25 -0400
Message-Id: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:15 -0700
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
Subject: [patch 00/50] 2.6.25.6 -stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.25.6 release.
There are 50 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Mon, Jun 9 01:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.6-rc1.gz
and the diffstat can be found below.

thanks,

the -stable release team
-- 

 Makefile                                       |    2 +-
 arch/powerpc/kernel/smp.c                      |    2 +
 arch/powerpc/mm/slb.c                          |   21 +++--
 arch/x86/kernel/apic_64.c                      |    2 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c     |   10 ++
 arch/x86/kernel/irq_32.c                       |    2 +-
 arch/x86/kernel/process_32.c                   |    5 +-
 arch/x86/kernel/process_64.c                   |    5 +-
 arch/x86/kernel/ptrace.c                       |    7 +-
 arch/x86/kernel/tsc_32.c                       |   38 ++++----
 arch/x86/kernel/tsc_64.c                       |    5 +-
 arch/x86/pci/common.c                          |   17 ----
 block/genhd.c                                  |    9 ++-
 drivers/ata/libata-core.c                      |   12 +++
 drivers/block/brd.c                            |    1 +
 drivers/cpufreq/cpufreq.c                      |    4 +-
 drivers/hid/hid-input.c                        |    5 +-
 drivers/hid/usbhid/hid-quirks.c                |   38 ++++----
 drivers/i2c/busses/i2c-nforce2.c               |   28 +++++-
 drivers/i2c/chips/max6875.c                    |    3 -
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    6 ++
 drivers/md/md.c                                |    2 +-
 drivers/md/raid5.c                             |   10 ++-
 drivers/net/atl1/atl1_main.c                   |    1 +
 drivers/net/ps3_gelic_wireless.c               |    2 +
 drivers/usb/class/cdc-acm.c                    |    3 +
 drivers/usb/host/ohci-omap.c                   |    3 +-
 drivers/usb/host/ohci-sm501.c                  |    3 +-
 drivers/usb/misc/ldusb.c                       |    4 -
 drivers/usb/serial/ftdi_sio.c                  |    1 +
 drivers/usb/serial/ftdi_sio.h                  |    6 ++
 drivers/usb/serial/option.c                    |    9 ++-
 drivers/usb/serial/pl2303.c                    |    1 -
 drivers/usb/serial/pl2303.h                    |    1 -
 drivers/usb/storage/unusual_devs.h             |   10 ++
 fs/cifs/inode.c                                |   15 +++-
 fs/ecryptfs/ecryptfs_kernel.h                  |    2 -
 fs/ecryptfs/read_write.c                       |   22 -----
 fs/ext3/xattr.c                                |    5 +
 fs/ext4/xattr.c                                |    5 +
 fs/proc/array.c                                |    2 +-
 fs/proc/base.c                                 |   33 ++++++--
 fs/proc/task_mmu.c                             |   28 ++----
 fs/xfs/linux-2.6/xfs_buf.c                     |   24 ++++-
 fs/xfs/linux-2.6/xfs_buf.h                     |   19 ++++
 include/asm-x86/tlbflush.h                     |   13 +++-
 include/linux/capability.h                     |   29 +++++--
 include/linux/genhd.h                          |    4 +-
 include/linux/hid.h                            |    1 +
 include/linux/types.h                          |    4 +-
 init/do_mounts.c                               |   27 ++++++-
 kernel/capability.c                            |  111 ++++++++++++++++--------
 kernel/cgroup.c                                |    2 +-
 mm/memory_hotplug.c                            |   78 ++++++++--------
 mm/mmap.c                                      |    8 ++-
 mm/page_alloc.c                                |    3 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c        |    8 +-
 net/netfilter/nf_conntrack_expect.c            |    4 +-
 net/netfilter/xt_connlimit.c                   |    3 +-
 net/netfilter/xt_iprange.c                     |    2 +
 security/smack/smack_lsm.c                     |   12 +++
 61 files changed, 483 insertions(+), 259 deletions(-)
