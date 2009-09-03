Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbZICUIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbZICUIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbZICUIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:08:40 -0400
Received: from server1.wserver.cz ([82.113.45.157]:51024 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbZICUIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:08:38 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: oleg@redhat.com
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>, David Howells <dhowells@redhat.com>
Subject: [PATCH v2 1/8] SECURITY: selinux, fix update_rlimit_cpu parameter
Date: Thu,  3 Sep 2009 22:08:37 +0200
Message-Id: <1252008524-5376-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090903174106.GC27161@redhat.com>
References: <20090903174106.GC27161@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, thanks, I ended up having this so far.
--
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

