Return-Path: <linux-kernel-owner+w=401wt.eu-S1763685AbXK3NLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763685AbXK3NLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXK3NLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:11:37 -0500
Received: from sacred.ru ([62.205.161.221]:49501 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbXK3NLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:11:36 -0500
Message-ID: <47500BFF.1050504@openvz.org>
Date: Fri, 30 Nov 2007 16:11:27 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 4/7][SCHED] Use the ctl paths to register tables
References: <475008F5.3000506@openvz.org>
In-Reply-To: <475008F5.3000506@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 30 Nov 2007 16:11:25 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This includes the kernel/sched_domain entry only.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/kernel/sched.c b/kernel/sched.c
index 3ffec8c..a013dae 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5431,12 +5431,10 @@ static struct ctl_table sd_ctl_dir[] = {
 	{0, },
 };
 
-static struct ctl_table sd_ctl_root[] = {
+static struct ctl_path sd_ctl_path[] = {
 	{
-		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= sd_ctl_dir,
+		.ctl_name	= CTL_KERN,
 	},
 	{0, },
 };
@@ -5565,7 +5563,7 @@ static void register_sched_domain_sysctl(void)
 	}
 
 	WARN_ON(sd_sysctl_header);
-	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
+	sd_sysctl_header = register_sysctl_paths(sd_ctl_path, sd_ctl_dir);
 }
 
 /* may be called multiple times per register */
-- 
1.5.3.4

