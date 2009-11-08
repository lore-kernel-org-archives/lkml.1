Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZKHMYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZKHMYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZKHMYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:24:14 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49562 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZKHMWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:41 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 21/23] sysctl x86: Remove dead binary sysctl support
Date: Sun,  8 Nov 2009 04:22:08 -0800
Message-Id: <1257682930-31401-21-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sys_sysctl is a generic wrapper around /proc/sys  .ctl_name
and .strategy members of sysctl tables are dead code.  Remove them.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/vsyscall_64.c |    2 +-
 arch/x86/vdso/vdso32-setup.c  |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 8cb4974..e02d92d 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -237,7 +237,7 @@ static ctl_table kernel_table2[] = {
 };
 
 static ctl_table kernel_root_table2[] = {
-	{ .ctl_name = CTL_KERN, .procname = "kernel", .mode = 0555,
+	{ .procname = "kernel", .mode = 0555,
 	  .child = kernel_table2 },
 	{}
 };
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 58bc00f..02b442e 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -393,7 +393,6 @@ static ctl_table abi_table2[] = {
 
 static ctl_table abi_root_table2[] = {
 	{
-		.ctl_name = CTL_ABI,
 		.procname = "abi",
 		.mode = 0555,
 		.child = abi_table2
-- 
1.6.5.2.143.g8cc62

