Return-Path: <linux-kernel-owner+w=401wt.eu-S1764536AbYFFGSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764536AbYFFGSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764490AbYFFGRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:17:43 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59274 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764473AbYFFGRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:17:41 -0400
Message-Id: <20080606060958.386058480@bull.net>
References: <20080606060955.317871352@bull.net>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 08:09:58 +0200
From: <Solofo.Ramangalahy@bull.net>
To: <linux-kernel@vger.kernel.org>
Cc: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
Subject: [RFC -mm 3/6] sysv ipc: do not recompute msgmni anymore if
 explicitely set by user
Content-Disposition: inline;
 filename=ipc-do-not-recompute-msgmnb-anymore-if-explicitely-set-by-user.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

To disable recomputation when user explicitely set a value,
reuse the callback defined for msgmni for msgmnb.

As msgmni and msgmnb are correlated, user settings of any of the two
disable recomputation of both, for now. This will be refined in a
later patch.

Signed-off-by: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

---
 ipc/ipc_sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/ipc/ipc_sysctl.c
===================================================================
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -210,8 +210,8 @@ static struct ctl_table ipc_kern_table[]
 		.data		= &init_ipc_ns.msg_ctlmnb,
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmnb),
 		.mode		= 0644,
-		.proc_handler	= proc_ipc_dointvec,
-		.strategy	= sysctl_ipc_data,
+		.proc_handler	= proc_ipc_callback_dointvec,
+		.strategy	= sysctl_ipc_registered_data,
 	},
 	{
 		.ctl_name	= KERN_SEM,

-- 
Solofo Ramangalahy
Bull SA.
