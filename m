Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYGXPlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYGXPlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbYGXPlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:41:23 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:9074 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbYGXPlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:41:21 -0400
X-IronPort-AV: E=Sophos;i="4.31,247,1215388800"; 
   d="scan'208";a="89710807"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Thu, 24 Jul 2008 08:41:04 -0700
Message-ID: <adazlo7war3.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Jul 2008 15:41:05.0261 (UTC) FILETIME=[AF1091D0:01C8EDA3]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the some more RDMA/InfiniBand changes for 2.6.27, all of
which have been in linux-next:

Amir Vadai (1):
      RDMA/cma: Add RDMA_CM_EVENT_TIMEWAIT_EXIT event

Dotan Barak (1):
      RDMA/iwcm: Remove IB_ACCESS_LOCAL_WRITE from remote QP attributes

Jack Morgenstein (2):
      mlx4_core: Add module parameter to enable QoS support
      mlx4_code: Add missing FW status return code

Joachim Fenkes (2):
      IB/ehca: Filter PATH_MIG events if QP was never armed
      IB/ehca: Use default value for Local CA ACK Delay if FW returns 0

Julia Lawall (1):
      IB/ehca: Release mutex in error path of alloc_small_queue_page()

Or Gerlitz (3):
      RDMA/cma: Add RDMA_CM_EVENT_ADDR_CHANGE event
      IB/iser: Add support for RDMA_CM_EVENT_ADDR_CHANGE event
      IPoIB: Include err code in trace message for ib_sa_path_rec_get() failures

Ralph Campbell (1):
      IB/sa_query: Check if sm_ah is NULL in ib_sa_remove_one()

Roland Dreier (7):
      IB/mlx4: Rename struct mlx4_lso_seg to mlx4_wqe_lso_seg
      mlx4_core: Keep free count for MTT buddy allocator
      IB/mthca: Keep free count for MTT buddy allocator
      IB/mlx4: Add support for memory management extensions and local DMA L_Key
      mlx4_core: Improve error message when not enough UAR pages are available
      MAINTAINERS: Remove Glenn Streiff from NetEffect entry
      Merge branches 'bkl-removal', 'cma', 'ehca', 'for-2.6.27', 'mlx4', 'mthca' and 'nes' into for-linus

 MAINTAINERS                               |    2 -
 drivers/infiniband/core/cma.c             |   99 ++++++++++++++++++++++++++++-
 drivers/infiniband/core/iwcm.c            |    3 +-
 drivers/infiniband/core/sa_query.c        |    3 +-
 drivers/infiniband/hw/ehca/ehca_classes.h |    1 +
 drivers/infiniband/hw/ehca/ehca_hca.c     |    4 +-
 drivers/infiniband/hw/ehca/ehca_irq.c     |    4 +
 drivers/infiniband/hw/ehca/ehca_qp.c      |    2 +
 drivers/infiniband/hw/ehca/ipz_pt_fn.c    |    1 +
 drivers/infiniband/hw/mlx4/cq.c           |   12 ++++
 drivers/infiniband/hw/mlx4/main.c         |   11 +++
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |   15 +++++
 drivers/infiniband/hw/mlx4/mr.c           |   70 ++++++++++++++++++++
 drivers/infiniband/hw/mlx4/qp.c           |   74 ++++++++++++++++++++--
 drivers/infiniband/hw/mthca/mthca_dev.h   |    1 +
 drivers/infiniband/hw/mthca/mthca_mr.c    |   26 +++++---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c  |    1 +
 drivers/net/mlx4/cmd.c                    |    3 +
 drivers/net/mlx4/fw.c                     |   18 +++--
 drivers/net/mlx4/fw.h                     |    2 +-
 drivers/net/mlx4/main.c                   |    2 +
 drivers/net/mlx4/mlx4.h                   |    1 +
 drivers/net/mlx4/mr.c                     |   49 +++++++++++----
 drivers/net/mlx4/pd.c                     |    7 ++
 include/linux/mlx4/device.h               |   10 +++
 include/linux/mlx4/qp.h                   |   18 ++++--
 include/rdma/rdma_cm.h                    |    4 +-
 28 files changed, 396 insertions(+), 49 deletions(-)
