Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbZFLMnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbZFLMnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZFLMnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:43:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:52544 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbZFLMnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:43:08 -0400
Date: Fri, 12 Jun 2009 12:42:28 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:core/urgent] lockdep: Select frame pointers on x86
Message-ID: <tip-cac455509f22fede26b04889a8d2199af694a903@git.kernel.org>
Git-Commit-ID: cac455509f22fede26b04889a8d2199af694a903
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 12 Jun 2009 12:42:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cac455509f22fede26b04889a8d2199af694a903
Gitweb:     http://git.kernel.org/tip/cac455509f22fede26b04889a8d2199af694a903
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 12 Jun 2009 10:04:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 12 Jun 2009 14:25:00 +0200

lockdep: Select frame pointers on x86

x86 stack traces are a piece of crap without frame pointers, and its not
like the 'performance gain' of not having stack pointers matters when you
selected lockdep.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <new-submission>
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
 
