Return-Path: <linux-kernel-owner+w=401wt.eu-S1759528AbZHRQyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbZHRQyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759498AbZHRQyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:54:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:42346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759490AbZHRQyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:54:14 -0400
Date: Tue, 18 Aug 2009 16:53:41 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090818110013.GK29515@alberich.amd.com>
References: <20090818110013.GK29515@alberich.amd.com>
Subject: [tip:sched/domains] sched: Separate out build of ALLNODES sched groups from __build_sched_domains
Message-ID: <tip-de616e36c700dc312d9021dd75f769c463f85122@git.kernel.org>
Git-Commit-ID: de616e36c700dc312d9021dd75f769c463f85122
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 16:53:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de616e36c700dc312d9021dd75f769c463f85122
Gitweb:     http://git.kernel.org/tip/de616e36c700dc312d9021dd75f769c463f85122
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 18 Aug 2009 13:00:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 18:35:44 +0200

sched: Separate out build of ALLNODES sched groups from __build_sched_domains

For the sake of completeness.
Now all calls to init_sched_build_groups() are contained in
build_sched_groups().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090818110013.GK29515@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b09a41c..52c1953 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8593,6 +8593,12 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
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
@@ -8643,11 +8649,8 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
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
