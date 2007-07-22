Return-Path: <linux-kernel-owner+w=401wt.eu-S1762429AbXGVSwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762429AbXGVSwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761125AbXGVSwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:52:19 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:35570
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761524AbXGVSwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:52:17 -0400
Date: Sun, 22 Jul 2007 20:54:07 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] mm/oom_kill.c: Use list_for_each_entry instead of list_for_each
Message-ID: <20070722185407.GJ27415@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070722184202.GF27415@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070722184202.GF27415@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mm/oom_kill.c: Convert list_for_each to list_for_each_entry in
oom_kill_process()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index a700141..b1851c4 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -347,7 +347,6 @@ static int oom_kill_process(struct task_struct *p, unsigned long points,
 		const char *message)
 {
 	struct task_struct *c;
-	struct list_head *tsk;
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -362,8 +361,7 @@ static int oom_kill_process(struct task_struct *p, unsigned long points,
 					message, p->pid, p->comm, points);
 
 	/* Try to kill a child first */
-	list_for_each(tsk, &p->children) {
-		c = list_entry(tsk, struct task_struct, sibling);
+	list_for_each_entry(c, &p->children, sibling) {
 		if (c->mm == p->mm)
 			continue;
 		if (!oom_kill_task(c))

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    Ma patrie est où je suis, où personne ne me dérange, où personne
    ne me demande que je suis, d'où je viens et ce que je fais
                              (B. Traven)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
