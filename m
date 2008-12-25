Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbYLYPVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbYLYPVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 10:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYLYPVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 10:21:10 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:56075 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbYLYPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 10:21:08 -0500
X-IronPort-AV: E=Sophos;i="4.36,282,1228089600"; 
   d="scan'208";a="118561576"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Thu, 25 Dec 2008 07:21:04 -0800
Message-ID: <adaiqp8uvq7.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Dec 2008 15:21:07.0064 (UTC) FILETIME=[687FB780:01C966A4]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the first tranche of InfiniBand/RDMA changes for 2.6.29:

Aleksey Senin (2):
      RDMA/addr: Add support for translating IPv6 addresses
      RDMA/cma: Add IPv6 support

Chien Tung (2):
      RDMA/nes: Add loopback check to make_cm_node()
      RDMA/nes: Cleanup warnings

Dave Olson (4):
      IB/ipath: Don't count IB symbol and link errors unless link is UP
      IB/ipath: Only do 1X workaround on rev1 chips
      IB/ipath: Fix spi_pioindex value
      IB/ipath: Add locking for interrupt use of ipath_pd contexts vs free

David Disseldorp (1):
      IB/iser: Avoid recv buffer exhaustion caused by unexpected PDUs

Faisal Latif (7):
      RDMA/nes: Cleanup cqp_request list usage
      RDMA/nes: Lock down connected_nodes list while processing it
      RDMA/nes: Avoid race between MPA request and reset event to rdma_cm
      RDMA/nes: Forward packets for a new connection with stale APBVT entry
      RDMA/nes: Fix TCP compliance test failures
      RDMA/nes: Check cqp_avail_reqs is empty after locking the list
      RDMA/nes: Remove tx_free_list

Jack Morgenstein (1):
      IB/mlx4: Set ownership bit correctly when copying CQEs during CQ resize

Joachim Fenkes (1):
      IB/ehca: Fix locking for shca_list_lock

Julia Lawall (1):
      IB/ehca: Remove redundant test of vpage

Michael Ellerman (1):
      IB/ipath: Fix pointer-to-pointer thinko in ipath_fs.c

Ralph Campbell (3):
      IB/ipath: Improve UD loopback performance by allocating temp array only once
      IB/ipath: Fix PSN of send WQEs after an RDMA read resend
      IB/ipath: Check return value of dma_map_single()

Roland Dreier (2):
      mlx4_core: Delete incorrect comment
      Merge branches 'cma', 'ehca', 'ipath', 'iser', 'mlx4' and 'nes' into for-next

Stefan Roscher (1):
      IB/ehca: Replace modulus operations in flush error completion path

Yevgeny Petrilin (1):
      mlx4_core: Add support for multiple completion event vectors

 drivers/infiniband/core/addr.c                |  196 +++++++++++++----
 drivers/infiniband/core/cma.c                 |   86 ++++++---
 drivers/infiniband/hw/ehca/ehca_classes.h     |    7 +
 drivers/infiniband/hw/ehca/ehca_eq.c          |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c        |   17 +-
 drivers/infiniband/hw/ehca/ehca_qp.c          |   12 +-
 drivers/infiniband/hw/ehca/ehca_reqs.c        |   13 +-
 drivers/infiniband/hw/ipath/ipath_driver.c    |   49 +++--
 drivers/infiniband/hw/ipath/ipath_file_ops.c  |   30 ++--
 drivers/infiniband/hw/ipath/ipath_fs.c        |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6120.c   |   61 ++++++
 drivers/infiniband/hw/ipath/ipath_iba7220.c   |   83 +++++++-
 drivers/infiniband/hw/ipath/ipath_init_chip.c |    1 +
 drivers/infiniband/hw/ipath/ipath_kernel.h    |   15 ++
 drivers/infiniband/hw/ipath/ipath_keys.c      |    2 +
 drivers/infiniband/hw/ipath/ipath_mad.c       |    2 +
 drivers/infiniband/hw/ipath/ipath_qp.c        |   32 ++-
 drivers/infiniband/hw/ipath/ipath_rc.c        |    5 +-
 drivers/infiniband/hw/ipath/ipath_sdma.c      |   21 ++-
 drivers/infiniband/hw/ipath/ipath_stats.c     |    8 +
 drivers/infiniband/hw/ipath/ipath_ud.c        |   19 +--
 drivers/infiniband/hw/ipath/ipath_verbs.c     |    3 +-
 drivers/infiniband/hw/ipath/ipath_verbs.h     |    1 +
 drivers/infiniband/hw/mlx4/cq.c               |   12 +-
 drivers/infiniband/hw/mlx4/main.c             |    2 +-
 drivers/infiniband/hw/nes/nes.h               |   18 +-
 drivers/infiniband/hw/nes/nes_cm.c            |  279 +++++++++++++------------
 drivers/infiniband/hw/nes/nes_cm.h            |   14 +-
 drivers/infiniband/hw/nes/nes_hw.c            |   42 ++--
 drivers/infiniband/hw/nes/nes_utils.c         |    9 +-
 drivers/infiniband/hw/nes/nes_verbs.c         |   45 +---
 drivers/infiniband/ulp/iser/iscsi_iser.h      |    3 +
 drivers/infiniband/ulp/iser/iser_initiator.c  |  132 ++++++++----
 drivers/infiniband/ulp/iser/iser_verbs.c      |    1 +
 drivers/net/mlx4/cq.c                         |   11 +-
 drivers/net/mlx4/en_cq.c                      |    9 +-
 drivers/net/mlx4/en_main.c                    |    4 +-
 drivers/net/mlx4/eq.c                         |  121 ++++++++---
 drivers/net/mlx4/main.c                       |   53 ++++--
 drivers/net/mlx4/mlx4.h                       |   14 +-
 drivers/net/mlx4/profile.c                    |    4 +-
 include/linux/mlx4/device.h                   |    4 +-
 42 files changed, 965 insertions(+), 479 deletions(-)
