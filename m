Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbXGWIEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbXGWIEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760054AbXGWIC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:02:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41711 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763309AbXGWICz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:02:55 -0400
Date: Mon, 23 Jul 2007 10:02:20 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Amy Griffis <amy.griffis@hp.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/auditsc.c: fix an off-by-one
Message-ID: <20070723080220.GE26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an off-by-one in a BUG_ON() spotted by the Coverity 
checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/kernel/auditsc.c.old	2007-07-23 02:08:09.000000000 +0200
+++ linux-2.6.22-rc6-mm1/kernel/auditsc.c	2007-07-23 02:08:32.000000000 +0200
@@ -2069,7 +2069,7 @@ int __audit_signal_info(int sig, struct 
 		axp->d.next = ctx->aux_pids;
 		ctx->aux_pids = (void *)axp;
 	}
-	BUG_ON(axp->pid_count > AUDIT_AUX_PIDS);
+	BUG_ON(axp->pid_count >= AUDIT_AUX_PIDS);
 
 	axp->target_pid[axp->pid_count] = t->tgid;
 	selinux_get_task_sid(t, &axp->target_sid[axp->pid_count]);

