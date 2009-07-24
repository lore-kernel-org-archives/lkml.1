Return-Path: <linux-kernel-owner+w=401wt.eu-S1752245AbZGXJUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbZGXJUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 05:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZGXJUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 05:20:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60997 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbZGXJUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:20:32 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: tony.luck@intel.com, fenghua.yu@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] ia64/topology.c: exit cache_add_dev when kobject_init_and_add fails
Date: Fri, 24 Jul 2009 17:20:28 +0800
Message-Id: <1248427228-30901-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make cache_add_dev exit sysfs when kobject_init_and_add returns an
error.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 arch/ia64/kernel/topology.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index bc80dff..82c5a8f 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -372,6 +372,10 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	retval = kobject_init_and_add(&all_cpu_cache_info[cpu].kobj,
 				      &cache_ktype_percpu_entry, &sys_dev->kobj,
 				      "%s", "cache");
+	if (retval < 0) {
+		cpu_cache_sysfs_exit(cpu);
+		return retval;
+	}
 
 	for (i = 0; i < all_cpu_cache_info[cpu].num_cache_leaves; i++) {
 		this_object = LEAF_KOBJECT_PTR(cpu,i);
-- 
1.6.2.5

