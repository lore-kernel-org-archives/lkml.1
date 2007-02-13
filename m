Return-Path: <linux-kernel-owner+w=401wt.eu-S1030583AbXBMASb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030583AbXBMASb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXBMASb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:18:31 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:10882 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030584AbXBMAS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:18:29 -0500
X-IronPort-AV: i="4.14,160,1170662400"; 
   d="scan'208"; a="111879583:sNHT86090886"
To: torvalds@linux-foundation.org
Cc: openib-general@openib.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 12 Feb 2007 16:18:23 -0800
Message-ID: <adazm7ioqpc.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Feb 2007 00:18:24.0144 (UTC) FILETIME=[79924100:01C74F04]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will add the new cxgb3 RDMA driver for Chelsio T3 NICs, as well
as IPoIB connected mode and various other smaller changes:

Ahmed S. Darwish (1):
      IB/core: Use ARRAY_SIZE macro for mandatory_table

Akinobu Mita (1):
      IB/ehca: Fix memleak on module unloading

David Howells (1):
      IB/mthca: Work around gcc bug on sparc64

Michael S. Tsirkin (6):
      IPoIB: Connected mode experimental support
      IB/mthca: Fix reserved MTTs calculation on mem-free HCAs
      IB/mthca: Give reserved MTTs a separate cache line
      IB/mthca: Fix access to MTT and MPT tables on non-cache-coherent CPUs
      IB/mthca: Merge MR and FMR space on 64-bit systems
      IB/mthca: Always fill MTTs from CPU

Roland Dreier (1):
      IB/mthca: Use correct structure size in call to memset()

Sean Hefty (2):
      RDMA/cma: Increment port number after close to avoid re-use
      IB: Remove redundant "_wq" from workqueue names

Steve Wise (1):
      RDMA/cxgb3: Add driver for Chelsio T3 RNIC

 drivers/infiniband/Kconfig                     |    1 +
 drivers/infiniband/Makefile                    |    1 +
 drivers/infiniband/core/addr.c                 |    2 +-
 drivers/infiniband/core/cma.c                  |   68 +-
 drivers/infiniband/core/device.c               |    3 +-
 drivers/infiniband/hw/cxgb3/Kconfig            |   27 +
 drivers/infiniband/hw/cxgb3/Makefile           |   12 +
 drivers/infiniband/hw/cxgb3/cxio_dbg.c         |  207 +++
 drivers/infiniband/hw/cxgb3/cxio_hal.c         | 1280 +++++++++++++++
 drivers/infiniband/hw/cxgb3/cxio_hal.h         |  201 +++
 drivers/infiniband/hw/cxgb3/cxio_resource.c    |  331 ++++
 drivers/infiniband/hw/cxgb3/cxio_resource.h    |   70 +
 drivers/infiniband/hw/cxgb3/cxio_wr.h          |  685 ++++++++
 drivers/infiniband/hw/cxgb3/iwch.c             |  189 +++
 drivers/infiniband/hw/cxgb3/iwch.h             |  177 ++
 drivers/infiniband/hw/cxgb3/iwch_cm.c          | 2081 ++++++++++++++++++++++++
 drivers/infiniband/hw/cxgb3/iwch_cm.h          |  223 +++
 drivers/infiniband/hw/cxgb3/iwch_cq.c          |  225 +++
 drivers/infiniband/hw/cxgb3/iwch_ev.c          |  231 +++
 drivers/infiniband/hw/cxgb3/iwch_mem.c         |  172 ++
 drivers/infiniband/hw/cxgb3/iwch_provider.c    | 1203 ++++++++++++++
 drivers/infiniband/hw/cxgb3/iwch_provider.h    |  367 +++++
 drivers/infiniband/hw/cxgb3/iwch_qp.c          | 1007 ++++++++++++
 drivers/infiniband/hw/cxgb3/iwch_user.h        |   67 +
 drivers/infiniband/hw/cxgb3/tcb.h              |  632 +++++++
 drivers/infiniband/hw/ehca/ehca_irq.c          |    2 +
 drivers/infiniband/hw/mthca/mthca_cmd.c        |    6 +-
 drivers/infiniband/hw/mthca/mthca_dev.h        |    2 +
 drivers/infiniband/hw/mthca/mthca_main.c       |   40 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c    |  127 ++-
 drivers/infiniband/hw/mthca/mthca_memfree.h    |    9 +-
 drivers/infiniband/hw/mthca/mthca_mr.c         |  110 ++-
 drivers/infiniband/hw/mthca/mthca_profile.c    |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c   |   14 +-
 drivers/infiniband/hw/mthca/mthca_provider.h   |    1 +
 drivers/infiniband/hw/mthca/mthca_qp.c         |    2 +-
 drivers/infiniband/hw/mthca/mthca_srq.c        |    9 +-
 drivers/infiniband/ulp/ipoib/Kconfig           |   16 +-
 drivers/infiniband/ulp/ipoib/Makefile          |    1 +
 drivers/infiniband/ulp/ipoib/ipoib.h           |  215 +++
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        | 1237 ++++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |   29 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   63 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |   40 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |    2 +
 46 files changed, 11279 insertions(+), 114 deletions(-)
 create mode 100644 drivers/infiniband/hw/cxgb3/Kconfig
 create mode 100644 drivers/infiniband/hw/cxgb3/Makefile
 create mode 100644 drivers/infiniband/hw/cxgb3/cxio_dbg.c
 create mode 100644 drivers/infiniband/hw/cxgb3/cxio_hal.c
 create mode 100644 drivers/infiniband/hw/cxgb3/cxio_hal.h
 create mode 100644 drivers/infiniband/hw/cxgb3/cxio_resource.c
 create mode 100644 drivers/infiniband/hw/cxgb3/cxio_resource.h
 create mode 100644 drivers/infiniband/hw/cxgb3/cxio_wr.h
 create mode 100644 drivers/infiniband/hw/cxgb3/iwch.c
 create mode 100644 drivers/infiniband/hw/cxgb3/iwch.h
 create mode 100644 drivers/infiniband/hw/cxgb3/iwch_cm.c
 create mode 100644 drivers/infiniband/hw/cxgb3/iwch_cm.h
 create mode 100644 drivers/infiniband/hw/cxgb3/iwch_cq.c
 create mode 100644 drivers/infiniband/hw/cxgb3/iwch_ev.c
 create mode 100644 drivers/infiniband/hw/cxgb3/iwch_mem.c
 create mode 100644 drivers/infiniband/hw/cxgb3/iwch_provider.c
 create mode 100644 drivers/infiniband/hw/cxgb3/iwch_provider.h
 create mode 100644 drivers/infiniband/hw/cxgb3/iwch_qp.c
 create mode 100644 drivers/infiniband/hw/cxgb3/iwch_user.h
 create mode 100644 drivers/infiniband/hw/cxgb3/tcb.h
 create mode 100644 drivers/infiniband/ulp/ipoib/ipoib_cm.c
