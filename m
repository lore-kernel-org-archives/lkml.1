Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbZKHMYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbZKHMYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZKHMYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:24:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49558 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbZKHMWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:39 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 18/23] sysctl ia64: Remove dead binary sysctl support
Date: Sun,  8 Nov 2009 04:22:05 -0800
Message-Id: <1257682930-31401-18-git-send-email-ebiederm@xmission.com>
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

Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/ia64/kernel/crash.c       |    7 ++-----
 arch/ia64/kernel/perfmon.c     |    6 ------
 drivers/misc/sgi-xp/xpc_main.c |    8 --------
 3 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
index 6631a9d..7c7d6a6 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -239,7 +239,6 @@ kdump_init_notifier(struct notifier_block *self, unsigned long val, void *data)
 #ifdef CONFIG_SYSCTL
 static ctl_table kdump_ctl_table[] = {
 	{
-		.ctl_name = CTL_UNNUMBERED,
 		.procname = "kdump_on_init",
 		.data = &kdump_on_init,
 		.maxlen = sizeof(int),
@@ -247,24 +246,22 @@ static ctl_table kdump_ctl_table[] = {
 		.proc_handler = &proc_dointvec,
 	},
 	{
-		.ctl_name = CTL_UNNUMBERED,
 		.procname = "kdump_on_fatal_mca",
 		.data = &kdump_on_fatal_mca,
 		.maxlen = sizeof(int),
 		.mode = 0644,
 		.proc_handler = &proc_dointvec,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static ctl_table sys_table[] = {
 	{
-	  .ctl_name = CTL_KERN,
 	  .procname = "kernel",
 	  .mode = 0555,
 	  .child = kdump_ctl_table,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 #endif
 
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index f178270..ca30b36 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -522,7 +522,6 @@ EXPORT_SYMBOL(pfm_sysctl);
 
 static ctl_table pfm_ctl_table[]={
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "debug",
 		.data		= &pfm_sysctl.debug,
 		.maxlen		= sizeof(int),
@@ -530,7 +529,6 @@ static ctl_table pfm_ctl_table[]={
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "debug_ovfl",
 		.data		= &pfm_sysctl.debug_ovfl,
 		.maxlen		= sizeof(int),
@@ -538,7 +536,6 @@ static ctl_table pfm_ctl_table[]={
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "fastctxsw",
 		.data		= &pfm_sysctl.fastctxsw,
 		.maxlen		= sizeof(int),
@@ -546,7 +543,6 @@ static ctl_table pfm_ctl_table[]={
 		.proc_handler	=  &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "expert_mode",
 		.data		= &pfm_sysctl.expert_mode,
 		.maxlen		= sizeof(int),
@@ -557,7 +553,6 @@ static ctl_table pfm_ctl_table[]={
 };
 static ctl_table pfm_sysctl_dir[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "perfmon",
 		.mode		= 0555,
 		.child		= pfm_ctl_table,
@@ -566,7 +561,6 @@ static ctl_table pfm_sysctl_dir[] = {
 };
 static ctl_table pfm_sysctl_root[] = {
 	{
-		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
 		.mode		= 0555,
 		.child		= pfm_sysctl_dir,
diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
index fd3688a..ce98b93 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -89,48 +89,40 @@ static int xpc_disengage_max_timelimit = 120;
 
 static ctl_table xpc_sys_xpc_hb_dir[] = {
 	{
-	 .ctl_name = CTL_UNNUMBERED,
 	 .procname = "hb_interval",
 	 .data = &xpc_hb_interval,
 	 .maxlen = sizeof(int),
 	 .mode = 0644,
 	 .proc_handler = &proc_dointvec_minmax,
-	 .strategy = &sysctl_intvec,
 	 .extra1 = &xpc_hb_min_interval,
 	 .extra2 = &xpc_hb_max_interval},
 	{
-	 .ctl_name = CTL_UNNUMBERED,
 	 .procname = "hb_check_interval",
 	 .data = &xpc_hb_check_interval,
 	 .maxlen = sizeof(int),
 	 .mode = 0644,
 	 .proc_handler = &proc_dointvec_minmax,
-	 .strategy = &sysctl_intvec,
 	 .extra1 = &xpc_hb_check_min_interval,
 	 .extra2 = &xpc_hb_check_max_interval},
 	{}
 };
 static ctl_table xpc_sys_xpc_dir[] = {
 	{
-	 .ctl_name = CTL_UNNUMBERED,
 	 .procname = "hb",
 	 .mode = 0555,
 	 .child = xpc_sys_xpc_hb_dir},
 	{
-	 .ctl_name = CTL_UNNUMBERED,
 	 .procname = "disengage_timelimit",
 	 .data = &xpc_disengage_timelimit,
 	 .maxlen = sizeof(int),
 	 .mode = 0644,
 	 .proc_handler = &proc_dointvec_minmax,
-	 .strategy = &sysctl_intvec,
 	 .extra1 = &xpc_disengage_min_timelimit,
 	 .extra2 = &xpc_disengage_max_timelimit},
 	{}
 };
 static ctl_table xpc_sys_dir[] = {
 	{
-	 .ctl_name = CTL_UNNUMBERED,
 	 .procname = "xpc",
 	 .mode = 0555,
 	 .child = xpc_sys_xpc_dir},
-- 
1.6.5.2.143.g8cc62

