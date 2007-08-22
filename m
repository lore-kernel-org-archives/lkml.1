Return-Path: <linux-kernel-owner+w=401wt.eu-S934406AbXHVWDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934406AbXHVWDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762528AbXHVWDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:03:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48991 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761713AbXHVWC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:02:58 -0400
Date: Thu, 23 Aug 2007 03:45:50 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] intel_cacheinfo: Call cache_add_dev from cache_sysfs_init
 explicitly
In-Reply-To: <alpine.LFD.0.999.0708230340480.2049@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0708230342590.2049@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0708230340480.2049@enigma.security.iitk.ac.in
 >
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Call cache_add_dev() from cache_sysfs_init() explicitly, instead of
referencing the CPU notifier callback directly from generic startup
code. Looks cleaner (to me at least) this way, and also makes it
possible to use other tricks to replace __cpuinit{data} annotations,
as recently discussed on this list.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 arch/i386/kernel/cpu/intel_cacheinfo.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/cpu/intel_cacheinfo.c b/arch/i386/kernel/cpu/intel_cacheinfo.c
index 16499fe..79e9c4f 100644
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c
+++ b/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -792,8 +792,8 @@ static int __init cache_sysfs_init(void)
 	register_hotcpu_notifier(&cacheinfo_cpu_notifier);
 
 	for_each_online_cpu(i) {
-		cacheinfo_cpu_callback(&cacheinfo_cpu_notifier, CPU_ONLINE,
-			(void *)(long)i);
+		struct sys_device *sys_dev = get_cpu_sysdev((unsigned int)i);
+		cache_add_dev(sys_dev);
 	}
 
 	return 0;
