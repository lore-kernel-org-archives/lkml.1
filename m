Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbYGGQuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbYGGQuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbYGGQtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:49:55 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753133AbYGGQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:49:54 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/20] SELinux: use do_each_thread as a proper do/while block
Date: Tue,  8 Jul 2008 01:42:20 +0900
Message-Id: <1215448942-17581-19-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use do_each_thread as a proper do/while block.  Sparse complained.

Signed-off-by: James Morris <jmorris@namei.org>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
---
 security/selinux/hooks.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6e8d0e9..4130d64 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5196,12 +5196,12 @@ static int selinux_setprocattr(struct task_struct *p,
 			struct task_struct *g, *t;
 			struct mm_struct *mm = p->mm;
 			read_lock(&tasklist_lock);
-			do_each_thread(g, t)
+			do_each_thread(g, t) {
 				if (t->mm == mm && t != p) {
 					read_unlock(&tasklist_lock);
 					return -EPERM;
 				}
-			while_each_thread(g, t);
+			} while_each_thread(g, t);
 			read_unlock(&tasklist_lock);
 		}
 
-- 
1.5.5.1

