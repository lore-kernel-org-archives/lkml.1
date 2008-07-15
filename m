Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYGOGv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYGOGv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 02:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbYGOGvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 02:51:18 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:50562 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbYGOGvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 02:51:16 -0400
X-IronPort-AV: E=Sophos;i="4.30,364,1212364800"; 
   d="scan'208";a="126783651"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Mon, 14 Jul 2008 23:51:11 -0700
Message-ID: <ada7ibniqsg.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jul 2008 06:51:12.0170 (UTC) FILETIME=[2B3020A0:01C8E647]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the first big batch of RDMA/InfiniBand changes for
2.6.27, all of which have been in linux-next:

Christophe Jaillet (1):
      RDMA/nes: Remove unnecessary memset()

Dotan Barak (1):
      RDMA: Improve include file coding style

Eli Cohen (12):
      IB/mlx4: Optimize QP stamping
      IPoIB: Copy small received SKBs in connected mode
      IB/mlx4: Configure QPs' max message size based on real device capability
      IB/mlx4: Pass congestion management class MADs to the HCA
      IPoIB: Remove unused IPOIB_MCAST_STARTED code
      IPoIB: Remove priv->mcast_mutex
      IPoIB: Only set Q_Key once: after joining broadcast group
      IPoIB: Use rtnl lock/unlock when changing device flags
      IPoIB: Use dev_set_mtu() to change mtu
      IPoIB/cm: Reduce connected mode TX object size
      IPoIB: Double default RX/TX ring sizes
      IB/mlx4: Use kzalloc() for new QPs so flags are initialized to 0

Joachim Fenkes (2):
      IB/ehca: Reject receive work requests if QP is in RESET state
      IB/ehca: Make device table externally visible

Jon Mason (1):
      RDMA/cxgb3: Propagate HW page size capabilities

Moni Shoua (2):
      IB/sa: Fail requests made while creating new SM AH
      IPoIB: Refresh paths instead of flushing them on SM change events

Or Gerlitz (2):
      RDMA/addr: Keep pointer to netdevice in struct rdma_dev_addr
      RDMA/cma: Simplify locking needed for serialization of callbacks

Ralph Campbell (2):
      IB/core: Reset to error QP state transition is not allowed
      IB/ipath: Use IEEE OUI for vendor_id reported by ibv_query_device()

Robert P. J. Day (1):
      IB/ipath: Simplify code using ARRAY_SIZE() macro

Roland Dreier (13):
      IB/srp: Remove use of cached P_Key/GID queries
      RDMA: Remove subversion $Id tags
      IB/mthca: Remove extra code for RESET->ERR QP state transition
      IB/mlx4: Remove extra code for RESET->ERR QP state transition
      RDMA/cxgb3: Remove write-only iwch_rnic_attributes fields
      RDMA/cma: Add missing newlines to printk()s
      IPoIB/cm: Fix racy use of receive WR/SGL in ipoib_cm_post_receive_nonsrq()
      RDMA/nes: Encapsulate logic nes_put_cqp_request()
      RDMA/nes: Get rid of ring_doorbell parameter of nes_post_cqp_request()
      IPoIB: Get rid of ipoib_mcast_detach() wrapper
      IB/mthca: Remove "stop" flag for catastrophic error polling timer
      IB/mthca: Use round_jiffies() for catastrophic error polling timer
      IB/mthca: Fix check of max_send_sge for special QPs

Ron Livne (3):
      IB/core: Add support for multicast loopback blocking
      IB/mlx4: Add support for blocking multicast loopback packets
      IPoIB: Use multicast loopback blocking if available

Sean Hefty (1):
      RDMA: Fix license text

Stefan Roscher (1):
      IB/ehca: In case of lost interrupts, trigger EOI to reenable interrupts

Steve Wise (8):
      RDMA/core: Add memory management extensions support
      RDMA/cxgb3: MEM_MGT_EXTENSIONS support
      RDMA/cxgb3: Fix up some ib_device_attr fields
      RDMA/core: Add iWARP protocol statistics attributes in sysfs
      RDMA/cxgb3: Add support for protocol statistics
      RDMA/cxgb3: Set rkey field for new memory windows in iwch_alloc_mw()
      RDMA/core: Add local DMA L_Key support
      RDMA/cxgb3: Fixes for zero STag

Vladimir Sokolovsky (2):
      IPoIB: add LRO support
      mlx4_core: Use MOD_STAT_CFG command to get minimal page size

 drivers/infiniband/core/addr.c                 |   42 +++--
 drivers/infiniband/core/agent.h                |    2 -
 drivers/infiniband/core/cache.c                |    2 -
 drivers/infiniband/core/cm.c                   |    2 -
 drivers/infiniband/core/cma.c                  |  162 ++++++++--------
 drivers/infiniband/core/core_priv.h            |    2 -
 drivers/infiniband/core/device.c               |    2 -
 drivers/infiniband/core/fmr_pool.c             |    2 -
 drivers/infiniband/core/mad_priv.h             |    2 -
 drivers/infiniband/core/mad_rmpp.c             |    2 -
 drivers/infiniband/core/mad_rmpp.h             |    2 -
 drivers/infiniband/core/packer.c               |    2 -
 drivers/infiniband/core/sa_query.c             |   24 ++-
 drivers/infiniband/core/sysfs.c                |  122 +++++++++++-
 drivers/infiniband/core/ucm.c                  |    2 -
 drivers/infiniband/core/ud_header.c            |    2 -
 drivers/infiniband/core/umem.c                 |    2 -
 drivers/infiniband/core/user_mad.c             |    2 -
 drivers/infiniband/core/uverbs.h               |    2 -
 drivers/infiniband/core/uverbs_cmd.c           |    4 +-
 drivers/infiniband/core/uverbs_main.c          |    2 -
 drivers/infiniband/core/verbs.c                |   49 ++++-
 drivers/infiniband/hw/amso1100/c2_rnic.c       |    2 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c         |   27 ++-
 drivers/infiniband/hw/cxgb3/cxio_hal.h         |    5 +-
 drivers/infiniband/hw/cxgb3/cxio_wr.h          |  103 ++++++++--
 drivers/infiniband/hw/cxgb3/iwch.c             |    8 +-
 drivers/infiniband/hw/cxgb3/iwch.h             |    2 -
 drivers/infiniband/hw/cxgb3/iwch_cq.c          |   15 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |  199 +++++++++++++++++-
 drivers/infiniband/hw/cxgb3/iwch_provider.h    |    8 -
 drivers/infiniband/hw/cxgb3/iwch_qp.c          |  261 ++++++++++++++++++------
 drivers/infiniband/hw/ehca/ehca_irq.c          |    9 +-
 drivers/infiniband/hw/ehca/ehca_main.c         |    1 +
 drivers/infiniband/hw/ehca/ehca_reqs.c         |   14 +-
 drivers/infiniband/hw/ehca/hcp_if.c            |   10 +
 drivers/infiniband/hw/ehca/hcp_if.h            |    1 +
 drivers/infiniband/hw/ipath/ipath_cq.c         |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba7220.c    |    4 +-
 drivers/infiniband/hw/ipath/ipath_mad.c        |    6 +-
 drivers/infiniband/hw/ipath/ipath_rc.c         |    4 +-
 drivers/infiniband/hw/ipath/ipath_ruc.c        |    4 +-
 drivers/infiniband/hw/ipath/ipath_uc.c         |    8 +-
 drivers/infiniband/hw/ipath/ipath_ud.c         |    8 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c      |    3 +-
 drivers/infiniband/hw/mlx4/cq.c                |   12 +-
 drivers/infiniband/hw/mlx4/mad.c               |    3 +-
 drivers/infiniband/hw/mlx4/main.c              |    7 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |    3 +-
 drivers/infiniband/hw/mlx4/qp.c                |   73 +++----
 drivers/infiniband/hw/mthca/mthca_allocator.c  |    2 -
 drivers/infiniband/hw/mthca/mthca_av.c         |    2 -
 drivers/infiniband/hw/mthca/mthca_catas.c      |   17 +--
 drivers/infiniband/hw/mthca/mthca_cmd.c        |    2 -
 drivers/infiniband/hw/mthca/mthca_cmd.h        |    2 -
 drivers/infiniband/hw/mthca/mthca_config_reg.h |    2 -
 drivers/infiniband/hw/mthca/mthca_cq.c         |    6 +-
 drivers/infiniband/hw/mthca/mthca_dev.h        |    3 -
 drivers/infiniband/hw/mthca/mthca_doorbell.h   |    2 -
 drivers/infiniband/hw/mthca/mthca_eq.c         |    2 -
 drivers/infiniband/hw/mthca/mthca_mad.c        |    2 -
 drivers/infiniband/hw/mthca/mthca_main.c       |    2 -
 drivers/infiniband/hw/mthca/mthca_mcg.c        |    2 -
 drivers/infiniband/hw/mthca/mthca_memfree.c    |    2 -
 drivers/infiniband/hw/mthca/mthca_memfree.h    |    2 -
 drivers/infiniband/hw/mthca/mthca_mr.c         |    2 -
 drivers/infiniband/hw/mthca/mthca_pd.c         |    2 -
 drivers/infiniband/hw/mthca/mthca_profile.c    |    2 -
 drivers/infiniband/hw/mthca/mthca_profile.h    |    2 -
 drivers/infiniband/hw/mthca/mthca_provider.c   |    2 -
 drivers/infiniband/hw/mthca/mthca_provider.h   |    2 -
 drivers/infiniband/hw/mthca/mthca_qp.c         |   32 +---
 drivers/infiniband/hw/mthca/mthca_reset.c      |    2 -
 drivers/infiniband/hw/mthca/mthca_srq.c        |    2 -
 drivers/infiniband/hw/mthca/mthca_uar.c        |    2 -
 drivers/infiniband/hw/mthca/mthca_user.h       |    1 -
 drivers/infiniband/hw/mthca/mthca_wqe.h        |    2 -
 drivers/infiniband/hw/nes/nes.c                |    2 +-
 drivers/infiniband/hw/nes/nes.h                |    9 +-
 drivers/infiniband/hw/nes/nes_cm.c             |    1 -
 drivers/infiniband/hw/nes/nes_hw.c             |   68 +-----
 drivers/infiniband/hw/nes/nes_hw.h             |    2 +-
 drivers/infiniband/hw/nes/nes_utils.c          |   33 +++-
 drivers/infiniband/hw/nes/nes_verbs.c          |  207 ++++---------------
 drivers/infiniband/ulp/ipoib/Kconfig           |    1 +
 drivers/infiniband/ulp/ipoib/ipoib.h           |   48 ++++--
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  104 +++++++---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |   46 ++++
 drivers/infiniband/ulp/ipoib/ipoib_fs.c        |    2 -
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |   52 +++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  115 ++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   27 +--
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |   69 +++----
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |    2 -
 drivers/infiniband/ulp/iser/iscsi_iser.c       |    3 -
 drivers/infiniband/ulp/iser/iscsi_iser.h       |    2 -
 drivers/infiniband/ulp/iser/iser_initiator.c   |    2 -
 drivers/infiniband/ulp/iser/iser_memory.c      |    2 -
 drivers/infiniband/ulp/iser/iser_verbs.c       |    2 -
 drivers/infiniband/ulp/srp/ib_srp.c            |   15 +-
 drivers/infiniband/ulp/srp/ib_srp.h            |    2 -
 drivers/net/cxgb3/cxgb3_ctl_defs.h             |    1 +
 drivers/net/cxgb3/cxgb3_offload.c              |    7 +
 drivers/net/cxgb3/version.h                    |    2 +-
 drivers/net/mlx4/fw.c                          |   28 +++
 drivers/net/mlx4/fw.h                          |    6 +
 drivers/net/mlx4/main.c                        |    7 +
 drivers/net/mlx4/mcg.c                         |   17 ++-
 include/linux/mlx4/device.h                    |    3 +-
 include/rdma/ib_addr.h                         |   43 +++--
 include/rdma/ib_cache.h                        |    2 -
 include/rdma/ib_cm.h                           |    2 -
 include/rdma/ib_fmr_pool.h                     |    4 +-
 include/rdma/ib_mad.h                          |   17 +-
 include/rdma/ib_pack.h                         |    2 -
 include/rdma/ib_sa.h                           |    2 -
 include/rdma/ib_smi.h                          |    4 +-
 include/rdma/ib_user_cm.h                      |    2 -
 include/rdma/ib_user_mad.h                     |    2 -
 include/rdma/ib_user_verbs.h                   |    7 +-
 include/rdma/ib_verbs.h                        |  149 +++++++++++++-
 include/rdma/iw_cm.h                           |    2 +-
 include/rdma/rdma_cm.h                         |   52 +++---
 include/rdma/rdma_cm_ib.h                      |   50 +++--
 124 files changed, 1632 insertions(+), 935 deletions(-)
