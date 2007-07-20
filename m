Return-Path: <linux-kernel-owner+w=401wt.eu-S934630AbXGTB3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934630AbXGTB3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761012AbXGTB3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:29:14 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:58309 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760856AbXGTB3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:29:12 -0400
Date: Fri, 20 Jul 2007 10:28:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] mm: Remove slab destructors from kmem_cache_create().
Message-ID: <20070720012846.GA22487@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Slab destructors were no longer supported after Christoph's
c59def9f222d44bb7e2f0a559f2906191a0862d7 change. They've been
BUGs for both slab and slub, and slob never supported them
either.

This rips out support for the dtor pointer from kmem_cache_create()
completely and fixes up every single callsite in the kernel (there were
about 224, not including the slab allocator definitions themselves,
or the documentation references).

Perhaps this is something that should go in later, as it does
cause a bit of churn across the tree. However, there shouldn't be
anything here that causes trouble for git merges, as it's all pretty
straightforward removal. I've placed it in a git tree to pull as it's
quite large, and not terribly interesting.

If you want this single change, please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git kmem_death

Which contains:

Paul Mundt (1):
      mm: Remove slab destructors from kmem_cache_create().

 arch/arm/plat-s3c24xx/dma.c               |    2 +-
 arch/arm26/mm/memc.c                      |    4 ++--
 arch/i386/mm/init.c                       |    3 +--
 arch/ia64/ia32/ia32_support.c             |    2 +-
 arch/powerpc/kernel/rtas_flash.c          |    2 +-
 arch/powerpc/mm/hugetlbpage.c             |    2 +-
 arch/powerpc/mm/init_64.c                 |    3 +--
 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 arch/sh/kernel/cpu/sh4/sq.c               |    3 +--
 arch/sh/mm/pmb.c                          |    2 +-
 arch/sparc64/mm/tsb.c                     |    3 +--
 block/bsg.c                               |    2 +-
 block/ll_rw_blk.c                         |    6 +++---
 drivers/acpi/osl.c                        |    2 +-
 drivers/block/aoe/aoeblk.c                |    4 ++--
 drivers/ieee1394/eth1394.c                |    2 +-
 drivers/infiniband/core/mad.c             |    1 -
 drivers/infiniband/hw/amso1100/c2_vq.c    |    2 +-
 drivers/infiniband/hw/ehca/ehca_av.c      |    2 +-
 drivers/infiniband/hw/ehca/ehca_cq.c      |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c    |    2 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c    |    4 ++--
 drivers/infiniband/hw/ehca/ehca_pd.c      |    2 +-
 drivers/infiniband/hw/ehca/ehca_qp.c      |    2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c  |    2 +-
 drivers/kvm/mmu.c                         |    8 ++++----
 drivers/md/raid5.c                        |    4 ++--
 drivers/message/i2o/i2o_block.c           |    3 +--
 drivers/mtd/ubi/eba.c                     |    2 +-
 drivers/mtd/ubi/wl.c                      |    2 +-
 drivers/s390/block/dasd_devmap.c          |    2 +-
 drivers/s390/scsi/zfcp_aux.c              |    6 +++---
 drivers/scsi/aic94xx/aic94xx_init.c       |    4 ++--
 drivers/scsi/libsas/sas_init.c            |    2 +-
 drivers/scsi/qla2xxx/qla_os.c             |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c             |    2 +-
 drivers/scsi/scsi.c                       |    2 +-
 drivers/scsi/scsi_lib.c                   |    4 ++--
 drivers/scsi/scsi_tgt_lib.c               |    2 +-
 drivers/usb/host/uhci-hcd.c               |    2 +-
 drivers/usb/mon/mon_text.c                |    2 +-
 fs/adfs/super.c                           |    4 ++--
 fs/affs/super.c                           |    2 +-
 fs/afs/super.c                            |    3 +--
 fs/befs/linuxvfs.c                        |    4 ++--
 fs/bfs/inode.c                            |    4 ++--
 fs/bio.c                                  |    2 +-
 fs/block_dev.c                            |    2 +-
 fs/cifs/cifsfs.c                          |   10 +++++-----
 fs/coda/inode.c                           |    4 ++--
 fs/configfs/mount.c                       |    2 +-
 fs/dcache.c                               |    4 ++--
 fs/dcookies.c                             |    2 +-
 fs/dlm/lowcomms.c                         |    2 +-
 fs/dlm/memory.c                           |    2 +-
 fs/dnotify.c                              |    2 +-
 fs/dquot.c                                |    4 ++--
 fs/ecryptfs/main.c                        |    2 +-
 fs/efs/super.c                            |    4 ++--
 fs/eventpoll.c                            |    4 ++--
 fs/ext2/super.c                           |    4 ++--
 fs/ext3/super.c                           |    2 +-
 fs/ext4/super.c                           |    2 +-
 fs/fat/cache.c                            |    2 +-
 fs/fat/inode.c                            |    2 +-
 fs/fcntl.c                                |    2 +-
 fs/freevxfs/vxfs_super.c                  |    4 ++--
 fs/fuse/dev.c                             |    2 +-
 fs/fuse/inode.c                           |    2 +-
 fs/gfs2/main.c                            |    6 +++---
 fs/hfs/super.c                            |    2 +-
 fs/hfsplus/super.c                        |    2 +-
 fs/hpfs/super.c                           |    4 ++--
 fs/hugetlbfs/inode.c                      |    2 +-
 fs/inode.c                                |    3 +--
 fs/inotify_user.c                         |    4 ++--
 fs/isofs/inode.c                          |    2 +-
 fs/jbd/journal.c                          |    8 +++-----
 fs/jbd/revoke.c                           |    4 ++--
 fs/jbd2/journal.c                         |    8 +++-----
 fs/jbd2/revoke.c                          |    4 ++--
 fs/jffs2/malloc.c                         |   18 +++++++++---------
 fs/jffs2/super.c                          |    2 +-
 fs/jfs/jfs_metapage.c                     |    2 +-
 fs/jfs/super.c                            |    2 +-
 fs/locks.c                                |    2 +-
 fs/mbcache.c                              |    2 +-
 fs/minix/inode.c                          |    4 ++--
 fs/namespace.c                            |    2 +-
 fs/ncpfs/inode.c                          |    4 ++--
 fs/nfs/direct.c                           |    2 +-
 fs/nfs/inode.c                            |    4 ++--
 fs/nfs/pagelist.c                         |    2 +-
 fs/nfs/read.c                             |    2 +-
 fs/nfs/write.c                            |    2 +-
 fs/nfsd/nfs4state.c                       |    8 ++++----
 fs/ntfs/super.c                           |   10 +++++-----
 fs/ocfs2/dlm/dlmfs.c                      |    2 +-
 fs/ocfs2/dlm/dlmmaster.c                  |    2 +-
 fs/ocfs2/super.c                          |    2 +-
 fs/ocfs2/uptodate.c                       |    2 +-
 fs/openpromfs/inode.c                     |    2 +-
 fs/proc/inode.c                           |    4 ++--
 fs/qnx4/inode.c                           |    2 +-
 fs/reiserfs/super.c                       |    2 +-
 fs/romfs/inode.c                          |    4 ++--
 fs/smbfs/inode.c                          |    4 ++--
 fs/smbfs/request.c                        |    2 +-
 fs/sysfs/mount.c                          |    2 +-
 fs/sysv/inode.c                           |    2 +-
 fs/udf/super.c                            |    2 +-
 fs/ufs/super.c                            |    4 ++--
 fs/xfs/linux-2.6/kmem.h                   |    4 ++--
 include/linux/i2o.h                       |    3 +--
 include/linux/slab.h                      |    3 +--
 ipc/mqueue.c                              |    2 +-
 kernel/fork.c                             |   18 +++++++++---------
 kernel/nsproxy.c                          |    2 +-
 kernel/posix-timers.c                     |    2 +-
 kernel/user.c                             |    2 +-
 lib/idr.c                                 |    2 +-
 lib/radix-tree.c                          |    2 +-
 mm/mempolicy.c                            |    4 ++--
 mm/rmap.c                                 |    2 +-
 mm/shmem.c                                |    2 +-
 mm/slab.c                                 |   17 +++++++----------
 mm/slob.c                                 |    3 +--
 mm/slub.c                                 |    4 +---
 net/bridge/br_fdb.c                       |    2 +-
 net/core/flow.c                           |    2 +-
 net/core/neighbour.c                      |    2 +-
 net/core/skbuff.c                         |    4 ++--
 net/core/sock.c                           |    6 +++---
 net/dccp/ackvec.c                         |    4 ++--
 net/dccp/ccid.c                           |    2 +-
 net/dccp/ccids/lib/loss_interval.c        |    2 +-
 net/dccp/ccids/lib/packet_history.c       |    4 ++--
 net/dccp/proto.c                          |    2 +-
 net/decnet/dn_route.c                     |    2 +-
 net/decnet/dn_table.c                     |    2 +-
 net/ipv4/fib_hash.c                       |    4 ++--
 net/ipv4/fib_trie.c                       |    2 +-
 net/ipv4/inetpeer.c                       |    2 +-
 net/ipv4/ipmr.c                           |    2 +-
 net/ipv4/ipvs/ip_vs_conn.c                |    2 +-
 net/ipv4/route.c                          |    2 +-
 net/ipv4/tcp.c                            |    2 +-
 net/ipv6/ip6_fib.c                        |    2 +-
 net/ipv6/route.c                          |    2 +-
 net/ipv6/xfrm6_tunnel.c                   |    2 +-
 net/netfilter/nf_conntrack_core.c         |    2 +-
 net/netfilter/nf_conntrack_expect.c       |    2 +-
 net/netfilter/xt_hashlimit.c              |    2 +-
 net/rxrpc/af_rxrpc.c                      |    2 +-
 net/sctp/protocol.c                       |    4 ++--
 net/socket.c                              |    3 +--
 net/sunrpc/rpc_pipe.c                     |    2 +-
 net/sunrpc/sched.c                        |    4 ++--
 net/tipc/handler.c                        |    2 +-
 net/xfrm/xfrm_input.c                     |    2 +-
 net/xfrm/xfrm_policy.c                    |    2 +-
 security/keys/key.c                       |    2 +-
 security/selinux/avc.c                    |    2 +-
 security/selinux/hooks.c                  |    2 +-
 security/selinux/ss/avtab.c               |    2 +-
 165 files changed, 247 insertions(+), 268 deletions(-)
