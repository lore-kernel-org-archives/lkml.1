Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZDNMn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZDNMn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZDNMns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:43:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:42350 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbZDNMnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:43:47 -0400
Subject: [PATCH -tip] x86: cpu/intel_cacheinfo.c fix compilation warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Apr 2009 18:13:10 +0530
Message-Id: <1239712990.3079.17.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:
  arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘show_cache_disable’:
  arch/x86/kernel/cpu/intel_cacheinfo.c:712: warning: unused variable ‘node’
  arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘store_cache_disable’:
  arch/x86/kernel/cpu/intel_cacheinfo.c:739: warning: unused variable ‘node’

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 789efe2..6794d3e 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -708,14 +708,15 @@ static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf)
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 				  unsigned int index)
 {
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = cpu_to_node(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	struct pci_dev *dev;
 	unsigned int reg = 0;
+	int cpu;
 
 	if (!this_leaf->can_disable)
 		return -EINVAL;
 
+	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+	dev = node_to_k8_nb_misc(cpu_to_node(cpu));
 	if (!dev)
 		return -EINVAL;
 
@@ -735,11 +736,10 @@ SHOW_CACHE_DISABLE(1)
 static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	const char *buf, size_t count, unsigned int index)
 {
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = cpu_to_node(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
-	unsigned long val = 0;
+	struct pci_dev *dev;
 	unsigned int scrubber = 0;
+	unsigned long val = 0;
+	int cpu;
 
 	if (!this_leaf->can_disable)
 		return -EINVAL;
@@ -747,6 +747,8 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+	dev = node_to_k8_nb_misc(cpu_to_node(cpu));
 	if (!dev)
 		return -EINVAL;
 
-- 
1.6.0.6



