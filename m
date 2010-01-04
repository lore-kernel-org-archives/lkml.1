Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375Ab0ADKsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0ADKsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 05:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923Ab0ADKsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 05:48:23 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:40487 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0ADKsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 05:48:23 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com, nhorman@tuxdriver.com,
       mingo@elte.hu, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>, David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] SECURITY: selinux, fix update_rlimit_cpu parameter
Date: Mon,  4 Jan 2010 11:48:13 +0100
Message-Id: <1262602095-17591-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <4B41C750.9080305@gmail.com>
References: <4B41C750.9080305@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Don't pass current RLIMIT_RTTIME to update_rlimit_cpu() in
selinux_bprm_committing_creds, since update_rlimit_cpu expects
RLIMIT_CPU limit.

Use proper rlim[RLIMIT_CPU].rlim_cur instead to fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@parisplace.org>
Cc: David Howells <dhowells@redhat.com>
---
 security/selinux/hooks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7a374c2..9a2ee84 100644
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
1.6.5.7

