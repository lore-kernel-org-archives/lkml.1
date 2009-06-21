Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbZFUIQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbZFUIQX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 04:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbZFUIQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 04:16:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:54077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZFUIQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 04:16:12 -0400
Date: Sun, 21 Jun 2009 08:15:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:core/urgent] lockdep: Select frame pointers on x86
Message-ID: <tip-00540e5d54be972a94a3b2ce6da8621bebe731a2@git.kernel.org>
Git-Commit-ID: 00540e5d54be972a94a3b2ce6da8621bebe731a2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 21 Jun 2009 08:15:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00540e5d54be972a94a3b2ce6da8621bebe731a2
Gitweb:     http://git.kernel.org/tip/00540e5d54be972a94a3b2ce6da8621bebe731a2
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 12 Jun 2009 10:04:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 21 Jun 2009 10:14:33 +0200

lockdep: Select frame pointers on x86

x86 stack traces are a piece of crap without frame pointers, and its not
like the 'performance gain' of not having stack pointers matters when you
selected lockdep.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <new-submission>
Cc: <stable@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6cdcf38..3be4b7c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -440,7 +440,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !X86 && !MIPS && !PPC && !ARM_UNWIND && !S390
+	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390
 	select KALLSYMS
 	select KALLSYMS_ALL
 
