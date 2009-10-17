Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZJQVV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZJQVV0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 17:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbZJQVVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 17:21:24 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60862 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbZJQVVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 17:21:22 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH -repost 1/8] SECURITY: selinux, fix update_rlimit_cpu parameter
Date: Sat, 17 Oct 2009 23:21:15 +0200
Message-Id: <1255814482-13994-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't pass rlim_cur member of RLIM_NLIMITS-1=RLIMIT_RTTIME limit
to update_rlimit_cpu() in selinux_bprm_committing_creds.

Use proper rlim[RLIMIT_CPU].rlim_cur instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@parisplace.org>
Cc: David Howells <dhowells@redhat.com>
---
 security/selinux/hooks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a29d661..5718abc 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2365,7 +2365,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 			initrlim = init_task.signal->rlim + i;
 			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
 		}
-		update_rlimit_cpu(rlim->rlim_cur);
+		update_rlimit_cpu(current->signal->rlim[RLIMIT_CPU].rlim_cur);
 	}
 }
 
-- 
1.6.4.2

