Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbZKHMYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbZKHMYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbZKHMYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:24:47 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59096 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbZKHMWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:37 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 16/23] sysctl frv: Remove dead binary sysctl support
Date: Sun,  8 Nov 2009 04:22:03 -0800
Message-Id: <1257682930-31401-16-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sys_sysctl is a generic wrapper around /proc/sys  .ctl_name
and .strategy members of sysctl tables are dead code.  Remove them.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/frv/kernel/pm.c     |  106 +---------------------------------------------
 arch/frv/kernel/sysctl.c |    3 -
 2 files changed, 2 insertions(+), 107 deletions(-)

diff --git a/arch/frv/kernel/pm.c b/arch/frv/kernel/pm.c
index 17e2e3f..940d8bb 100644
--- a/arch/frv/kernel/pm.c
+++ b/arch/frv/kernel/pm.c
@@ -211,37 +211,6 @@ static int cmode_procctl(ctl_table *ctl, int write,
 	return try_set_cmode(new_cmode)?:*lenp;
 }
 
-static int cmode_sysctl(ctl_table *table,
-			void __user *oldval, size_t __user *oldlenp,
-			void __user *newval, size_t newlen)
-{
-	if (oldval && oldlenp) {
-		size_t oldlen;
-
-		if (get_user(oldlen, oldlenp))
-			return -EFAULT;
-
-		if (oldlen != sizeof(int))
-			return -EINVAL;
-
-		if (put_user(clock_cmode_current, (unsigned __user *)oldval) ||
-		    put_user(sizeof(int), oldlenp))
-			return -EFAULT;
-	}
-	if (newval && newlen) {
-		int new_cmode;
-
-		if (newlen != sizeof(int))
-			return -EINVAL;
-
-		if (get_user(new_cmode, (int __user *)newval))
-			return -EFAULT;
-
-		return try_set_cmode(new_cmode)?:1;
-	}
-	return 1;
-}
-
 static int try_set_p0(int new_p0)
 {
 	unsigned long flags, clkc;
@@ -314,37 +283,6 @@ static int p0_procctl(ctl_table *ctl, int write,
 	return try_set_p0(new_p0)?:*lenp;
 }
 
-static int p0_sysctl(ctl_table *table,
-		     void __user *oldval, size_t __user *oldlenp,
-		     void __user *newval, size_t newlen)
-{
-	if (oldval && oldlenp) {
-		size_t oldlen;
-
-		if (get_user(oldlen, oldlenp))
-			return -EFAULT;
-
-		if (oldlen != sizeof(int))
-			return -EINVAL;
-
-		if (put_user(clock_p0_current, (unsigned __user *)oldval) ||
-		    put_user(sizeof(int), oldlenp))
-			return -EFAULT;
-	}
-	if (newval && newlen) {
-		int new_p0;
-
-		if (newlen != sizeof(int))
-			return -EINVAL;
-
-		if (get_user(new_p0, (int __user *)newval))
-			return -EFAULT;
-
-		return try_set_p0(new_p0)?:1;
-	}
-	return 1;
-}
-
 static int cm_procctl(ctl_table *ctl, int write,
 		      void __user *buffer, size_t *lenp, loff_t *fpos)
 {
@@ -358,42 +296,9 @@ static int cm_procctl(ctl_table *ctl, int write,
 	return try_set_cm(new_cm)?:*lenp;
 }
 
-static int cm_sysctl(ctl_table *table,
-		     void __user *oldval, size_t __user *oldlenp,
-		     void __user *newval, size_t newlen)
-{
-	if (oldval && oldlenp) {
-		size_t oldlen;
-
-		if (get_user(oldlen, oldlenp))
-			return -EFAULT;
-
-		if (oldlen != sizeof(int))
-			return -EINVAL;
-
-		if (put_user(clock_cm_current, (unsigned __user *)oldval) ||
-		    put_user(sizeof(int), oldlenp))
-			return -EFAULT;
-	}
-	if (newval && newlen) {
-		int new_cm;
-
-		if (newlen != sizeof(int))
-			return -EINVAL;
-
-		if (get_user(new_cm, (int __user *)newval))
-			return -EFAULT;
-
-		return try_set_cm(new_cm)?:1;
-	}
-	return 1;
-}
-
-
 static struct ctl_table pm_table[] =
 {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "suspend",
 		.data		= NULL,
 		.maxlen		= 0,
@@ -401,44 +306,37 @@ static struct ctl_table pm_table[] =
 		.proc_handler	= &sysctl_pm_do_suspend,
 	},
 	{
-		.ctl_name	= CTL_PM_CMODE,
 		.procname	= "cmode",
 		.data		= &clock_cmode_current,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &cmode_procctl,
-		.strategy	= &cmode_sysctl,
 	},
 	{
-		.ctl_name	= CTL_PM_P0,
 		.procname	= "p0",
 		.data		= &clock_p0_current,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &p0_procctl,
-		.strategy	= &p0_sysctl,
 	},
 	{
-		.ctl_name	= CTL_PM_CM,
 		.procname	= "cm",
 		.data		= &clock_cm_current,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &cm_procctl,
-		.strategy	= &cm_sysctl,
 	},
-	{ .ctl_name = 0}
+	{ }
 };
 
 static struct ctl_table pm_dir_table[] =
 {
 	{
-		.ctl_name	= CTL_PM,
 		.procname	= "pm",
 		.mode		= 0555,
 		.child		= pm_table,
 	},
-	{ .ctl_name = 0}
+	{ }
 };
 
 /*
diff --git a/arch/frv/kernel/sysctl.c b/arch/frv/kernel/sysctl.c
index 139628a..b30a4f2 100644
--- a/arch/frv/kernel/sysctl.c
+++ b/arch/frv/kernel/sysctl.c
@@ -176,7 +176,6 @@ static int procctl_frv_pin_cxnr(ctl_table *table, int write, struct file *filp,
 static struct ctl_table frv_table[] =
 {
 	{
-		.ctl_name 	= CTL_UNNUMBERD,
 		.procname 	= "cache-mode",
 		.data		= NULL,
 		.maxlen		= 0,
@@ -185,7 +184,6 @@ static struct ctl_table frv_table[] =
 	},
 #ifdef CONFIG_MMU
 	{
-		.ctl_name	= CTL_UNNUMBERD,
 		.procname	= "pin-cxnr",
 		.data		= NULL,
 		.maxlen		= 0,
@@ -203,7 +201,6 @@ static struct ctl_table frv_table[] =
 static struct ctl_table frv_dir_table[] =
 {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "frv",
 		.mode 		= 0555,
 		.child		= frv_table
-- 
1.6.5.2.143.g8cc62

