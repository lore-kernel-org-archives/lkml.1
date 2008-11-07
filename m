Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYKGPYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYKGPYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYKGPXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:23:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54842 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbYKGPXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:23:38 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v3 2/4] vm: use new has_capability_noaudit
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Cc: sds@tycho.nsa.gov, jmorris@nameil.org, serue@us.ibm.com, morgan@kernel.org,
       casey@schaufler-ca.com, esandeen@redhat.com
Date: Fri, 07 Nov 2008 10:23:32 -0500
Message-ID: <20081107152332.10328.12878.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081107152326.10328.44330.stgit@paris.rdu.redhat.com>
References: <20081107152326.10328.44330.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The oomkiller calculations make decisions based on capabilities.  Since
these are not security decisions and LSMs should not record if they fall
the request they should use the new has_capability_noaudit() interface so
the denials will not be recorded.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 mm/oom_kill.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index a0a0190..df259c2 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -128,8 +128,8 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	 * Superuser processes are usually more important, so we make it
 	 * less likely that we kill those.
 	 */
-	if (has_capability(p, CAP_SYS_ADMIN) ||
-	    has_capability(p, CAP_SYS_RESOURCE))
+	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
+	    has_capability_noaudit(p, CAP_SYS_RESOURCE))
 		points /= 4;
 
 	/*
@@ -138,7 +138,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	 * tend to only have this flag set on applications they think
 	 * of as important.
 	 */
-	if (has_capability(p, CAP_SYS_RAWIO))
+	if (has_capability_noaudit(p, CAP_SYS_RAWIO))
 		points /= 4;
 
 	/*

