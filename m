Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbZBXWCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbZBXWCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbZBXWB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:01:56 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:44473 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477AbZBXWB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:01:56 -0500
Date: Tue, 24 Feb 2009 16:01:41 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Cedric Le Goater <clg@fr.ibm.com>, Alexey Dobriyan <adobriyan@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] proc_sysctl: use CONFIG_PROC_SYSCTL around ipc and
	utsname proc_handlers
Message-ID: <20090224220141.GA30951@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Cedric Le Goater (in response to Alexey's original
comment wrt mqns), ipc_sysctl.c and utsname_sysctl.c are using
CONFIG_PROC_FS, not CONFIG_PROC_SYSCTL, to determine whether to define
the proc_handlers.  Change that.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 ipc/ipc_sysctl.c        |    2 +-
 kernel/utsname_sysctl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 4a7a12c..40eab73 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -26,7 +26,7 @@ static void *get_ipc(ctl_table *table)
 	return which;
 }
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_PROC_SYSCTL
 static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index 3b34b35..92359cc 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -37,7 +37,7 @@ static void put_uts(ctl_table *table, int write, void *which)
 		up_write(&uts_sem);
 }
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_PROC_SYSCTL
 /*
  *	Special case of dostring for the UTS structure. This has locks
  *	to observe. Should this be in kernel/sys.c ????
-- 
1.5.4.3

