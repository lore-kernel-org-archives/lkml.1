Return-Path: <linux-kernel-owner+w=401wt.eu-S1762493AbZEGJaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762493AbZEGJaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761867AbZEGJZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:25:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:45069 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761840AbZEGJZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:25:04 -0400
Date: Thu, 7 May 2009 09:24:32 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144604.256645000@intel.com>
References: <20090403144604.256645000@intel.com>
Subject: [tip:tracing/core] x86, ds: dont use TIF_DEBUGCTLMSR
Message-ID: <tip-6047550d3d26fed88b18a208b31f8b90b5ef3e9b@git.kernel.org>
Git-Commit-ID: 6047550d3d26fed88b18a208b31f8b90b5ef3e9b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:24:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6047550d3d26fed88b18a208b31f8b90b5ef3e9b
Gitweb:     http://git.kernel.org/tip/6047550d3d26fed88b18a208b31f8b90b5ef3e9b
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:32 +0200

x86, ds: dont use TIF_DEBUGCTLMSR

Debug store already uses TIF_DS_AREA_MSR to trigger debug store context
switch handling. No need to use TIF_DEBUGCTLMSR, as well.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144604.256645000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 443f415..cab2832 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -925,11 +925,6 @@ static void update_task_debugctlmsr(struct task_struct *task,
 	get_cpu();
 	if (task == current)
 		update_debugctlmsr(debugctlmsr);
-
-	if (task->thread.debugctlmsr)
-		set_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
-	else
-		clear_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
 	put_cpu();
 }
 
