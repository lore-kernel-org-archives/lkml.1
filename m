Return-Path: <linux-kernel-owner+w=401wt.eu-S934323AbZAPXH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323AbZAPXH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760371AbZAPXHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:07:47 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:27629 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761464AbZAPXHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:07:46 -0500
X-IronPort-AV: E=Sophos;i="4.37,278,1231113600"; 
   d="scan'208";a="130135458"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Fri, 16 Jan 2009 15:07:40 -0800
Message-ID: <adaiqoedf43.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Jan 2009 23:07:40.0867 (UTC) FILETIME=[3B319130:01C9782F]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

Some fixes to go into 2.6.29-rc3.  Nothing too urgent so if this takes
a long time due to LCA, it's not a big deal.  The bulk of things are
for the ehca driver, to fix warning spew caused by the powerpc u64
transition from long to long long.

Andrew Morton (1):
      mlx4_core: Fix min() warning

Roland Dreier (4):
      IPoIB: Fix hang in napi_disable() if P_Key is never found
      IPoIB: Fix deadlock between ipoib_open() and child interface create
      IB/mlx4: Fix memory ordering problem when posting LSO sends
      Merge branches 'ehca', 'ipoib' and 'mlx4' into for-linus

Stephen Rothwell (2):
      IB/ehca: Fix printk format warnings from u64 type change
      IB/ehca: Use consistent types for ehca_plpar_hcall9()

Yossi Etigin (1):
      IPoIB: Do not print error messages for multicast join retries

 drivers/infiniband/hw/ehca/ehca_cq.c           |   16 ++--
 drivers/infiniband/hw/ehca/ehca_hca.c          |    2 +-
 drivers/infiniband/hw/ehca/ehca_irq.c          |   18 ++--
 drivers/infiniband/hw/ehca/ehca_main.c         |    6 +-
 drivers/infiniband/hw/ehca/ehca_mcast.c        |    4 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c         |  144 ++++++++++++------------
 drivers/infiniband/hw/ehca/ehca_qp.c           |   32 +++---
 drivers/infiniband/hw/ehca/ehca_reqs.c         |    2 +-
 drivers/infiniband/hw/ehca/ehca_sqp.c          |    2 +-
 drivers/infiniband/hw/ehca/ehca_tools.h        |    2 +-
 drivers/infiniband/hw/ehca/ehca_uverbs.c       |    2 +-
 drivers/infiniband/hw/ehca/hcp_if.c            |   56 +++++-----
 drivers/infiniband/hw/mlx4/qp.c                |   28 +++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   27 +++--
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |   11 ++-
 drivers/net/mlx4/profile.c                     |    6 +-
 17 files changed, 189 insertions(+), 171 deletions(-)
