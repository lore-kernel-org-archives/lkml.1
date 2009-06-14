Return-Path: <linux-kernel-owner+w=401wt.eu-S1764633AbZFNUsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764633AbZFNUsZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764424AbZFNUr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:47:59 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:56073 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764333AbZFNUr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:47:58 -0400
X-IronPort-AV: E=Sophos;i="4.42,218,1243814400"; 
   d="scan'208";a="169824230"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Sun, 14 Jun 2009 13:47:59 -0700
Message-ID: <ada8wjuy22o.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jun 2009 20:48:00.0118 (UTC) FILETIME=[676D8160:01C9ED31]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This has the main batch of InfiniBand/RDMA changes for 2.6.31; sorry
for being so late in the merge cycle but the whole family was sick
with the stomach flu for the past week and, well, merge requests
weren't a top priority.

Anyway, this has been a slow cycle for my tree for whatever reason, so
there's not much here; everything has been in -next for a while except
for my two IRQ double-free patches, which fix a just-reported bug (and
are tiny and have been tested).

Anton Blanchard (1):
      IB/ehca: Replace vmalloc() with kmalloc() for queue allocation

Eli Cohen (2):
      IB/mthca: Add module parameter for number of MTTs per segment
      mlx4_core: Add module parameter for number of MTTs per segment

Jack Morgenstein (1):
      IB/mlx4: Add strong ordering to local inval and fast reg work requests

Jack Stone (1):
      infiniband: Remove void casts

Joachim Fenkes (1):
      IB/ehca: Remove superfluous bitmasks from QP control block

Roel Kluin (1):
      RDMA/nes: Fix off-by-one bugs in reset_adapter_ne020() and init_serdes()

Roland Dreier (3):
      IB/mthca: Don't double-free IRQs when falling back from MSI-X to INTx
      mlx4_core: Don't double-free IRQs when falling back from MSI-X to INTx
      Merge branches 'cxgb3', 'ehca', 'misc', 'mlx4', 'mthca' and 'nes' into for-linus

Stefan Roscher (3):
      IB/ehca: Fall back to vmalloc() for big allocations
      IB/ehca: Remove unnecessary memory operations for userspace queue pairs
      IB/ehca: Increment version number

Steve Wise (2):
      RDMA/cxgb3: Report correct port state and MTU
      RDMA/cxgb3: Limit fast register size based on T3 limitations

 drivers/infiniband/hw/amso1100/c2_cq.c            |    4 +-
 drivers/infiniband/hw/cxgb3/cxio_wr.h             |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c       |   32 ++++++-
 drivers/infiniband/hw/ehca/ehca_classes_pSeries.h |   28 -----
 drivers/infiniband/hw/ehca/ehca_irq.c             |    9 +-
 drivers/infiniband/hw/ehca/ehca_main.c            |    2 +-
 drivers/infiniband/hw/ehca/ehca_qp.c              |  112 +++++++++++----------
 drivers/infiniband/hw/ehca/hcp_if.c               |    6 +-
 drivers/infiniband/hw/ehca/hcp_if.h               |    2 +-
 drivers/infiniband/hw/ehca/hcp_phyp.c             |   11 ++-
 drivers/infiniband/hw/ehca/hcp_phyp.h             |    2 +-
 drivers/infiniband/hw/ehca/ipz_pt_fn.c            |   19 +++-
 drivers/infiniband/hw/mlx4/qp.c                   |    4 +
 drivers/infiniband/hw/mthca/mthca_cmd.c           |    2 +-
 drivers/infiniband/hw/mthca/mthca_dev.h           |    1 +
 drivers/infiniband/hw/mthca/mthca_eq.c            |    4 +-
 drivers/infiniband/hw/mthca/mthca_main.c          |   17 +++-
 drivers/infiniband/hw/mthca/mthca_mr.c            |   16 ++--
 drivers/infiniband/hw/mthca/mthca_profile.c       |    4 +-
 drivers/infiniband/hw/nes/nes_hw.c                |   14 ++--
 drivers/net/mlx4/eq.c                             |    4 +-
 drivers/net/mlx4/main.c                           |   14 ++-
 drivers/net/mlx4/mr.c                             |    6 +-
 drivers/net/mlx4/profile.c                        |    2 +-
 include/linux/mlx4/device.h                       |    1 +
 include/linux/mlx4/qp.h                           |    1 +
 26 files changed, 183 insertions(+), 136 deletions(-)
