Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYCRBMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYCRBMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 21:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYCRBJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 21:09:52 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:40035 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbYCRBJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 21:09:43 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080318209.039112899@firstfloor.org>
In-Reply-To: <20080318209.039112899@firstfloor.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH prototype] [7/8] Add the sysctls to control pbitmaps
Message-Id: <20080318010941.602271B41E1@basil.firstfloor.org>
Date: Tue, 18 Mar 2008 02:09:41 +0100 (CET)
X-OriginalArrivalTime: 18 Mar 2008 01:03:06.0689 (UTC) FILETIME=[D3506310:01C88893]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- pbitmap_enabled: Master switch for pbitmap
- pbitmap_early_fault: Control whether pbitmap should do
early page faults or not. Default on.
- pbitmap_update_interval: How often the pbitmap should
be updated on disk.

Signed-off-by: Andi Kleen <andi@firstfloor.org>

---
 kernel/sysctl.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -1044,6 +1044,36 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &zero,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "pbitmap_enabled",
+		.data		= &pbitmap_enabled,
+		.maxlen 	= sizeof(pbitmap_enabled),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1 	= &zero,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "pbitmap_early_fault",
+		.data		= &pbitmap_early_fault,
+		.maxlen 	= sizeof(pbitmap_early_fault),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1 	= &zero,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "pbitmap_update_interval",
+		.data		= &pbitmap_update_interval,
+		.maxlen 	= sizeof(pbitmap_update_interval),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1 	= &zero,
+	},
+	{
 		.ctl_name	= VM_VFS_CACHE_PRESSURE,
 		.procname	= "vfs_cache_pressure",
 		.data		= &sysctl_vfs_cache_pressure,
