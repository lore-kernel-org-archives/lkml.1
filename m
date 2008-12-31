Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbYLaLB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbYLaLB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 06:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbYLaLBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 06:01:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45080 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYLaLBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 06:01:47 -0500
Subject: [PATCH] x86: cpuid.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, hpa@kernel.org,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 16:29:48 +0530
Message-Id: <1230721188.3738.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems

Fixes style problems:
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
ERROR: "foo * bar" should be "foo *bar"
ERROR: trailing whitespace
WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc

total: 2 errors, 2 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpuid.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 72cefd1..2b2dddb 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -39,10 +39,10 @@
 #include <linux/device.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
+#include <linux/uaccess.h>
 
 #include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static struct class *cpuid_class;
@@ -82,7 +82,7 @@ static loff_t cpuid_seek(struct file *file, loff_t offset, int orig)
 }
 
 static ssize_t cpuid_read(struct file *file, char __user *buf,
-			  size_t count, loff_t * ppos)
+			  size_t count, loff_t *ppos)
 {
 	char __user *tmp = buf;
 	struct cpuid_regs cmd;
@@ -117,11 +117,11 @@ static int cpuid_open(struct inode *inode, struct file *file)
 	unsigned int cpu;
 	struct cpuinfo_x86 *c;
 	int ret = 0;
-	
+
 	lock_kernel();
 
 	cpu = iminor(file->f_path.dentry->d_inode);
-	if (cpu >= NR_CPUS || !cpu_online(cpu)) {
+	if (cpu >= num_possible_cpus() || !cpu_online(cpu)) {
 		ret = -ENXIO;	/* No such CPU */
 		goto out;
 	}
-- 
1.5.5.1



