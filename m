Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYJJAuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYJJAuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYJJAtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:49:55 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:37286 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbYJJAty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:49:54 -0400
X-IronPort-AV: E=Sophos;i="4.33,385,1220227200"; 
   d="scan'208";a="172252215"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Thu, 09 Oct 2008 17:48:36 -0700
Message-ID: <adar66pjmvv.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Oct 2008 00:48:37.0040 (UTC) FILETIME=[EE0EFB00:01C92A71]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the first batch of 2.6.28 merges -- pretty much all
low-level hardware driver and IP-over-IB fixes, along with a few little
things elsewhere, as the dirstat shows:

  14.4% drivers/infiniband/hw/ehca/
  22.0% drivers/infiniband/hw/mthca/
  33.1% drivers/infiniband/hw/nes/
  26.9% drivers/infiniband/ulp/ipoib/
   3.4% drivers/infiniband/

Full list of patches below:

Alexander Schmidt (1):
      IB/ehca: Generate flush status CQ entries

Bob Sharp (4):
      RDMA/nes: Free NIC TX buffers when destroying NIC QP
      RDMA/nes: Enable MC/UC after changing MTU
      RDMA/nes: Correct MAX TSO frags value
      RDMA/nes: Fix routed RDMA connections

Chien Tung (10):
      RDMA/nes: Add support for 4-port 1G HP blade card
      RDMA/nes: Module parameter permissions
      RDMA/nes: Add wqm_quanta module option
      RDMA/nes: Fix MDC setting
      RDMA/nes: Fill in firmware version for ethtool
      RDMA/nes: Correct tso_wqe_length
      RDMA/nes: Stop spurious MAC interrupts
      RDMA/nes: Limit critical error interrupts
      RDMA/nes: Correct error_module bit mask
      RDMA/nes: Fix slab corruption

Faisal Latif (2):
      RDMA/nes: Make mini_cm_connect() static
      RDMA/nes: Handle AE bounds violation

Hefty, Sean (1):
      IB/cm: Correctly free cm_device structure

John Lacombe (1):
      RDMA/nes: Use ethtool timer value

Jon Mason (1):
      RDMA/cxgb3: Set active_mtu in ib_port_attr

Julia Lawall (1):
      IB: Drop code after return statement

Michael Brooks (1):
      IB/mad: Don't discard BMA responses in kernel

Ralph Campbell (1):
      IB/ipath: Fix SLID generation for RC/UC QPs when LMC > 0

Roland Dreier (4):
      IPoIB: Fix crash when path record fails after path flush
      IB/mthca: Use pci_request_regions()
      IPoIB: Use netif_tx_lock() and get rid of private tx_lock, LLTX
      Merge branches 'cma', 'cxgb3', 'ehca', 'ipath', 'ipoib', 'mad', 'misc', 'mlx4', 'mthca' and 'nes' into for-next

Vadim Makhervaks (1):
      RDMA/nes: Enhanced PFT management scheme

Vladimir Sokolovsky (1):
      IB/mlx4: Set RLKEY bit for kernel QPs

Yannick Cote (1):
      IB/ipath: Fix hang on module unload

 drivers/infiniband/core/cm.c                   |    2 +
 drivers/infiniband/core/mad.c                  |    5 +-
 drivers/infiniband/hw/amso1100/c2_provider.c   |    1 -
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |    9 +-
 drivers/infiniband/hw/ehca/ehca_classes.h      |   14 ++-
 drivers/infiniband/hw/ehca/ehca_cq.c           |    3 +
 drivers/infiniband/hw/ehca/ehca_iverbs.h       |    2 +
 drivers/infiniband/hw/ehca/ehca_qp.c           |  225 ++++++++++++++++++++++--
 drivers/infiniband/hw/ehca/ehca_reqs.c         |  211 +++++++++++++++++++---
 drivers/infiniband/hw/ipath/ipath_rc.c         |    3 +-
 drivers/infiniband/hw/ipath/ipath_ruc.c        |    3 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c      |    7 +
 drivers/infiniband/hw/mlx4/qp.c                |    3 +
 drivers/infiniband/hw/mthca/mthca_catas.c      |   15 +--
 drivers/infiniband/hw/mthca/mthca_eq.c         |   51 +-----
 drivers/infiniband/hw/mthca/mthca_main.c       |   59 +------
 drivers/infiniband/hw/nes/nes.c                |   95 +++++++++-
 drivers/infiniband/hw/nes/nes.h                |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c             |   41 ++++-
 drivers/infiniband/hw/nes/nes_hw.c             |  205 ++++++++++++++++++----
 drivers/infiniband/hw/nes/nes_hw.h             |    6 +
 drivers/infiniband/hw/nes/nes_nic.c            |  122 +++++++++++---
 drivers/infiniband/hw/nes/nes_verbs.c          |    3 -
 drivers/infiniband/ulp/ipoib/ipoib.h           |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |   88 ++++++----
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |   30 +++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   76 ++++-----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   31 ++--
 28 files changed, 961 insertions(+), 359 deletions(-)
