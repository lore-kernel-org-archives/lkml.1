Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbZK0XJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbZK0XJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbZK0XGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:06:05 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60406 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbZK0XGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:03 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH v3 01/27] SECURITY: selinux, fix update_rlimit_cpu parameter
Date: Sat, 28 Nov 2009 00:05:41 +0100
Message-Id: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

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
index bb230d5..36d9e25 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2366,7 +2366,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 			initrlim = init_task.signal->rlim + i;
 			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
 		}
-		update_rlimit_cpu(rlim->rlim_cur);
+		update_rlimit_cpu(current->signal->rlim[RLIMIT_CPU].rlim_cur);
 	}
 }
 
-- 
1.6.5.3

