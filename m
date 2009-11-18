Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbZKRD1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbZKRD1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 22:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZKRD1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 22:27:06 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:22336 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZKRD1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 22:27:05 -0500
Date: Tue, 17 Nov 2009 20:27:08 -0700
From: Alex Chiang <achiang@hp.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Subject: [PATCH v2] [CPUFREQ] make internal cpufreq_add_dev_* static
Message-ID: <20091118032708.GB6648@ldl.fc.hp.com>
References: <20091117220729.25933.57884.stgit@bob.kio> <20091117221130.25933.92163.stgit@bob.kio> <20091118002903.GA14477@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118002903.GA14477@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to export these symbols; make them static.

	cpufreq_add_dev_policy
	cpufreq_add_dev_symlink
	cpufreq_add_dev_interface

Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 0315069..8c465f1 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -783,8 +783,9 @@ static struct kobj_type ktype_cpufreq = {
  *   0:        Success
  *   Positive: When we have a managed CPU and the sysfs got symlinked
  */
-int cpufreq_add_dev_policy(unsigned int cpu, struct cpufreq_policy *policy,
-		struct sys_device *sys_dev)
+static int cpufreq_add_dev_policy(unsigned int cpu,
+				  struct cpufreq_policy *policy,
+				  struct sys_device *sys_dev)
 {
 	int ret = 0;
 #ifdef CONFIG_SMP
@@ -858,7 +859,8 @@ int cpufreq_add_dev_policy(unsigned int cpu, struct cpufreq_policy *policy,
 
 
 /* symlink affected CPUs */
-int cpufreq_add_dev_symlink(unsigned int cpu, struct cpufreq_policy *policy)
+static int cpufreq_add_dev_symlink(unsigned int cpu,
+				   struct cpufreq_policy *policy)
 {
 	unsigned int j;
 	int ret = 0;
@@ -885,8 +887,9 @@ int cpufreq_add_dev_symlink(unsigned int cpu, struct cpufreq_policy *policy)
 	return ret;
 }
 
-int cpufreq_add_dev_interface(unsigned int cpu, struct cpufreq_policy *policy,
-		struct sys_device *sys_dev)
+static int cpufreq_add_dev_interface(unsigned int cpu,
+				     struct cpufreq_policy *policy,
+				     struct sys_device *sys_dev)
 {
 	struct cpufreq_policy new_policy;
 	struct freq_attr **drv_attr;
