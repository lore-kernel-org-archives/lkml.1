Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbZBISRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbZBISRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbZBISQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:16:59 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:4459 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbZBISQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:16:58 -0500
Date: Mon, 9 Feb 2009 11:16:57 -0700
From: Alex Chiang <achiang@hp.com>
To: tony.luck@intel.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       stable@kernel.org, linux-ia64@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] ia64: Remove redundant cpu_clear() in __cpu_disable
	path
Message-ID: <20090209181657.GF19064@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, tony.luck@intel.com,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, stable@kernel.org,
	linux-ia64@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20090209181338.GD19064@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209181338.GD19064@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second call to cpu_clear() is redundant, as we've already removed
the CPU from cpu_online_map before calling migrate_platform_irqs().

Cc: stable@kernel.org
Signed-off-by: Alex Chiang <achiang@hp.com>
---
 arch/ia64/kernel/smpboot.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 2ec5bbf..5229054 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -740,11 +740,10 @@ int __cpu_disable(void)
 
 	if (migrate_platform_irqs(cpu)) {
 		cpu_set(cpu, cpu_online_map);
-		return (-EBUSY);
+		return -EBUSY;
 	}
 
 	remove_siblinginfo(cpu);
-	cpu_clear(cpu, cpu_online_map);
 	fixup_irqs();
 	local_flush_tlb_all();
 	cpu_clear(cpu, cpu_callin_map);
-- 
1.6.0.1.161.g7f314

