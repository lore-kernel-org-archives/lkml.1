Return-Path: <linux-kernel-owner+w=401wt.eu-S942084AbXHJVJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942084AbXHJVJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965190AbXHJVJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:09:19 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45161 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965059AbXHJVJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:09:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/7] sysctl: Cleanup the sched debug sysctl usage.
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC8F71.3070006@googlemail.com> <46BC944F.9020801@googlemail.com>
	<m1fy2rxpje.fsf@ebiederm.dsl.xmission.com>
	<20070810124156.2de9710e.akpm@linux-foundation.org>
	<m1ps1vw1ey.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkcjw1cc.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn7w18w.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xvw14e.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 10 Aug 2007 15:08:52 -0600
In-Reply-To: <m1d4xvw14e.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 10 Aug 2007 15:06:25 -0600")
Message-ID: <m18x8jw10b.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- The ctl_name for the kernel directory is CTL_KERN
- It is impoosible to write to sysctl directories so do not
  give users write permissions.

This is enough to stop sysctl_check_table from complaining about
the sched debug sysctls. 

My apologies for not sending this earlier I had the impression
Ingo's tree had diverged significantly from what was in the
stable tree.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/sched.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b0afd8d..47afd80 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5223,15 +5223,16 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
 static struct ctl_table sd_ctl_dir[] = {
 	{
 		.procname	= "sched_domain",
-		.mode		= 0755,
+		.mode		= 0555,
 	},
 	{0,},
 };
 
 static struct ctl_table sd_ctl_root[] = {
 	{
+		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
-		.mode		= 0755,
+		.mode		= 0555,
 		.child		= sd_ctl_dir,
 	},
 	{0,},
@@ -5307,7 +5308,7 @@ static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
 	for_each_domain(cpu, sd) {
 		snprintf(buf, 32, "domain%d", i);
 		entry->procname = kstrdup(buf, GFP_KERNEL);
-		entry->mode = 0755;
+		entry->mode = 0555;
 		entry->child = sd_alloc_ctl_domain_table(sd);
 		entry++;
 		i++;
@@ -5327,7 +5328,7 @@ static void init_sched_domain_sysctl(void)
 	for (i = 0; i < cpu_num; i++, entry++) {
 		snprintf(buf, 32, "cpu%d", i);
 		entry->procname = kstrdup(buf, GFP_KERNEL);
-		entry->mode = 0755;
+		entry->mode = 0555;
 		entry->child = sd_alloc_ctl_cpu_table(i);
 	}
 	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
-- 
1.5.1.1.181.g2de0

