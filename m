Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbZKHMYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbZKHMYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZKHMYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:24:44 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49560 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbZKHMWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:40 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 20/23] sysctl sh: Remove dead binary sysctl support
Date: Sun,  8 Nov 2009 04:22:07 -0800
Message-Id: <1257682930-31401-20-git-send-email-ebiederm@xmission.com>
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

Also add an C99 named initializer to the child member of unaligned_root
to prevent chaos as the ctl_table definition changes over time.

Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/sh/kernel/traps_64.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/sh/kernel/traps_64.c b/arch/sh/kernel/traps_64.c
index 267e5eb..080c8ee 100644
--- a/arch/sh/kernel/traps_64.c
+++ b/arch/sh/kernel/traps_64.c
@@ -877,7 +877,6 @@ static int misaligned_fixup(struct pt_regs *regs)
 
 static ctl_table unaligned_table[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "kernel_reports",
 		.data		= &kernel_mode_unaligned_fixup_count,
 		.maxlen		= sizeof(int),
@@ -885,7 +884,6 @@ static ctl_table unaligned_table[] = {
 		.proc_handler	= &proc_dointvec
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "user_reports",
 		.data		= &user_mode_unaligned_fixup_count,
 		.maxlen		= sizeof(int),
@@ -893,7 +891,6 @@ static ctl_table unaligned_table[] = {
 		.proc_handler	= &proc_dointvec
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "user_enable",
 		.data		= &user_mode_unaligned_fixup_enable,
 		.maxlen		= sizeof(int),
@@ -904,17 +901,15 @@ static ctl_table unaligned_table[] = {
 
 static ctl_table unaligned_root[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "unaligned_fixup",
 		.mode		= 0555,
-		unaligned_table
+		.child		= unaligned_table
 	},
 	{}
 };
 
 static ctl_table sh64_root[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sh64",
 		.mode		= 0555,
 		.child		= unaligned_root
-- 
1.6.5.2.143.g8cc62

