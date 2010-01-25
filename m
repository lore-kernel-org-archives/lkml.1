Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862Ab0AYPTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0AYPTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 10:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865Ab0AYPTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 10:19:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:42938 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab0AYPTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:19:02 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
       x86@kernel.org, mingo@redhat.com, fweisbec@gmail.com,
       dan.j.williams@intel.com, borislav.petkov@amd.com, ying.huang@intel.com,
       lenb@kernel.org, neilb@suse.de, cl@linux-foundation.org
Subject: [PATCHSET] percpu: add __percpu sparse annotations
Date: Tue, 26 Jan 2010 00:22:07 +0900
Message-Id: <1264432935-10453-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 25 Jan 2010 15:17:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds __percpu sparse annotations to all percpu users
covered by x86_64 allmodconfig.  __percpu annotation teaches sparse
that percpu variables live in a separate address space and can't be
accessed directly without going through percpu accessors.  This allows
detection of most percpu access mistakes involving both static and
dyanmic percpu variables.

This patchset contains the following eight patches.

 0001-percpu-add-__percpu-sparse-annotations-to-core-kerne.patch
 0002-percpu-add-__percpu-sparse-annotations-to-fs.patch
 0003-percpu-add-__percpu-sparse-annotations-to-net.patch
 0004-percpu-add-__percpu-sparse-annotations-to-net-driver.patch
 0005-percpu-add-__percpu-sparse-annotations-to-x86.patch
 0006-percpu-add-__percpu-sparse-annotations-to-trace.patch
 0007-percpu-add-__percpu-sparse-annotations-to-hw_breakpo.patch
 0008-percpu-add-__percpu-sparse-annotations-to-what-s-lef.patch

As these annotations are for sparse, none of the above patches affects
normal kernel build and most of the conversions are straight-forward
and trivial.  There are a few places where the conversion isn't
completely straight-forward (but still fairly trivial).  Those are
mentioned in each patch description.

I can route the patch through percpu and conflict resolution, if
necessary, wouldn't be difficult at all for these changes.  If anyone
wants to route one of these patches through a different tree, please
let me know.  All that's necessary would be adding dummy __percpu
definition to the patch.

If nobody objects, I'll push these into percpu tree in three or four
days.

Thanks.

 arch/x86/include/asm/msr.h                 |   12 ++++---
 arch/x86/kernel/acpi/cstate.c              |    2 -
 arch/x86/kernel/cpu/common.c               |    2 -
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 -
 arch/x86/lib/msr-smp.c                     |    8 +++--
 arch/x86/lib/msr.c                         |    6 +--
 crypto/cryptd.c                            |    2 -
 drivers/acpi/processor_perflib.c           |    2 -
 drivers/dma/dmaengine.c                    |    2 -
 drivers/edac/amd64_edac.c                  |    2 -
 drivers/md/raid5.c                         |    2 -
 drivers/md/raid5.h                         |    2 -
 drivers/net/chelsio/sge.c                  |    2 -
 drivers/net/loopback.c                     |   16 +++++-----
 drivers/net/macvlan.c                      |    2 -
 drivers/net/veth.c                         |    4 +-
 fs/ext4/ext4.h                             |    2 -
 fs/nfs/iostat.h                            |    4 +-
 fs/xfs/xfs_mount.h                         |    2 -
 include/acpi/processor.h                   |    2 -
 include/linux/blktrace_api.h               |    4 +-
 include/linux/dmaengine.h                  |    2 -
 include/linux/ftrace_event.h               |    4 +-
 include/linux/genhd.h                      |    2 -
 include/linux/hw_breakpoint.h              |    8 ++---
 include/linux/kexec.h                      |    2 -
 include/linux/mmzone.h                     |    2 -
 include/linux/module.h                     |    2 -
 include/linux/mount.h                      |    2 -
 include/linux/nfs_fs_sb.h                  |    2 -
 include/linux/percpu_counter.h             |    2 -
 include/linux/srcu.h                       |    2 -
 include/net/ip.h                           |    6 +--
 include/net/ipcomp.h                       |    2 -
 include/net/neighbour.h                    |    2 -
 include/net/netns/conntrack.h              |    2 -
 include/net/netns/core.h                   |    2 -
 include/net/route.h                        |    2 -
 include/net/snmp.h                         |   12 +++++--
 include/net/tcp.h                          |    2 -
 include/trace/ftrace.h                     |    4 +-
 kernel/hw_breakpoint.c                     |   14 ++++----
 kernel/kexec.c                             |    2 -
 kernel/sched.c                             |    4 +-
 kernel/stop_machine.c                      |    2 -
 kernel/trace/trace_event_profile.c         |   16 +++++-----
 kernel/trace/trace_functions_graph.c       |    2 -
 kernel/trace/trace_kprobe.c                |    4 +-
 kernel/trace/trace_ksym.c                  |   10 +++---
 kernel/trace/trace_syscalls.c              |    4 +-
 mm/percpu.c                                |   18 ++++++-----
 net/8021q/vlan.h                           |    2 -
 net/dccp/proto.c                           |    5 +--
 net/ipv4/af_inet.c                         |   46 ++++++++++++++---------------
 net/ipv4/proc.c                            |   28 ++++++++---------
 net/ipv4/route.c                           |    2 -
 net/ipv4/tcp.c                             |   21 +++++++------
 net/ipv6/addrconf.c                        |   24 +++++++--------
 net/ipv6/af_inet6.c                        |   28 ++++++++---------
 net/ipv6/proc.c                            |   24 ++++++++-------
 net/sctp/proc.c                            |    2 -
 net/sctp/protocol.c                        |    5 +--
 net/xfrm/xfrm_ipcomp.c                     |   16 +++++-----
 net/xfrm/xfrm_policy.c                     |    6 +--
 net/xfrm/xfrm_proc.c                       |    3 +
 samples/hw_breakpoint/data_breakpoint.c    |    6 +--
 66 files changed, 231 insertions(+), 209 deletions(-)

--
tejun
