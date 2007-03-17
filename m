Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbXCQUSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbXCQUSm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 16:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXCQUSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 16:18:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:6170 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbXCQUSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 16:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=FeFhcKojND3JQPcZKTDy0yRG/BOx/uCI1pOBNEreTi8Yz8l3TEckNUTRDOiZZgnuwFf23u1hbbuqcphDBMa7SXCpNepLB7lPyx8AsHYEHVOxz0CKpu44N4o5Y6wtl6Y2JWcNvVLxXd8CBGocsX8SM6zTzthllqvCwCYqhAF3+ys=
Date: Sat, 17 Mar 2007 23:14:56 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel-list <linux-kernel@vger.kernel.org>
Cc: starvik@axis.com, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] CRIS: check for memory allocation
Message-ID: <20070317201456.GB10920@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking for allocated memory. Indents
and spaces are added to be familiar with the kernel
coding style.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

 arch/cris/kernel/profile.c |   81 ++++++++++++++++++++++++++------------------
 1 files changed, 48 insertions(+), 33 deletions(-)

diff --git a/arch/cris/kernel/profile.c b/arch/cris/kernel/profile.c
index 4cfcae6..aad0a9e 100644
--- a/arch/cris/kernel/profile.c
+++ b/arch/cris/kernel/profile.c
@@ -15,39 +15,47 @@ static int prof_running = 0;
 void
 cris_profile_sample(struct pt_regs* regs)
 {
-  if (!prof_running)
-    return;
-  if (user_mode(regs))
-    *(unsigned int*)sample_buffer_pos = current->pid;
-  else
-    *(unsigned int*)sample_buffer_pos = 0;
-  *(unsigned int*)(sample_buffer_pos + 4) = instruction_pointer(regs);
-  sample_buffer_pos += 8;
-  if (sample_buffer_pos == sample_buffer + SAMPLE_BUFFER_SIZE)
-    sample_buffer_pos = sample_buffer;
+	if (!prof_running)
+		return;
+
+	if (user_mode(regs))
+		*(unsigned int*)sample_buffer_pos = current->pid;
+	else
+		*(unsigned int*)sample_buffer_pos = 0;
+
+	*(unsigned int*)(sample_buffer_pos + 4) = instruction_pointer(regs);
+	sample_buffer_pos += 8;
+
+	if (sample_buffer_pos == sample_buffer + SAMPLE_BUFFER_SIZE)
+		sample_buffer_pos = sample_buffer;
 }
 
 static ssize_t
-read_cris_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+read_cris_profile(struct file *file, char __user *buf,
+		  size_t count, loff_t *ppos)
 {
-  unsigned long p = *ppos;
-  if (p > SAMPLE_BUFFER_SIZE)
-    return 0;
-  if (p + count > SAMPLE_BUFFER_SIZE)
-    count = SAMPLE_BUFFER_SIZE - p;
-  if (copy_to_user(buf, sample_buffer + p,count))
+	unsigned long p = *ppos;
+
+	if (p > SAMPLE_BUFFER_SIZE)
+		return 0;
+
+	if (p + count > SAMPLE_BUFFER_SIZE)
+		count = SAMPLE_BUFFER_SIZE - p;
+	if (copy_to_user(buf, sample_buffer + p,count))
 		return -EFAULT;
-  memset(sample_buffer + p, 0, count);
-  *ppos += count;
-  return count;
+
+	memset(sample_buffer + p, 0, count);
+	*ppos += count;
+
+	return count;
 }
 
 static ssize_t
 write_cris_profile(struct file *file, const char __user *buf,
-              size_t count, loff_t *ppos)
+		   size_t count, loff_t *ppos)
 {
-  sample_buffer_pos = sample_buffer;
-  memset(sample_buffer, 0, SAMPLE_BUFFER_SIZE);
+	sample_buffer_pos = sample_buffer;
+	memset(sample_buffer, 0, SAMPLE_BUFFER_SIZE);
 }
 
 static const struct file_operations cris_proc_profile_operations = {
@@ -58,16 +66,23 @@ static const struct file_operations cris_proc_profile_operations = {
 static int
 __init init_cris_profile(void)
 {
-  struct proc_dir_entry *entry;
-  sample_buffer = kmalloc(SAMPLE_BUFFER_SIZE, GFP_KERNEL);
-  sample_buffer_pos = sample_buffer;
-  entry = create_proc_entry("system_profile", S_IWUSR | S_IRUGO, NULL);
-  if (entry) {
-    entry->proc_fops = &cris_proc_profile_operations;
-    entry->size = SAMPLE_BUFFER_SIZE;
-  }
-  prof_running = 1;
-  return 0;
+	struct proc_dir_entry *entry;
+
+	sample_buffer = kmalloc(SAMPLE_BUFFER_SIZE, GFP_KERNEL);
+	if (!sample_buffer) {
+		return -ENOMEM;
+	}
+
+	sample_buffer_pos = sample_buffer;
+
+	entry = create_proc_entry("system_profile", S_IWUSR | S_IRUGO, NULL);
+	if (entry) {
+		entry->proc_fops = &cris_proc_profile_operations;
+		entry->size = SAMPLE_BUFFER_SIZE;
+	}
+	prof_running = 1;
+
+	return 0;
 }
 
 __initcall(init_cris_profile);
