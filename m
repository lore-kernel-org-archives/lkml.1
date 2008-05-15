Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbYEOLBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbYEOLBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 07:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbYEOLBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 07:01:04 -0400
Received: from sacred.ru ([62.205.161.221]:39046 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbYEOLBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 07:01:03 -0400
Message-ID: <482C174C.6000206@openvz.org>
Date: Thu, 15 May 2008 14:58:20 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/10] Pidns: add the struct bsd_acct_struct pointer on pid_namespace
 struct
References: <482C15FE.7070300@openvz.org>
In-Reply-To: <482C15FE.7070300@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 15 May 2008 15:00:41 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the bsdacct-related info will be stored in the area, 
pointer by this one.

It will be NULL automatically for all new namespaces.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 include/linux/pid_namespace.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 1a49ab5..1af82c4 100644
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
