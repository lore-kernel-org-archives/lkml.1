Return-Path: <linux-kernel-owner+w=401wt.eu-S1762279AbYBWAdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762279AbYBWAdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYBWAdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:33:00 -0500
Received: from mx1.suse.de ([195.135.220.2]:44595 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbYBWAc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:32:59 -0500
Date: Fri, 22 Feb 2008 16:29:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/38] 2.6.24-stable review
Message-ID: <20080223002907.GA7268@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.24.3 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Tuesday, Feb 25, 2008, 00:10:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.24.3-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Makefile                                  |    9 +-
 arch/powerpc/platforms/chrp/pci.c         |    4 -
 arch/powerpc/platforms/powermac/feature.c |   11 +++
 arch/s390/lib/uaccess_std.c               |    8 +-
 arch/sparc/lib/rwsem.S                    |    2 
 arch/sparc64/lib/rwsem.S                  |    2 
 arch/x86/mm/pageattr_64.c                 |    2 
 drivers/macintosh/smu.c                   |   25 +++++++
 drivers/net/bonding/bond_main.c           |   16 ++--
 drivers/net/dl2k.h                        |    4 -
 drivers/net/pcmcia/smc91c92_cs.c          |   12 +++
 drivers/scsi/gdth.c                       |    9 ++
 drivers/scsi/sd.c                         |   34 ++++------
 drivers/usb/class/usblp.c                 |    1 
 fs/inotify_user.c                         |    2 
 fs/nfs/write.c                            |   20 +++++-
 fs/super.c                                |    1 
 fs/xfs/linux-2.6/xfs_file.c               |    3 
 include/asm-powerpc/pmac_feature.h        |    8 ++
 include/linux/Kbuild                      |    1 
 include/linux/hrtimer.h                   |    2 
 include/linux/hugetlb.h                   |    1 
 include/linux/ktime.h                     |    2 
 kernel/audit.c                            |   10 ++-
 kernel/compat.c                           |   44 ++++++++++++-
 kernel/futex.c                            |    2 
 kernel/futex_compat.c                     |    2 
 kernel/hrtimer.c                          |  100 +++++++++++++++++-------------
 kernel/irq/chip.c                         |   20 +++++-
 kernel/posix-timers.c                     |   25 ++-----
 kernel/sysctl.c                           |    2 
 mm/hugetlb.c                              |   10 +++
 mm/memory.c                               |    2 
 mm/slub.c                                 |    3 
 net/bluetooth/hci_sysfs.c                 |   48 +++++++++++---
 net/ipv4/fib_hash.c                       |   47 +++++++++-----
 net/ipv4/fib_trie.c                       |   57 ++++++++++-------
 net/ipv4/inet_diag.c                      |   11 +--
 net/ipv4/ip_output.c                      |    4 -
 net/ipv4/ipcomp.c                         |    5 +
 net/ipv4/sysctl_net_ipv4.c                |    2 
 net/ipv4/xfrm4_tunnel.c                   |    2 
 net/ipv6/ip6_output.c                     |    4 -
 net/ipv6/ipcomp6.c                        |    5 +
 net/netfilter/nf_conntrack_proto_tcp.c    |   35 ++++++++--
 net/sched/em_meta.c                       |   10 +--
 net/sched/ematch.c                        |    5 -
 security/selinux/ss/services.c            |    1 
 48 files changed, 439 insertions(+), 196 deletions(-)
