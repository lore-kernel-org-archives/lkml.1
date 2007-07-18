Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbXGRWxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbXGRWxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763971AbXGRWxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:53:40 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:12106 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763467AbXGRWxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:53:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAKs2nkarR7PD/2dsb2JhbAA
X-IronPort-AV: i="4.16,552,1175497200"; 
   d="scan'208"; a="504683379:sNHT34172994"
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 18 Jul 2007 15:52:57 -0700
Message-ID: <adaodi9iat2.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jul 2007 22:52:57.0319 (UTC) FILETIME=[622FD770:01C7C98E]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get another batch of changes for 2.6.23, including the
beginnings of cleaning up the work request posting code in mthca and
mlx4:

Dotan Barak (2):
      IB/mlx4: Take sizeof the correct pointer in call to memset()
      RDMA/cma: Remove local write permission from QP access flags

Hoang-Nam Nguyen (7):
      IB/ehca: Fix memory leak in error path of ehca_get_dma_mr()
      IB/ehca: Use common error code mapping instead of specific ones
      IB/ehca: Use #define for "pages per register_rpage" instead of hardcoded value
      IB/ehca: Use macro to calculate number of chunks in a mem block
      IB/ehca: MR/MW structure refactoring
      IB/ehca: Restructure ehca_set_pagebuf()
      IB/ehca: Fix warnings issued by checkpatch.pl

Jack Morgenstein (4):
      IB/mlx4: Fix flow label returned from query QP
      IB/mlx4: Fix port returned from query QP for QPs in INIT state
      mlx4_core: Reset device when internal error is detected
      IB/mlx4: Increase max outstanding RDMA reads as target

Joachim Fenkes (1):
      IB/ehca: Fix HW level autodetection

Roland Dreier (14):
      IB/mthca: Schedule MSI support for removal
      IB/mthca: Fix printk format used for firmware version in warning
      IB/iser: Make a couple of functions static
      IB/ipath: Make a few functions static
      IB/ipath: Remove ipath_get_user_pages_nocopy()
      IB/cm: Make internal function cm_get_ack_delay() static
      IB/mthca: Use uninitialized_var() for f0
      IB/mlx4: Return receive queue sizes for userspace QPs from query QP
      IB/mthca: Factor out setting WQE data segment entries
      IB/mlx4: Factor out setting WQE data segment entries
      IB/mlx4: Factor out setting other WQE segments
      IB/mthca: Factor out setting WQE remote address and atomic segment entries
      IB/mthca: Factor out setting WQE UD segment entries
      IB/mthca: Simplify use of size0 in work request posting

Steve Wise (1):
      RDMA/cxgb3: Remove cm_id reference on listen failures

 Documentation/feature-removal-schedule.txt        |   10 +
 drivers/infiniband/core/cm.c                      |    2 +-
 drivers/infiniband/core/cma.c                     |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c             |    1 +
 drivers/infiniband/hw/ehca/ehca_av.c              |    2 +-
 drivers/infiniband/hw/ehca/ehca_classes.h         |   54 +-
 drivers/infiniband/hw/ehca/ehca_classes_pSeries.h |  156 ++--
 drivers/infiniband/hw/ehca/ehca_cq.c              |    2 +-
 drivers/infiniband/hw/ehca/ehca_eq.c              |    3 +-
 drivers/infiniband/hw/ehca/ehca_hca.c             |   28 +-
 drivers/infiniband/hw/ehca/ehca_irq.c             |   56 +-
 drivers/infiniband/hw/ehca/ehca_iverbs.h          |    7 +-
 drivers/infiniband/hw/ehca/ehca_main.c            |   50 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c            | 1087 ++++++++-------------
 drivers/infiniband/hw/ehca/ehca_mrmw.h            |   21 +-
 drivers/infiniband/hw/ehca/ehca_qes.h             |   22 +-
 drivers/infiniband/hw/ehca/ehca_qp.c              |   39 +-
 drivers/infiniband/hw/ehca/ehca_reqs.c            |   15 +-
 drivers/infiniband/hw/ehca/ehca_tools.h           |   31 +-
 drivers/infiniband/hw/ehca/ehca_uverbs.c          |   10 +-
 drivers/infiniband/hw/ehca/hcp_if.c               |    8 +-
 drivers/infiniband/hw/ehca/hcp_phyp.c             |    2 +-
 drivers/infiniband/hw/ehca/hipz_fns_core.h        |    4 +-
 drivers/infiniband/hw/ehca/hipz_hw.h              |   24 +-
 drivers/infiniband/hw/ehca/ipz_pt_fn.c            |    2 +-
 drivers/infiniband/hw/ehca/ipz_pt_fn.h            |    4 +-
 drivers/infiniband/hw/ipath/ipath_driver.c        |    2 +-
 drivers/infiniband/hw/ipath/ipath_eeprom.c        |    4 +-
 drivers/infiniband/hw/ipath/ipath_intr.c          |    2 +-
 drivers/infiniband/hw/ipath/ipath_kernel.h        |    2 -
 drivers/infiniband/hw/ipath/ipath_ruc.c           |    2 +-
 drivers/infiniband/hw/ipath/ipath_user_pages.c    |   26 -
 drivers/infiniband/hw/ipath/ipath_verbs.c         |    2 +-
 drivers/infiniband/hw/ipath/ipath_verbs.h         |    4 -
 drivers/infiniband/hw/mlx4/qp.c                   |  115 ++-
 drivers/infiniband/hw/mthca/mthca_main.c          |   22 +-
 drivers/infiniband/hw/mthca/mthca_qp.c            |  221 ++---
 drivers/infiniband/hw/mthca/mthca_srq.c           |   28 +-
 drivers/infiniband/hw/mthca/mthca_wqe.h           |   15 +
 drivers/infiniband/ulp/iser/iscsi_iser.h          |    5 -
 drivers/infiniband/ulp/iser/iser_memory.c         |    4 +-
 drivers/infiniband/ulp/iser/iser_verbs.c          |   47 +-
 drivers/net/mlx4/catas.c                          |  106 ++-
 drivers/net/mlx4/eq.c                             |   56 +-
 drivers/net/mlx4/intf.c                           |    2 +
 drivers/net/mlx4/main.c                           |   26 +-
 drivers/net/mlx4/mlx4.h                           |   13 +-
 47 files changed, 1055 insertions(+), 1291 deletions(-)
