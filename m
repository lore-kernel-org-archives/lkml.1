Return-Path: <linux-kernel-owner+w=401wt.eu-S1760826AbZKZR2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826AbZKZR2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760819AbZKZR2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:28:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:44993 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760417AbZKZR2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:28:04 -0500
Date: Thu, 26 Nov 2009 17:27:38 GMT
From: tip-bot for Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, dfeng@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, dfeng@redhat.com, mingo@elte.hu
In-Reply-To: <1259236428-16329-1-git-send-email-dfeng@redhat.com>
References: <1259236428-16329-1-git-send-email-dfeng@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/pat: Trivial: don't create debugfs for memtype if pat is disabled
Message-ID: <tip-dd4377b02d9f028006beed1b7b1695ee5d1498b6@git.kernel.org>
Git-Commit-ID: dd4377b02d9f028006beed1b7b1695ee5d1498b6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd4377b02d9f028006beed1b7b1695ee5d1498b6
Gitweb:     http://git.kernel.org/tip/dd4377b02d9f028006beed1b7b1695ee5d1498b6
Author:     Xiaotian Feng <dfeng@redhat.com>
AuthorDate: Thu, 26 Nov 2009 19:53:48 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 15:05:03 +0100

x86/pat: Trivial: don't create debugfs for memtype if pat is disabled

If pat is disabled (boot with nopat), there's no need to create
debugfs for it, it's empty all the time.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <1259236428-16329-1-git-send-email-dfeng@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pat.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index ef71251..a81b7e7 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -1019,8 +1019,10 @@ static const struct file_operations memtype_fops = {
 
 static int __init pat_memtype_list_init(void)
 {
-	debugfs_create_file("pat_memtype_list", S_IRUSR, arch_debugfs_dir,
-				NULL, &memtype_fops);
+	if (pat_enabled) {
+		debugfs_create_file("pat_memtype_list", S_IRUSR,
+				    arch_debugfs_dir, NULL, &memtype_fops);
+	}
 	return 0;
 }
 
