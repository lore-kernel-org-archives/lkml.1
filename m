Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbZJLUoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbZJLUoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZJLUoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:44:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:48187 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757992AbZJLUoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:44:23 -0400
Date: Mon, 12 Oct 2009 20:43:08 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, arjan@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091006070452.5e1fc119@infradead.org>
References: <20091006070452.5e1fc119@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Don't use the strict copy checks when branch profiling is in use
Message-ID: <tip-ad8f4356af58f7ded6b4a5787c67c7cab51066b5@git.kernel.org>
Git-Commit-ID: ad8f4356af58f7ded6b4a5787c67c7cab51066b5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 20:43:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad8f4356af58f7ded6b4a5787c67c7cab51066b5
Gitweb:     http://git.kernel.org/tip/ad8f4356af58f7ded6b4a5787c67c7cab51066b5
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Tue, 6 Oct 2009 07:04:52 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Oct 2009 22:29:51 +0200

x86: Don't use the strict copy checks when branch profiling is in use

The branch profiling creates very complex code for each if
statement, to the point that gcc has trouble even analyzing
something as simple as

  if (count > 5)
      count = 5;

This then means that causing an error on code that gcc cannot
analyze for copy_from_user() and co is not very productive.

This patch excludes the strict copy checks in the case of branch
profiling being enabled.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20091006070452.5e1fc119@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 1bd2e36..fb772b6 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -289,7 +289,7 @@ config OPTIMIZE_INLINING
 
 config DEBUG_STRICT_USER_COPY_CHECKS
 	bool "Strict copy size checks"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
 	---help---
 	  Enabling this option turns a certain set of sanity checks for user
 	  copy operations into compile time failures.
