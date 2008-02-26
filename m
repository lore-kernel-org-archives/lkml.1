Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbYBZKXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbYBZKXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbYBZKXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:23:43 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:41745 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbYBZKXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:23:42 -0500
Date: Tue, 26 Feb 2008 13:23:32 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] arch/x86/: switch to proc_create()
Message-ID: <20080226102332.GC7469@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 arch/x86/kernel/apm_32.c      |    5 +----
 arch/x86/kernel/cpu/mtrr/if.c |    6 ++----
 2 files changed, 3 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -2217,7 +2217,6 @@ static struct dmi_system_id __initdata apm_dmi_table[] = {
  */
 static int __init apm_init(void)
 {
-	struct proc_dir_entry *apm_proc;
 	struct desc_struct *gdt;
 	int err;
 
@@ -2322,9 +2321,7 @@ static int __init apm_init(void)
 	set_base(gdt[APM_DS >> 3],
 		 __va((unsigned long)apm_info.bios.dseg << 4));
 
-	apm_proc = create_proc_entry("apm", 0, NULL);
-	if (apm_proc)
-		apm_proc->proc_fops = &apm_file_ops;
+	proc_create("apm", 0, NULL, &apm_file_ops);
 
 	kapmd_task = kthread_create(apm, NULL, "kapmd");
 	if (IS_ERR(kapmd_task)) {
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -424,11 +424,9 @@ static int __init mtrr_if_init(void)
 		return -ENODEV;
 
 	proc_root_mtrr =
-	    create_proc_entry("mtrr", S_IWUSR | S_IRUGO, &proc_root);
-	if (proc_root_mtrr) {
+	    proc_create("mtrr", S_IWUSR | S_IRUGO, &proc_root, &mtrr_fops);
+	if (proc_root_mtrr)
 		proc_root_mtrr->owner = THIS_MODULE;
-		proc_root_mtrr->proc_fops = &mtrr_fops;
-	}
 	return 0;
 }
 

