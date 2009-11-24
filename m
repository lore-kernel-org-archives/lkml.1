Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZKXHWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZKXHWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbZKXHWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:22:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:35114 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbZKXHWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:22:34 -0500
Date: Tue, 24 Nov 2009 07:21:48 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       michael@ellerman.id.au, fweisbec@gmail.com, tglx@linutronix.de,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       michael@ellerman.id.au, fweisbec@gmail.com, tglx@linutronix.de,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1259011812-8093-1-git-send-email-fweisbec@gmail.com>
References: <1259011812-8093-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw-breakpoints: Fix misordered ifdef
Message-ID: <tip-fa7c27ee9394fc0d52404b2a89882e95868a60b9@git.kernel.org>
Git-Commit-ID: fa7c27ee9394fc0d52404b2a89882e95868a60b9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa7c27ee9394fc0d52404b2a89882e95868a60b9
Gitweb:     http://git.kernel.org/tip/fa7c27ee9394fc0d52404b2a89882e95868a60b9
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 23 Nov 2009 22:30:12 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Nov 2009 00:09:53 +0100

hw-breakpoints: Fix misordered ifdef

Fix a misplaced ifdef. We need the perf event headers also in
off-case to avoid the following build error:

 include/linux/hw_breakpoint.h:94: error: expected declaration specifiers or '...' before 'perf_callback_t'
 include/linux/hw_breakpoint.h:102: error: expected declaration specifiers or '...' before 'perf_callback_t'
 include/linux/hw_breakpoint.h:109: error: expected declaration specifiers or '...' before 'perf_callback_t'
 include/linux/hw_breakpoint.h:116: error: expected declaration specifiers or '...' before 'perf_callback_t'

Reported-by: Kisskb-bot by Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <1259011812-8093-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/hw_breakpoint.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 76a48ab..c9f7f7c 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -15,10 +15,11 @@ enum {
 };
 
 #ifdef __KERNEL__
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
 
 #include <linux/perf_event.h>
 
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+
 static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
 {
 	return bp->attr.bp_addr;
