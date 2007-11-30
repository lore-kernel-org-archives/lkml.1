Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbXK3NNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbXK3NNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbXK3NNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:13:34 -0500
Received: from sacred.ru ([62.205.161.221]:49722 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbXK3NNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:13:33 -0500
Message-ID: <47500C74.10605@openvz.org>
Date: Fri, 30 Nov 2007 16:13:24 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 5/7][UTS] Use the ctl paths to register tables
References: <475008F5.3000506@openvz.org>
In-Reply-To: <475008F5.3000506@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 30 Nov 2007 16:13:21 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Same as with the IPC sysctls - I do not add any ctl roots
to handle multiple UTS namespaces, since we already track
this case in ctl handlers.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index fe3a56c..568ff0b 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -128,19 +128,17 @@ static struct ctl_table uts_kern_table[] = {
 	{}
 };
 
-static struct ctl_table uts_root_table[] = {
+static struct ctl_path uts_root_path[] = {
 	{
-		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= uts_kern_table,
+		.ctl_name	= CTL_KERN,
 	},
 	{}
 };
 
 static int __init utsname_sysctl_init(void)
 {
-	register_sysctl_table(uts_root_table);
+	register_sysctl_paths(uts_root_path, uts_kern_table);
 	return 0;
 }
 
-- 
1.5.3.4

