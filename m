Return-Path: <linux-kernel-owner+w=401wt.eu-S1751293AbZH1JLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbZH1JLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 05:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbZH1JLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 05:11:54 -0400
Received: from server1.wserver.cz ([82.113.45.157]:38086 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZH1JLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 05:11:53 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, David Howells <dhowells@redhat.com>
Subject: [PATCH 1/1] SECURITY: selinux, fix update_rlimit_cpu parameter
Date: Fri, 28 Aug 2009 11:11:54 +0200
Message-Id: <1251450714-1498-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't pass rlim_cur member of RLIM_NLIMITS-1=RLIMIT_RTTIME limit
to update_rlimit_cpu() in selinux_bprm_committing_creds.

Use proper rlim[RLIMIT_CPU].rlim_cur instead.

Introduced by f06febc96ba8e0af80bcc3eaec0a109e88275fac
(timers: fix itimer/many thread hang)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: David Howells <dhowells@redhat.com>
---
 security/selinux/hooks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 205f5b0..839622a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2360,7 +2360,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 			initrlim = init_task.signal->rlim + i;
 			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
 		}
-		update_rlimit_cpu(rlim->rlim_cur);
+		update_rlimit_cpu(current->signal->rlim[RLIMIT_CPU].rlim_cur);
 	}
 }
 
-- 
1.6.3.3

