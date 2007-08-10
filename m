Return-Path: <linux-kernel-owner+w=401wt.eu-S932726AbXHJBBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbXHJBBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932549AbXHJBAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:00:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36220 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363AbXHJBAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:00:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@sw.ru>,
       Andi Kleen <ak@suse.de>
Subject: [PATCH 07/10] sysctl: x86_64 remove unnecessary binary paths.
References: <20070726164518.GB16937@localhost.sw.ru>
	<m13azbulhf.fsf@ebiederm.dsl.xmission.com>
	<20070727145235.GC6924@localhost.sw.ru>
	<20070806124530.GD6634@localhost.sw.ru>
	<m1tzr8a3ms.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1wa3kf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xw9psl.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8k9ppv.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pj89pmt.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vebo8avf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6mc8at5.fsf_-_@ebiederm.dsl.xmission.com>
Date: Thu, 09 Aug 2007 18:59:46 -0600
In-Reply-To: <m1r6mc8at5.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Thu, 09 Aug 2007 18:58:46 -0600")
Message-ID: <m1myx08arh.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/ia32/ia32_binfmt.c |    1 -
 arch/x86_64/kernel/vsyscall.c  |   10 +---------
 2 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/arch/x86_64/ia32/ia32_binfmt.c b/arch/x86_64/ia32/ia32_binfmt.c
index dffd2ac..c80c3f1 100644
--- a/arch/x86_64/ia32/ia32_binfmt.c
+++ b/arch/x86_64/ia32/ia32_binfmt.c
@@ -291,7 +291,6 @@ static void elf32_init(struct pt_regs *regs)
 
 static ctl_table abi_table2[] = {
 	{
-		.ctl_name	= 99,
 		.procname	= "vsyscall32",
 		.data		= &sysctl_vsyscall32,
 		.maxlen		= sizeof(int),
diff --git a/arch/x86_64/kernel/vsyscall.c b/arch/x86_64/kernel/vsyscall.c
index 06c3494..69918b5 100644
--- a/arch/x86_64/kernel/vsyscall.c
+++ b/arch/x86_64/kernel/vsyscall.c
@@ -260,18 +260,10 @@ out:
 	return ret;
 }
 
-static int vsyscall_sysctl_nostrat(ctl_table *t, int __user *name, int nlen,
-				void __user *oldval, size_t __user *oldlenp,
-				void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-
 static ctl_table kernel_table2[] = {
-	{ .ctl_name = 99, .procname = "vsyscall64",
+	{ .procname = "vsyscall64",
 	  .data = &vsyscall_gtod_data.sysctl_enabled, .maxlen = sizeof(int),
 	  .mode = 0644,
-	  .strategy = vsyscall_sysctl_nostrat,
 	  .proc_handler = vsyscall_sysctl_change },
 	{}
 };
-- 
1.5.1.1.181.g2de0

