Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbZKZLyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbZKZLyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 06:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758915AbZKZLyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 06:54:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036AbZKZLyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 06:54:39 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [PATCH -tip] x86/pat: trivial: don't create debugfs for memtype if pat is disabled
Date: Thu, 26 Nov 2009 19:53:48 +0800
Message-Id: <1259236428-16329-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pat is disabled (boot with nopat), there's no need to create
debugfs for it, it's empty all the time.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/mm/pat.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 01fc043..c37fd51 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -1014,8 +1014,9 @@ static const struct file_operations memtype_fops = {
 
 static int __init pat_memtype_list_init(void)
 {
-	debugfs_create_file("pat_memtype_list", S_IRUSR, arch_debugfs_dir,
-				NULL, &memtype_fops);
+	if (pat_enabled)
+		debugfs_create_file("pat_memtype_list", S_IRUSR,
+					arch_debugfs_dir, NULL, &memtype_fops);
 	return 0;
 }
 
-- 
1.6.5.2

