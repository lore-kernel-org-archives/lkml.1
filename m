Return-Path: <linux-kernel-owner+w=401wt.eu-S936786AbZDIV7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936786AbZDIV7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758819AbZDIV7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:59:03 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:14723 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbZDIV7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:59:00 -0400
X-IronPort-AV: E=Sophos;i="4.40,163,1238976000"; 
   d="scan'208";a="152151291"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Thu, 09 Apr 2009 14:58:59 -0700
Message-ID: <adabpr54hgc.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Apr 2009 21:58:59.0448 (UTC) FILETIME=[62EC2F80:01C9B95E]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a batch of changes for -rc2, mostly low-level hardware
driver fixes with a few other miscellaneous fixes and an IPoIB
documentation update.

Chien Tung (3):
      RDMA/nes: Fix SFP+ PHY initialization
      RDMA/nes: Add wide_ppm_offset parm for switch compatibility
      RDMA/nes: Add support for new SFP+ PHY

Don Wood (1):
      RDMA/nes: Fix incorrect casts on 32-bit architectures

Faisal Latif (2):
      RDMA/nes: Fix error handling issues
      RDMA/nes: Fix nes_nic_cm_xmit() error handling

Or Gerlitz (1):
      IPoIB: Document newish features

Roland Dreier (4):
      IB/mlx4: Use pgprot_writecombine() for BlueFlame pages
      mlx4_core: Don't leak mailbox for SET_PORT on Ethernet ports
      IPoIB: Avoid free_netdev() BUG when destroying a child interface
      Merge branches 'cma', 'cxgb3', 'ipoib', 'mlx4' and 'nes' into for-next

Steve Wise (2):
      RDMA/cxgb3: Handle EEH events
      RDMA/cxgb3: Release dependent resources only when endpoint memory is freed.

Yossi Etigin (2):
      RDMA/cma: Use rate from IPoIB broadcast when joining IPoIB multicast groups
      RDMA/cma: Create cm id even when IB port is down

 Documentation/infiniband/ipoib.txt        |   45 ++++
 drivers/infiniband/core/cma.c             |   45 +++-
 drivers/infiniband/hw/cxgb3/cxio_hal.c    |   10 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.h    |    6 +
 drivers/infiniband/hw/cxgb3/iwch.c        |   11 +-
 drivers/infiniband/hw/cxgb3/iwch.h        |    5 +
 drivers/infiniband/hw/cxgb3/iwch_cm.c     |  116 ++++++---
 drivers/infiniband/hw/cxgb3/iwch_cm.h     |    3 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c     |    4 +-
 drivers/infiniband/hw/mlx4/main.c         |    3 +-
 drivers/infiniband/hw/nes/nes.h           |    4 +-
 drivers/infiniband/hw/nes/nes_cm.c        |   22 +-
 drivers/infiniband/hw/nes/nes_cm.h        |    1 -
 drivers/infiniband/hw/nes/nes_hw.c        |  389 ++++++++++++++---------------
 drivers/infiniband/hw/nes/nes_hw.h        |    2 +
 drivers/infiniband/hw/nes/nes_nic.c       |   52 +++--
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c |   25 ++-
 drivers/net/mlx4/port.c                   |    5 +-
 18 files changed, 442 insertions(+), 306 deletions(-)
