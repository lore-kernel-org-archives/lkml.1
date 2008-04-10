Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbYDJI4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbYDJI4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbYDJIz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:55:57 -0400
Received: from sacred.ru ([62.205.161.221]:38202 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbYDJIz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:55:56 -0400
Message-ID: <47FDD36D.4070204@openvz.org>
Date: Thu, 10 Apr 2008 12:44:29 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Alexey Dobriyan <adobriyan@openvz.org>
CC: Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/10] Pidns: add struct bsd_acct_struct *bacct field on pid_namespace
References: <47FDD267.80700@openvz.org>
In-Reply-To: <47FDD267.80700@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 10 Apr 2008 12:19:37 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be NULL automatically for all new namespaces.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 include/linux/pid_namespace.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index caff528..26e07d1 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -14,6 +14,8 @@ struct pidmap {
 
 #define PIDMAP_ENTRIES         ((PID_MAX_LIMIT + 8*PAGE_SIZE - 1)/PAGE_SIZE/8)
 
+struct bsd_acct_struct;
+
 struct pid_namespace {
 	struct kref kref;
 	struct pidmap pidmap[PIDMAP_ENTRIES];
@@ -25,6 +27,9 @@ struct pid_namespace {
 #ifdef CONFIG_PROC_FS
 	struct vfsmount *proc_mnt;
 #endif
+#ifdef CONFIG_BSD_PROCESS_ACCT
+	struct bsd_acct_struct *bacct;
+#endif
 };
 
 extern struct pid_namespace init_pid_ns;
-- 
1.5.3.4

