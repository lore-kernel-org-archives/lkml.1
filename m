Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbZLCTjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbZLCTjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbZLCTjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:39:53 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41077 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134AbZLCTjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:39:49 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 03 Dec 2009 11:39:49 -0800
Message-ID: <m18wdjhmnu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [git pull] sysctl cleanups  for 2.6.33
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the sysctl cleanups from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/sysctl-2.6.git master

Highlights
- Introduces an arch generic compat_sys_sysctl
- Makes sys_sysctl a wrapper around /proc/sys to remove the double maintenance.
- Removes binary sysctl from the rest of the kernel.

This patch has been simmering for a while.  I have tested the changes, and my
tree has been sitting in linux-next for a while.

Note: There are two minor conflicts with net-next.  Two sysctl table
entries were added in net-next.  If hit those simply killing .ctl_name
and .strategy ctl_tables should be enough to resolve the issue.  It's
not hard to miss as the code won't compile otherwise.

Thanks,
Eric

----

Eric W. Biederman (44):
      sysctl: Separate the binary sysctl logic into it's own file.
      sysctl: Refactor the binary sysctl handling to remove duplicate code
      sysctl: Introduce a generic compat sysctl sysctl
      sysctl: ia64 Use the compat_sys_sysctl
      sysctl: mips Use the compat_sys_sysctl
      sysctl: parisc Use the compat_sys_sysctl
      sysctl: s390 Use the compat_sys_sysctl
      sysctl: sparc Use the compat_sys_sysctl
      sysctl: x86 Use the compat_sys_sysctl
      sysctl: Remove the cond_syscall entry for sys32_sysctl
      sysctl: Make do_sysctl static
      sysctl: Reduce sys_sysctl to a compatibility wrapper around /proc/sys
      sysctl: Neuter the generic sysctl strategy routines.
      sysctl: Remove dead code from sysctl_check
      sysctl: Remove references to ctl_name and strategy from the generic sysctl table
      sysctl: Don't look at ctl_name and strategy in the generic code
      sysctl:  Warn about all uses of sys_sysctl.
      sysctl: sysctl_binary.c Fix compilation when !CONFIG_NET
      sysctl binary: Reorder the tests to process wild card entries first.
      sysctl: Remove the unused frv sysctl unumbers
      sysctl: Stop using binary sysctl numbers in arlan.
      sysctl ipc: Remove dead binary sysctl support code.
      sysctl fs: Remove dead binary sysctl support
      sysctl kernel: Remove binary sysctl logic
      sysctl security/keys: Remove dead binary sysctl support
      sysctl crypto: Remove dead binary sysctl support
      sysctl drivers: Remove dead binary sysctl support
      sysctl mips/lasat: Remove dead binary sysctl support
      sysctl frv: Remove dead binary sysctl support
      sysctl s390: Remove dead sysctl binary support
      sysctl ia64: Remove dead binary sysctl support
      sysctl powerpc: Remove dead binary sysctl support
      sysctl sh: Remove dead binary sysctl support
      sysctl x86: Remove dead binary sysctl support
      sysctl arm: Remove binary sysctl support
      sysctl net: Remove unused binary sysctl code
      sysctl: Remove the last of the generic binary sysctl support
      Merge commit 'v2.6.32-rc7'
      sysctl: kill dead ctl_handler definitions.
      sysctl: Remove CTL_NONE and CTL_UNNUMBERED
      sysctl: Drop & in front of every proc_handler.
      security/tomoyo: Add a special case to handle accesses through the internal proc mount.
      security/tomoyo: Remove now unnecessary handling of security_sysctl.
      Merge branch 'master' of git://git.kernel.org/.../ebiederm/sysctl-2.6

Tetsuo Handa (1):
      sysctl security/tomoyo: Don't look at ctl_name


 Documentation/sysctl/ctl_unnumbered.txt        |   22 -
 arch/arm/kernel/isa.c                          |   17 +-
 arch/arm/mach-bcmring/arch.c                   |    8 +-
 arch/frv/kernel/pm.c                           |  114 +--
 arch/frv/kernel/sysctl.c                       |    7 +-
 arch/ia64/ia32/ia32_entry.S                    |    2 +-
 arch/ia64/ia32/sys_ia32.c                      |   55 -
 arch/ia64/kernel/crash.c                       |   11 +-
 arch/ia64/kernel/perfmon.c                     |   14 +-
 arch/mips/kernel/linux32.c                     |   61 -
 arch/mips/kernel/scall64-n32.S                 |    2 +-
 arch/mips/kernel/scall64-o32.S                 |    2 +-
 arch/mips/lasat/sysctl.c                       |  121 +--
 arch/parisc/kernel/sys_parisc32.c              |   71 --
 arch/parisc/kernel/syscall_table.S             |    2 +-
 arch/powerpc/kernel/idle.c                     |    4 +-
 arch/powerpc/kernel/sys_ppc32.c                |   52 -
 arch/s390/appldata/appldata_base.c             |    4 +-
 arch/s390/kernel/compat_linux.c                |   53 -
 arch/s390/kernel/compat_linux.h                |    2 -
 arch/s390/kernel/compat_wrapper.S              |    6 +-
 arch/s390/kernel/debug.c                       |   13 +-
 arch/s390/mm/cmm.c                             |   11 +-
 arch/sh/kernel/traps_64.c                      |   13 +-
 arch/sparc/kernel/sys_sparc32.c                |   57 -
 arch/sparc/kernel/systbls_64.S                 |    2 +-
 arch/x86/ia32/ia32entry.S                      |    2 +-
 arch/x86/ia32/sys_ia32.c                       |   56 -
 arch/x86/include/asm/sys_ia32.h                |    5 -
 arch/x86/kernel/vsyscall_64.c                  |    2 +-
 arch/x86/vdso/vdso32-setup.c                   |    1 -
 crypto/proc.c                                  |   12 +-
 drivers/cdrom/cdrom.c                          |   20 +-
 drivers/char/hpet.c                            |   11 +-
 drivers/char/ipmi/ipmi_poweroff.c              |   11 +-
 drivers/char/pty.c                             |   14 +-
 drivers/char/random.c                          |   54 +-
 drivers/char/rtc.c                             |   11 +-
 drivers/macintosh/mac_hid.c                    |   17 +-
 drivers/md/md.c                                |   14 +-
 drivers/misc/sgi-xp/xpc_main.c                 |   14 +-
 drivers/net/wireless/arlan-proc.c              |  245 ++---
 drivers/parport/procfs.c                       |   39 +-
 drivers/s390/char/sclp_async.c                 |    5 +-
 drivers/scsi/scsi_sysctl.c                     |   11 +-
 fs/coda/sysctl.c                               |   10 +-
 fs/eventpoll.c                                 |    4 +-
 fs/lockd/svc.c                                 |   26 +-
 fs/nfs/sysctl.c                                |   22 +-
 fs/notify/inotify/inotify_user.c               |   14 +-
 fs/ntfs/sysctl.c                               |    4 +-
 fs/ocfs2/stackglue.c                           |   15 +-
 fs/proc/proc_sysctl.c                          |    4 +-
 fs/quota/dquot.c                               |   35 +-
 fs/xfs/linux-2.6/xfs_sysctl.c                  |   62 +-
 include/linux/sysctl.h                         |   44 +-
 include/net/dn_dev.h                           |    1 -
 include/net/neighbour.h                        |    3 +-
 init/Kconfig                                   |    1 +
 ipc/ipc_sysctl.c                               |   77 --
 ipc/mq_sysctl.c                                |    7 +-
 kernel/Makefile                                |    2 +-
 kernel/sched.c                                 |    5 +-
 kernel/slow-work.c                             |    7 +-
 kernel/sys_ni.c                                |    1 -
 kernel/sysctl.c                                |  893 +++------------
 kernel/sysctl_binary.c                         | 1507 ++++++++++++++++++++++++
 kernel/sysctl_check.c                          | 1376 +---------------------
 kernel/utsname_sysctl.c                        |   31 -
 lib/Kconfig.debug                              |    2 +-
 net/802/tr.c                                   |    7 +-
 net/appletalk/sysctl_net_atalk.c               |   13 +-
 net/ax25/sysctl_net_ax25.c                     |   38 +-
 net/bridge/br_netfilter.c                      |    6 +-
 net/core/neighbour.c                           |   47 +-
 net/core/sysctl_net_core.c                     |   21 +-
 net/dccp/sysctl.c                              |    8 +-
 net/decnet/dn_dev.c                            |   64 +-
 net/decnet/sysctl_net_decnet.c                 |  123 +--
 net/ipv4/arp.c                                 |    2 +-
 net/ipv4/devinet.c                             |  111 +--
 net/ipv4/ip_fragment.c                         |    6 -
 net/ipv4/netfilter.c                           |    6 +-
 net/ipv4/netfilter/ip_queue.c                  |    3 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   10 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    8 +-
 net/ipv4/route.c                               |   73 +-
 net/ipv4/sysctl_net_ipv4.c                     |  164 +---
 net/ipv4/xfrm4_policy.c                        |    1 -
 net/ipv6/addrconf.c                            |   90 +--
 net/ipv6/icmp.c                                |    4 +-
 net/ipv6/ndisc.c                               |   39 +-
 net/ipv6/netfilter/ip6_queue.c                 |    4 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    4 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c        |    4 +-
 net/ipv6/reassembly.c                          |    6 -
 net/ipv6/route.c                               |   18 +-
 net/ipv6/sysctl_net_ipv6.c                     |   12 +-
 net/ipv6/xfrm6_policy.c                        |    1 -
 net/ipx/sysctl_net_ipx.c                       |    7 +-
 net/irda/irsysctl.c                            |   31 +-
 net/llc/sysctl_net_llc.c                       |   25 +-
 net/netfilter/core.c                           |    4 +-
 net/netfilter/ipvs/ip_vs_ctl.c                 |    6 +-
 net/netfilter/ipvs/ip_vs_lblc.c                |    2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c               |    2 +-
 net/netfilter/nf_conntrack_acct.c              |    1 -
 net/netfilter/nf_conntrack_ecache.c            |    2 -
 net/netfilter/nf_conntrack_proto_dccp.c        |   12 +-
 net/netfilter/nf_conntrack_proto_generic.c     |    8 +-
 net/netfilter/nf_conntrack_proto_sctp.c        |    8 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |   14 +-
 net/netfilter/nf_conntrack_proto_udp.c         |    8 +-
 net/netfilter/nf_conntrack_proto_udplite.c     |    6 +-
 net/netfilter/nf_conntrack_standalone.c        |   14 +-
 net/netfilter/nf_log.c                         |    7 +-
 net/netrom/sysctl_net_netrom.c                 |   30 +-
 net/phonet/sysctl.c                            |    8 +-
 net/rds/ib_sysctl.c                            |   26 +-
 net/rds/iw_sysctl.c                            |   26 +-
 net/rds/sysctl.c                               |   21 +-
 net/rose/sysctl_net_rose.c                     |   26 +-
 net/sctp/sysctl.c                              |   51 +-
 net/sunrpc/sysctl.c                            |   15 +-
 net/sunrpc/xprtrdma/svc_rdma.c                 |   40 +-
 net/sunrpc/xprtrdma/transport.c                |   32 +-
 net/sunrpc/xprtsock.c                          |   28 +-
 net/unix/sysctl_net_unix.c                     |    7 +-
 net/x25/sysctl_net_x25.c                       |   15 +-
 net/xfrm/xfrm_sysctl.c                         |    4 -
 security/keys/sysctl.c                         |   17 +-
 security/tomoyo/file.c                         |   21 -
 security/tomoyo/realpath.c                     |    9 +
 security/tomoyo/tomoyo.c                       |   80 --
 security/tomoyo/tomoyo.h                       |    2 -
 135 files changed, 2183 insertions(+), 4748 deletions(-)
