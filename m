Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbZBCCo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbZBCCo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 21:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZBCCn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 21:43:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42092 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZBCCn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 21:43:58 -0500
Message-Id: <20090203024358.093748679@goodmis.org>
References: <20090203023830.440860800@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 02 Feb 2009 21:38:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] trace: disable branch tracer on alpha
Content-Disposition: inline; filename=0001-trace-disable-branch-tracer-on-alpha.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix alpha compiler builds

The profile all branches tracer causes errors on alpha, due to
the use of extern inlines. This patch disables it on alpha.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index dde1d46..2780665 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -183,9 +183,11 @@ config TRACE_BRANCH_PROFILING
 
 	  Say N if unsure.
 
+# PROFILE_ALL_BRANCHES fails on alph due to extern inlines.
 config PROFILE_ALL_BRANCHES
 	bool "Profile all if conditionals"
 	depends on TRACE_BRANCH_PROFILING
+	depends on !ALPHA
 	help
 	  This tracer profiles all branch conditions. Every if ()
 	  taken in the kernel is recorded whether it hit or miss.
-- 
1.5.6.5

-- 
