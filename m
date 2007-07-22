Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbXGVPqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbXGVPqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbXGVPob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:44:31 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:8114 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962AbXGVPo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=sBHNv6rHctk1L2oDkIlrf241cvveA+Gqvm/1el432TZ1kI6v4TPJ6eOBUN2OUDI9N/ahiAROY0p1FJgWrbuKkWFbtIi1/CnYNU/QdsZNIFlqO3CEkEAyrfww+YaZy0PGD3stmFTRzdcp1dYajld+vxu2wCqyegl2P5mNtApf9LA=
Message-Id: <20070722153355.037575187@gmail.com>
References: <20070722153312.083951746@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 00:33:16 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Akinobu Mita <akinobu.mita@gmail.com>
Subject: [patch 4/9] topology: remove topology_dev_map
Content-Disposition: inline; filename=topology-cpuhotplug-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

By previous cpu hotplug notifier change, we don't need to track
topology_dev existence for each cpu by topology_dev_map.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/base/topology.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

Index: 2.6-git/drivers/base/topology.c
===================================================================
--- 2.6-git.orig/drivers/base/topology.c
+++ 2.6-git/drivers/base/topology.c
@@ -94,27 +94,18 @@ static struct attribute_group topology_a
 	.name = "topology"
 };
 
-static cpumask_t topology_dev_map = CPU_MASK_NONE;
-
 /* Add/Remove cpu_topology interface for CPU device */
 static int __cpuinit topology_add_dev(unsigned int cpu)
 {
-	int rc;
 	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
 
-	rc = sysfs_create_group(&sys_dev->kobj, &topology_attr_group);
-	if (!rc)
-		cpu_set(cpu, topology_dev_map);
-	return rc;
+	return sysfs_create_group(&sys_dev->kobj, &topology_attr_group);
 }
 
 static void __cpuinit topology_remove_dev(unsigned int cpu)
 {
 	struct sys_device *sys_dev = get_cpu_sysdev(cpu);
 
-	if (!cpu_isset(cpu, topology_dev_map))
-		return;
-	cpu_clear(cpu, topology_dev_map);
 	sysfs_remove_group(&sys_dev->kobj, &topology_attr_group);
 }
 

-- 
