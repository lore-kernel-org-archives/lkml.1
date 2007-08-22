Return-Path: <linux-kernel-owner+w=401wt.eu-S933309AbXHVX0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbXHVX0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763362AbXHVXZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:25:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34977 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762498AbXHVXZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:25:41 -0400
Date: Thu, 23 Aug 2007 05:08:31 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: H Peter Anvin <hpa@zytor.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386 cpuid: Misc cpuinit annotations
Message-ID: <alpine.LFD.0.999.0708230507160.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


cpuid_class_cpu_callback() is callback function of a CPU hotplug
notifier_block (that is already marked as __cpuinitdata). Therefore
it can safely be marked as __cpuinit.

cpuid_device_create() is only referenced from other functions that
are __cpuinit or __init. So it can also be safely marked __cpuinit.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 arch/i386/kernel/cpuid.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/cpuid.c b/arch/i386/kernel/cpuid.c
index 5c2faa1..a6761fd 100644
--- a/arch/i386/kernel/cpuid.c
+++ b/arch/i386/kernel/cpuid.c
@@ -152,7 +152,7 @@ static const struct file_operations cpuid_fops = {
 	.open = cpuid_open,
 };
 
-static int cpuid_device_create(int i)
+static int __cpuinit cpuid_device_create(int i)
 {
 	int err = 0;
 	struct device *dev;
@@ -163,7 +163,9 @@ static int cpuid_device_create(int i)
 	return err;
 }
 
-static int cpuid_class_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
+static int __cpuinit cpuid_class_cpu_callback(struct notifier_block *nfb,
+					      unsigned long action,
+					      void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 
