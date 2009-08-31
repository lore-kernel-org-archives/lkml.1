Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZHaS4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZHaS4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZHaS4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:56:10 -0400
Received: from server1.wserver.cz ([82.113.45.157]:36620 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZHaS4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:56:09 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: mingo@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH 1/6] SECURITY: selinux, fix update_rlimit_cpu parameter
Date: Mon, 31 Aug 2009 20:56:09 +0200
Message-Id: <1251744974-29398-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I posted this one earlier, but for the sake of completeness and
applicability, reposting.
--

Don't pass rlim_cur member of RLIM_NLIMITS-1=RLIMIT_RTTIME limit
to update_rlimit_cpu() in selinux_bprm_committing_creds.

Use proper rlim[RLIMIT_CPU].rlim_cur instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: David Howells <dhowells@redhat.com>
---
 security/selinux/hooks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index cf41988..496e626 100644
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

