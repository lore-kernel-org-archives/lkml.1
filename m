Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZHTNi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZHTNi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZHTNi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:38:27 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:56382 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753345AbZHTNi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:38:26 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh203h43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KOOGIU-02-8BH-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:37:42 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 6/15] sched: Add support for MN domain in build_sched_groups
Message-ID: <20090820133742.GU29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:37:43.0340 (UTC) FILETIME=[651B0EC0:01CA219B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7b8b2ab..cc16629 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8805,6 +8805,16 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 						d->send_covered, d->tmpmask);
 		break;
 #endif
+#ifdef CONFIG_SCHED_MN
+	case SD_LV_MN: /* set up multi-node groups */
+		cpumask_and(d->this_cpu_node_map, cpu_map,
+			    topology_cpu_node_cpumask(cpu));
+		if (cpu == cpumask_first(d->this_cpu_node_map))
+			init_sched_build_groups(d->this_cpu_node_map, cpu_map,
+						&cpu_to_cpu_node_group,
+						d->send_covered, d->tmpmask);
+		break;
+#endif
 	case SD_LV_CPU: /* set up physical groups */
 		cpumask_and(d->nodemask, cpumask_of_node(cpu), cpu_map);
 		if (!cpumask_empty(d->nodemask))
-- 
1.6.0.4



