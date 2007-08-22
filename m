Return-Path: <linux-kernel-owner+w=401wt.eu-S933471AbXHVXiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471AbXHVXiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763575AbXHVXiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:38:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44274 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763171AbXHVXiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:38:06 -0400
Date: Thu, 23 Aug 2007 05:20:58 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: H Peter Anvin <hpa@zytor.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86 msr driver: Misc cpuinit annotations
Message-ID: <alpine.LFD.0.999.0708230520070.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


msr_class_cpu_callback() can be marked __cpuinit, being the notifier
callback for a __cpuinitdata notifier_block. So can be marked
msr_device_create() too, called only from the newly-__cpuinit
msr_class_cpu_callback() or from __init-marked msr_init().

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 arch/i386/kernel/msr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/msr.c b/arch/i386/kernel/msr.c
index 0c1069b..ac55d85 100644
--- a/arch/i386/kernel/msr.c
+++ b/arch/i386/kernel/msr.c
@@ -135,7 +135,7 @@ static const struct file_operations msr_fops = {
 	.open = msr_open,
 };
 
-static int msr_device_create(int i)
+static int __cpuinit msr_device_create(int i)
 {
 	int err = 0;
 	struct device *dev;
@@ -146,7 +146,7 @@ static int msr_device_create(int i)
 	return err;
 }
 
-static int msr_class_cpu_callback(struct notifier_block *nfb,
+static int __cpuinit msr_class_cpu_callback(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
