Return-Path: <linux-kernel-owner+w=401wt.eu-S1764762AbYFFGSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764762AbYFFGSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764503AbYFFGRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:17:44 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59287 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764491AbYFFGRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:17:42 -0400
Message-Id: <20080606060958.547519391@bull.net>
References: <20080606060955.317871352@bull.net>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 08:09:59 +0200
From: <Solofo.Ramangalahy@bull.net>
To: <linux-kernel@vger.kernel.org>
Cc: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
Subject: [RFC -mm 4/6] sysv ipc: re-enable msgmnb automatic recomputing if
 set to negative
Content-Disposition: inline;
 filename=ipc-re-enable-msgmnb-automatic-recomputing-msgmnb-if-set-to-negative.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

When a negative value is put in /proc/sys/kernel/msgmnb 
automatic recomputing is re-enabled.

Signed-off-by: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

---
 ipc/ipc_sysctl.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/ipc/ipc_sysctl.c
===================================================================
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -42,6 +42,7 @@ static void tunable_set_callback(int val
 		 * Re-enable automatic recomputing only if not already
 		 * enabled.
 		 */
+		recompute_msgmnb(current->nsproxy->ipc_ns);
 		recompute_msgmni(current->nsproxy->ipc_ns);
 		cond_register_ipcns_notifier(current->nsproxy->ipc_ns);
 	}

-- 
Solofo Ramangalahy
Bull SA.
