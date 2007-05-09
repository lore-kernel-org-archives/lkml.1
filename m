Return-Path: <linux-kernel-owner+w=401wt.eu-S1033029AbXEIBHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033029AbXEIBHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966770AbXEIBHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:07:01 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:18150 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbXEIBHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:07:00 -0400
X-IronPort-AV: i="4.14,507,1170662400"; 
   d="scan'208"; a="419970085:sNHT2014182236"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 08 May 2007 18:06:56 -0700
Message-ID: <adasla64xfz.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 May 2007 01:06:57.0373 (UTC) FILETIME=[571A78D0:01C791D6]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will merge the mlx4 drivers for new Mellanox adapters:

Roland Dreier (3):
      IB/uverbs: Export ib_umem_get()/ib_umem_release() to modules
      IB: Put rlimit accounting struct in struct ib_umem
      IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters

 drivers/infiniband/Kconfig                       |    7 +
 drivers/infiniband/Makefile                      |    1 +
 drivers/infiniband/core/Makefile                 |    4 +-
 drivers/infiniband/core/device.c                 |    2 +
 drivers/infiniband/core/{uverbs_mem.c => umem.c} |  153 ++-
 drivers/infiniband/core/uverbs.h                 |    6 +-
 drivers/infiniband/core/uverbs_cmd.c             |   60 +-
 drivers/infiniband/core/uverbs_main.c            |   11 +-
 drivers/infiniband/hw/amso1100/c2_provider.c     |   42 +-
 drivers/infiniband/hw/amso1100/c2_provider.h     |    1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c      |   28 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.h      |    1 +
 drivers/infiniband/hw/ehca/ehca_classes.h        |    1 +
 drivers/infiniband/hw/ehca/ehca_iverbs.h         |    3 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c           |   69 +-
 drivers/infiniband/hw/ipath/ipath_mr.c           |   38 +-
 drivers/infiniband/hw/ipath/ipath_verbs.h        |    5 +-
 drivers/infiniband/hw/mlx4/Kconfig               |    9 +
 drivers/infiniband/hw/mlx4/Makefile              |    3 +
 drivers/infiniband/hw/mlx4/ah.c                  |  100 ++
 drivers/infiniband/hw/mlx4/cq.c                  |  525 +++++++++
 drivers/infiniband/hw/mlx4/doorbell.c            |  216 ++++
 drivers/infiniband/hw/mlx4/mad.c                 |  339 ++++++
 drivers/infiniband/hw/mlx4/main.c                |  651 +++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h             |  285 +++++
 drivers/infiniband/hw/mlx4/mr.c                  |  184 +++
 drivers/infiniband/hw/mlx4/qp.c                  | 1294 ++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/srq.c                 |  334 ++++++
 drivers/infiniband/hw/mlx4/user.h                |   92 ++
 drivers/infiniband/hw/mthca/mthca_provider.c     |   38 +-
 drivers/infiniband/hw/mthca/mthca_provider.h     |    1 +
 drivers/net/Kconfig                              |   14 +
 drivers/net/Makefile                             |    1 +
 drivers/net/mlx4/Makefile                        |    4 +
 drivers/net/mlx4/alloc.c                         |  179 +++
 drivers/net/mlx4/catas.c                         |   70 ++
 drivers/net/mlx4/cmd.c                           |  429 +++++++
 drivers/net/mlx4/cq.c                            |  254 +++++
 drivers/net/mlx4/eq.c                            |  696 ++++++++++++
 drivers/net/mlx4/fw.c                            |  775 +++++++++++++
 drivers/net/mlx4/fw.h                            |  167 +++
 drivers/net/mlx4/icm.c                           |  379 +++++++
 drivers/net/mlx4/icm.h                           |  135 +++
 drivers/net/mlx4/intf.c                          |  165 +++
 drivers/net/mlx4/main.c                          |  936 ++++++++++++++++
 drivers/net/mlx4/mcg.c                           |  380 +++++++
 drivers/net/mlx4/mlx4.h                          |  348 ++++++
 drivers/net/mlx4/mr.c                            |  479 ++++++++
 drivers/net/mlx4/pd.c                            |  102 ++
 drivers/net/mlx4/profile.c                       |  238 ++++
 drivers/net/mlx4/qp.c                            |  280 +++++
 drivers/net/mlx4/reset.c                         |  181 +++
 drivers/net/mlx4/srq.c                           |  227 ++++
 include/linux/mlx4/cmd.h                         |  178 +++
 include/linux/mlx4/cq.h                          |  123 ++
 include/linux/mlx4/device.h                      |  331 ++++++
 include/linux/mlx4/doorbell.h                    |   97 ++
 include/linux/mlx4/driver.h                      |   59 +
 include/linux/mlx4/qp.h                          |  288 +++++
 include/linux/mlx4/srq.h                         |   42 +
 include/rdma/ib_umem.h                           |   81 ++
 include/rdma/ib_verbs.h                          |   28 +-
 62 files changed, 11951 insertions(+), 218 deletions(-)
 rename drivers/infiniband/core/{uverbs_mem.c => umem.c} (59%)
 create mode 100644 drivers/infiniband/hw/mlx4/Kconfig
 create mode 100644 drivers/infiniband/hw/mlx4/Makefile
 create mode 100644 drivers/infiniband/hw/mlx4/ah.c
 create mode 100644 drivers/infiniband/hw/mlx4/cq.c
 create mode 100644 drivers/infiniband/hw/mlx4/doorbell.c
 create mode 100644 drivers/infiniband/hw/mlx4/mad.c
 create mode 100644 drivers/infiniband/hw/mlx4/main.c
 create mode 100644 drivers/infiniband/hw/mlx4/mlx4_ib.h
 create mode 100644 drivers/infiniband/hw/mlx4/mr.c
 create mode 100644 drivers/infiniband/hw/mlx4/qp.c
 create mode 100644 drivers/infiniband/hw/mlx4/srq.c
 create mode 100644 drivers/infiniband/hw/mlx4/user.h
 create mode 100644 drivers/net/mlx4/Makefile
 create mode 100644 drivers/net/mlx4/alloc.c
 create mode 100644 drivers/net/mlx4/catas.c
 create mode 100644 drivers/net/mlx4/cmd.c
 create mode 100644 drivers/net/mlx4/cq.c
 create mode 100644 drivers/net/mlx4/eq.c
 create mode 100644 drivers/net/mlx4/fw.c
 create mode 100644 drivers/net/mlx4/fw.h
 create mode 100644 drivers/net/mlx4/icm.c
 create mode 100644 drivers/net/mlx4/icm.h
 create mode 100644 drivers/net/mlx4/intf.c
 create mode 100644 drivers/net/mlx4/main.c
 create mode 100644 drivers/net/mlx4/mcg.c
 create mode 100644 drivers/net/mlx4/mlx4.h
 create mode 100644 drivers/net/mlx4/mr.c
 create mode 100644 drivers/net/mlx4/pd.c
 create mode 100644 drivers/net/mlx4/profile.c
 create mode 100644 drivers/net/mlx4/qp.c
 create mode 100644 drivers/net/mlx4/reset.c
 create mode 100644 drivers/net/mlx4/srq.c
 create mode 100644 include/linux/mlx4/cmd.h
 create mode 100644 include/linux/mlx4/cq.h
 create mode 100644 include/linux/mlx4/device.h
 create mode 100644 include/linux/mlx4/doorbell.h
 create mode 100644 include/linux/mlx4/driver.h
 create mode 100644 include/linux/mlx4/qp.h
 create mode 100644 include/linux/mlx4/srq.h
 create mode 100644 include/rdma/ib_umem.h
