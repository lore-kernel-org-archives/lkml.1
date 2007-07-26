Return-Path: <linux-kernel-owner+w=401wt.eu-S936250AbXGZSiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936250AbXGZSiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764109AbXGZSiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:38:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:60407 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762412AbXGZSiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:38:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,584,1175497200"; 
   d="scan'208";a="110317497"
Date: Thu, 26 Jul 2007 11:32:25 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: mingo@elte.hu, npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch] sched: introduce SD_BALANCE_FORK for ht/mc/smp domains
Message-ID: <20070726183225.GJ3318@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce SD_BALANCE_FORK for HT/MC/SMP domains.

For HT/MC, as caches are shared, SD_BALANCE_FORK is the right thing to do.
Given that NUMA domain already has this flag and the
scheduler currently doesn't have the concept of running threads belonging
to a process as close as possible(i.e., forking may keep close, but periodic
balance later will likely take them far away), introduce SD_BALANCE_FORK
for SMP domain too.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/include/linux/topology.h b/include/linux/topology.h
index d0890a7..dc15a9f 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -104,6 +104,7 @@
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
+				| SD_BALANCE_FORK	\
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_IDLE		\
 				| SD_SHARE_CPUPOWER,	\
@@ -135,6 +136,7 @@
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
+				| SD_BALANCE_FORK	\
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_IDLE		\
 				| SD_SHARE_PKG_RESOURCES\
@@ -166,6 +168,7 @@
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
+				| SD_BALANCE_FORK	\
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_IDLE		\
 				| BALANCE_FOR_PKG_POWER,\
