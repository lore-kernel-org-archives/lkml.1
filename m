Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZKHMXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZKHMXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZKHMW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:22:56 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49556 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbZKHMWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:38 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 17/23] sysctl s390: Remove dead sysctl binary support
Date: Sun,  8 Nov 2009 04:22:04 -0800
Message-Id: <1257682930-31401-17-git-send-email-ebiederm@xmission.com>
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

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/s390/kernel/debug.c       |    9 ++-------
 arch/s390/mm/cmm.c             |    5 ++---
 drivers/s390/char/sclp_async.c |    5 ++---
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 20f282c..adf1126 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -893,35 +893,30 @@ s390dbf_procactive(ctl_table *table, int write,
 
 static struct ctl_table s390dbf_table[] = {
 	{
-		.ctl_name       = CTL_S390DBF_STOPPABLE,
 		.procname       = "debug_stoppable",
 		.data		= &debug_stoppable,
 		.maxlen		= sizeof(int),
 		.mode           = S_IRUGO | S_IWUSR,
 		.proc_handler   = &proc_dointvec,
-		.strategy	= &sysctl_intvec,
 	},
 	 {
-		.ctl_name       = CTL_S390DBF_ACTIVE,
 		.procname       = "debug_active",
 		.data		= &debug_active,
 		.maxlen		= sizeof(int),
 		.mode           = S_IRUGO | S_IWUSR,
 		.proc_handler   = &s390dbf_procactive,
-		.strategy	= &sysctl_intvec,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static struct ctl_table s390dbf_dir_table[] = {
 	{
-		.ctl_name       = CTL_S390DBF,
 		.procname       = "s390dbf",
 		.maxlen         = 0,
 		.mode           = S_IRUGO | S_IXUGO,
 		.child          = s390dbf_table,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static struct ctl_table_header *s390dbf_sysctl_header;
diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index b201135..dab3e4a 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -355,18 +355,17 @@ static struct ctl_table cmm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &cmm_timeout_handler,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static struct ctl_table cmm_dir_table[] = {
 	{
-		.ctl_name	= CTL_VM,
 		.procname	= "vm",
 		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= cmm_table,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 #endif
 
diff --git a/drivers/s390/char/sclp_async.c b/drivers/s390/char/sclp_async.c
index b44462a..740fe40 100644
--- a/drivers/s390/char/sclp_async.c
+++ b/drivers/s390/char/sclp_async.c
@@ -101,18 +101,17 @@ static struct ctl_table callhome_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_handler_callhome,
 	},
-	{ .ctl_name = 0 }
+	{}
 };
 
 static struct ctl_table kern_dir_table[] = {
 	{
-		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
 		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= callhome_table,
 	},
-	{ .ctl_name = 0 }
+	{}
 };
 
 /*
-- 
1.6.5.2.143.g8cc62

