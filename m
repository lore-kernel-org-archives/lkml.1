Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbZKHMX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbZKHMX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZKHMXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:23:55 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59102 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbZKHMWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:43 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 23/23] sysctl: Remove the last of the generic binary sysctl support
Date: Sun,  8 Nov 2009 04:22:10 -0800
Message-Id: <1257682930-31401-23-git-send-email-ebiederm@xmission.com>
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

Now that all of the users stopped using ctl_name and strategy it
is safe to remove the fields from struct ctl_table, and it is safe
to remove the stub strategy routines as well.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/sysctl.h |    3 ---
 kernel/sysctl.c        |   44 --------------------------------------------
 2 files changed, 0 insertions(+), 47 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 7c4aabc..4e40442 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1033,7 +1033,6 @@ extern ctl_handler sysctl_ms_jiffies;
 /* A sysctl table is an array of struct ctl_table: */
 struct ctl_table 
 {
-	int ctl_name;			/* Binary ID */
 	const char *procname;		/* Text ID for /proc/sys, or zero */
 	void *data;
 	int maxlen;
@@ -1041,7 +1040,6 @@ struct ctl_table
 	struct ctl_table *child;
 	struct ctl_table *parent;	/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */
-	ctl_handler *strategy;		/* Callback function for all r/w */
 	void *extra1;
 	void *extra2;
 };
@@ -1075,7 +1073,6 @@ struct ctl_table_header
 /* struct ctl_path describes where in the hierarchy a table is added */
 struct ctl_path {
 	const char *procname;
-	int ctl_name;
 };
 
 void register_sysctl_root(struct ctl_table_root *root);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b6b6eb1..b4a5763 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1699,8 +1699,6 @@ static void try_attach(struct ctl_table_header *p, struct ctl_table_header *q)
  *
  * The members of the &struct ctl_table structure are used as follows:
  *
- * ctl_name - Dead
- *
  * procname - the name of the sysctl file under /proc/sys. Set to %NULL to not
  *            enter a sysctl file
  *
@@ -1715,8 +1713,6 @@ static void try_attach(struct ctl_table_header *p, struct ctl_table_header *q)
  *
  * proc_handler - the text handler routine (described below)
  *
- * strategy - Dead
- *
  * de - for internal use by the sysctl routines
  *
  * extra1, extra2 - extra pointers usable by the proc handler routines
@@ -2639,41 +2635,6 @@ int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
 
 #endif /* CONFIG_PROC_FS */
 
-int sysctl_data(struct ctl_table *table,
-		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-
-int sysctl_string(struct ctl_table *table,
-		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-
-int sysctl_intvec(struct ctl_table *table,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-
-int sysctl_jiffies(struct ctl_table *table,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-
-int sysctl_ms_jiffies(struct ctl_table *table,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-
 /*
  * No sense putting this after each symbol definition, twice,
  * exception granted :-)
@@ -2688,9 +2649,4 @@ EXPORT_SYMBOL(proc_doulongvec_minmax);
 EXPORT_SYMBOL(proc_doulongvec_ms_jiffies_minmax);
 EXPORT_SYMBOL(register_sysctl_table);
 EXPORT_SYMBOL(register_sysctl_paths);
-EXPORT_SYMBOL(sysctl_intvec);
-EXPORT_SYMBOL(sysctl_jiffies);
-EXPORT_SYMBOL(sysctl_ms_jiffies);
-EXPORT_SYMBOL(sysctl_string);
-EXPORT_SYMBOL(sysctl_data);
 EXPORT_SYMBOL(unregister_sysctl_table);
-- 
1.6.5.2.143.g8cc62

