Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbZHRLA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbZHRLA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbZHRLA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:00:27 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:23791 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755638AbZHRLA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:00:27 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Aug 2009 07:00:26 EDT
X-SpamScore: 0
X-BigFish: VPS0(z34a4jz936eMzz1202hzzz32i203h6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KOKJWE-01-8YM-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 13:00:13 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] sched: Seperate out build of ALLNODES sched groups
	from __build_sched_domains
Message-ID: <20090818110013.GK29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090818104944.GA29515@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 11:00:13.0682 (UTC) FILETIME=[0FD82D20:01CA1FF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For the sake of completeness.
Now all calls to init_sched_build_groups() are contained in
build_sched_groups().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 666017b..8f53701 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8699,6 +8699,12 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 						&cpu_to_phys_group,
 						d->send_covered, d->tmpmask);
 		break;
+#ifdef CONFIG_NUMA
+	case SD_LV_ALLNODES:
+		init_sched_build_groups(cpu_map, cpu_map, &cpu_to_allnodes_group,
+					d->send_covered, d->tmpmask);
+		break;
+#endif
 	default:
 		break;
 	}
@@ -8749,11 +8755,8 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 #ifdef CONFIG_NUMA
 	/* Set up node groups */
-	if (d.sd_allnodes) {
-		init_sched_build_groups(cpu_map, cpu_map,
-					&cpu_to_allnodes_group,
-					d.send_covered, d.tmpmask);
-	}
+	if (d.sd_allnodes)
+		build_sched_groups(&d, SD_LV_ALLNODES, cpu_map, 0);
 
 	for (i = 0; i < nr_node_ids; i++) {
 		/* Set up node groups */
-- 
1.6.4



