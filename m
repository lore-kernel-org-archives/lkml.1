Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbXJCO27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbXJCO27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbXJCO2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:28:52 -0400
Received: from sacred.ru ([62.205.161.221]:56402 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbXJCO2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:28:51 -0400
Message-ID: <4703A67E.1070209@openvz.org>
Date: Wed, 03 Oct 2007 18:26:06 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       "H. Peter Anvin" <hpa@zytor.com>, Paul Menage <menage@google.com>
Subject: [PATCH] Use task_pid_nr() instead of pid_nr(task_pid())
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 03 Oct 2007 18:28:29 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are two places that do so - the cgroups subsystem 
and the autofs code.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 592f640..5efff3c 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -214,7 +214,7 @@ static struct dentry *autofs_root_lookup
 
 	oz_mode = autofs_oz_mode(sbi);
 	DPRINTK(("autofs_lookup: pid = %u, pgrp = %u, catatonic = %d, "
-				"oz_mode = %d\n", pid_nr(task_pid(current)),
+				"oz_mode = %d\n", task_pid_nr(current),
 				task_pgrp_nr(current), sbi->catatonic,
 				oz_mode));
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1e8aa53..8720881 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1762,7 +1762,7 @@ static int pid_array_load(pid_t *pidarra
 	while ((tsk = cgroup_iter_next(cont, &it))) {
 		if (unlikely(n == npids))
 			break;
-		pidarray[n++] = pid_nr(task_pid(tsk));
+		pidarray[n++] = task_pid_nr(tsk);
 	}
 	cgroup_iter_end(cont, &it);
 	return n;

