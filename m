Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbZKFAmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbZKFAmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759262AbZKFAmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:42:36 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43436 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759258AbZKFAmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:42:13 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 11/11] sysctl: Make do_sysctl static
Date: Thu,  5 Nov 2009 16:41:54 -0800
Message-Id: <1257468114-6823-11-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1tyx8trik.fsf@fess.ebiederm.org>
References: <m1tyx8trik.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that all of the architectures use compat_sys_sysctl do_sysctl
can become static.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/sysctl.h |    4 ----
 kernel/sysctl_binary.c |    2 +-
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 1e4743e..82c32b8 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -996,10 +996,6 @@ extern int proc_doulongvec_minmax(struct ctl_table *, int,
 extern int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
 				      void __user *, size_t *, loff_t *);
 
-extern int do_sysctl (int __user *name, int nlen,
-		      void __user *oldval, size_t __user *oldlenp,
-		      void __user *newval, size_t newlen);
-
 extern ctl_handler sysctl_data;
 extern ctl_handler sysctl_string;
 extern ctl_handler sysctl_intvec;
diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index a2fed5b..b9b841e 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -134,7 +134,7 @@ static void deprecated_sysctl_warning(const int *name, int nlen)
 	return;
 }
 
-int do_sysctl(int __user *args_name, int nlen,
+static int do_sysctl(int __user *args_name, int nlen,
 	void __user *oldval, size_t __user *oldlenp,
 	void __user *newval, size_t newlen)
 {
-- 
1.6.5.2.143.g8cc62

