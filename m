Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbYJWEho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbYJWEho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 00:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbYJWEhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 00:37:34 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:33423 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYJWEhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 00:37:33 -0400
X-IronPort-AV: E=Sophos;i="4.33,468,1220227200"; 
   d="scan'208";a="94932429"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Wed, 22 Oct 2008 21:37:31 -0700
Message-ID: <adatzb4sz90.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Oct 2008 04:37:32.0175 (UTC) FILETIME=[103501F0:01C934C9]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the last batch of merges for the 2.6.28 window.  As the
dirstat shows, this is almost entirely the new mlx4_en driver, which
is a 10G Ethernet driver for Mellanox ConnectX adapters:

   1.2% drivers/infiniband/
  98.6% drivers/net/mlx4/

Jeff Garzik and I agreed that this new driver should go through my
tree because it depended on changes to the existing mlx4_ib InfiniBand
driver that I wanted to review and apply through my tree.

Other than mlx4_en, there are just miscellaneous fixes of the usual
type (low-level hardware drivers and IPoIB).

Hoang-Nam Nguyen (1):
      IB/ehca: Don't allow creating UC QP with SRQ

Julien Brunel (1):
      RDMA/ucma: Test ucma_alloc_multicast() return against NULL, not with IS_ERR()

Or Gerlitz (2):
      IPoIB: Clean up ethtool support
      IPoIB: Set netdev offload features properly for child (VLAN) interfaces

Roland Dreier (4):
      IPoIB: Always initialize poll_timer to avoid crash on unload
      IB/mad: Use krealloc() to resize snoop table
      Update NetEffect maintainer emails to Intel emails
      Merge branches 'cma', 'cxgb3', 'ehca', 'ipoib', 'mad', 'mlx4' and 'nes' into for-next

Stefan Roscher (2):
      IB/ehca: Fix reported max number of QPs and CQs in systems with >1 adapter
      IB/ehca: Reject dynamic memory add/remove when ehca adapter is present

Steve Wise (1):
      RDMA/cxgb3: Remove cmid reference on tid allocation failures

Yevgeny Petrilin (7):
      mlx4_core: Add QP range reservation support
      mlx4_core: Support multiple pre-reserved QP regions
      mlx4_core: Get ethernet MTU and default address from firmware
      mlx4_core: Ethernet MAC/VLAN management
      mlx4_core: Multiple port type support
      mlx4_en: Add driver for Mellanox ConnectX 10GbE NIC
      mlx4_core: Add Ethernet PCI device IDs

 MAINTAINERS                                  |    4 +-
 drivers/infiniband/core/mad.c                |   14 +-
 drivers/infiniband/core/ucma.c               |    4 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c        |    1 +
 drivers/infiniband/hw/ehca/ehca_classes.h    |    2 +
 drivers/infiniband/hw/ehca/ehca_cq.c         |    4 +-
 drivers/infiniband/hw/ehca/ehca_main.c       |   83 ++-
 drivers/infiniband/hw/ehca/ehca_qp.c         |   10 +-
 drivers/infiniband/hw/mlx4/mad.c             |    6 +-
 drivers/infiniband/hw/mlx4/main.c            |   11 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |    1 +
 drivers/infiniband/hw/mlx4/qp.c              |   21 +-
 drivers/infiniband/ulp/ipoib/ipoib.h         |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |    9 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c      |    7 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |   67 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c    |    4 +
 drivers/net/Kconfig                          |    9 +
 drivers/net/mlx4/Makefile                    |    7 +-
 drivers/net/mlx4/alloc.c                     |   97 +++-
 drivers/net/mlx4/cq.c                        |    2 +-
 drivers/net/mlx4/en_cq.c                     |  146 ++++
 drivers/net/mlx4/en_main.c                   |  254 ++++++
 drivers/net/mlx4/en_netdev.c                 | 1088 ++++++++++++++++++++++++++
 drivers/net/mlx4/en_params.c                 |  480 ++++++++++++
 drivers/net/mlx4/en_port.c                   |  261 ++++++
 drivers/net/mlx4/en_port.h                   |  570 ++++++++++++++
 drivers/net/mlx4/en_resources.c              |   96 +++
 drivers/net/mlx4/en_rx.c                     | 1080 +++++++++++++++++++++++++
 drivers/net/mlx4/en_tx.c                     |  820 +++++++++++++++++++
 drivers/net/mlx4/eq.c                        |    2 +-
 drivers/net/mlx4/fw.c                        |   20 +-
 drivers/net/mlx4/fw.h                        |    7 +-
 drivers/net/mlx4/main.c                      |  287 +++++++-
 drivers/net/mlx4/mcg.c                       |    4 +-
 drivers/net/mlx4/mlx4.h                      |   45 +-
 drivers/net/mlx4/mlx4_en.h                   |  561 +++++++++++++
 drivers/net/mlx4/mr.c                        |    2 +-
 drivers/net/mlx4/pd.c                        |    4 +-
 drivers/net/mlx4/port.c                      |  282 +++++++
 drivers/net/mlx4/qp.c                        |   81 ++-
 drivers/net/mlx4/srq.c                       |    2 +-
 include/linux/mlx4/cmd.h                     |    9 +
 include/linux/mlx4/device.h                  |   54 ++-
 44 files changed, 6394 insertions(+), 125 deletions(-)
 create mode 100644 drivers/net/mlx4/en_cq.c
 create mode 100644 drivers/net/mlx4/en_main.c
 create mode 100644 drivers/net/mlx4/en_netdev.c
 create mode 100644 drivers/net/mlx4/en_params.c
 create mode 100644 drivers/net/mlx4/en_port.c
 create mode 100644 drivers/net/mlx4/en_port.h
 create mode 100644 drivers/net/mlx4/en_resources.c
 create mode 100644 drivers/net/mlx4/en_rx.c
 create mode 100644 drivers/net/mlx4/en_tx.c
 create mode 100644 drivers/net/mlx4/mlx4_en.h
 create mode 100644 drivers/net/mlx4/port.c
