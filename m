Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZCFPRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZCFPRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZCFPQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:16:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:39374 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbZCFPQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:16:47 -0500
Date: Fri, 6 Mar 2009 15:15:28 GMT
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090305084954.A22000@sedona.ch.intel.com>
References: <20090305084954.A22000@sedona.ch.intel.com>
Subject: [tip:x86/urgent] x86, bts: remove bad warning
Message-ID: <tip-9ca0791dcaa666e8e8f4b4ca028b65b4bde9cb28@git.kernel.org>
Git-Commit-ID: 9ca0791dcaa666e8e8f4b4ca028b65b4bde9cb28
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 15:15:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ca0791dcaa666e8e8f4b4ca028b65b4bde9cb28
Gitweb:     http://git.kernel.org/tip/9ca0791dcaa666e8e8f4b4ca028b65b4bde9cb28
Author:     "Markus Metzger" <markus.t.metzger@intel.com>
AuthorDate: Thu, 5 Mar 2009 08:49:54 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 16:13:15 +0100

x86, bts: remove bad warning

In case a ptraced task is reaped (while the tracer is still attached),
ds_exit_thread() is called before ptrace_exit(). The latter will
release the bts_tracer and remove the thread's ds_ctx.
The former will WARN() if the context is not NULL.

Oleg Nesterov submitted patches that move ptrace_exit() before
exit_thread() and thus reverse the order of the above calls.

Remove the bad warning. I will add it again when Oleg's changes are in.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
LKML-Reference: <20090305084954.A22000@sedona.ch.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 169a120..de7cdbd 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -1029,5 +1029,4 @@ void ds_copy_thread(struct task_struct *tsk, struct task_struct *father)
 
 void ds_exit_thread(struct task_struct *tsk)
 {
-	WARN_ON(tsk->thread.ds_ctx);
 }
