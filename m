Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbZLFUKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbZLFUKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZLFUKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:10:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:40033 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086AbZLFUKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:10:43 -0500
Date: Sun, 6 Dec 2009 20:09:48 GMT
From: tip-bot for Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       geert@linux-m68k.org, torvalds@linux-foundation.org,
       rusty@rustcorp.com.au, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       geert@linux-m68k.org, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.0912062038070.5693@ayla.of.borg>
References: <alpine.DEB.2.00.0912062038070.5693@ayla.of.borg>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] cpumask: Fix generate_sched_domains() for UP
Message-ID: <tip-e1b8090bdf125f8b2e192149547fead7f302a89c@git.kernel.org>
Git-Commit-ID: e1b8090bdf125f8b2e192149547fead7f302a89c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1b8090bdf125f8b2e192149547fead7f302a89c
Gitweb:     http://git.kernel.org/tip/e1b8090bdf125f8b2e192149547fead7f302a89c
Author:     Geert Uytterhoeven <geert@linux-m68k.org>
AuthorDate: Sun, 6 Dec 2009 20:41:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 6 Dec 2009 21:08:41 +0100

cpumask: Fix generate_sched_domains() for UP

Commit acc3f5d7cabbfd6cec71f0c1f9900621fa2d6ae7 ("cpumask:
Partition_sched_domains takes array of cpumask_var_t") changed
the function signature of generate_sched_domains() for the
CONFIG_SMP=y case, but forgot to update the corresponding
function for the CONFIG_SMP=n case, causing:

  kernel/cpuset.c:2073: warning: passing argument 1 of 'generate_sched_domains' from incompatible pointer type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <alpine.DEB.2.00.0912062038070.5693@ayla.of.borg>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/cpuset.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3cf2183..43fb7e8 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -737,7 +737,7 @@ static void do_rebuild_sched_domains(struct work_struct *unused)
 {
 }
 
-static int generate_sched_domains(struct cpumask **domains,
+static int generate_sched_domains(cpumask_var_t **domains,
 			struct sched_domain_attr **attributes)
 {
 	*domains = NULL;
