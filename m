Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZL1KKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZL1KKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZL1KKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:10:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:36398 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZL1KKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:10:14 -0500
Date: Mon, 28 Dec 2009 10:08:18 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091221120224.GA4471@osiris.boeblingen.de.ibm.com>
References: <20091221120224.GA4471@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes: Fix distinct type warning
Message-ID: <tip-c2ef6661ce62e26a8c0978e521fab646128a144b@git.kernel.org>
Git-Commit-ID: c2ef6661ce62e26a8c0978e521fab646128a144b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2ef6661ce62e26a8c0978e521fab646128a144b
Gitweb:     http://git.kernel.org/tip/c2ef6661ce62e26a8c0978e521fab646128a144b
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Mon, 21 Dec 2009 13:02:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 10:25:31 +0100

kprobes: Fix distinct type warning

Every time I see this:

 kernel/kprobes.c: In function 'register_kretprobe':
 kernel/kprobes.c:1038: warning: comparison of distinct pointer types lacks a cast

I'm wondering if something changed in common code and we need to
do something for s390. Apparently that's not the case.
Let's get rid of this annoying warning.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <20091221120224.GA4471@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e5342a3..b7df302 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1035,7 +1035,7 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 	/* Pre-allocate memory for max kretprobe instances */
 	if (rp->maxactive <= 0) {
 #ifdef CONFIG_PREEMPT
-		rp->maxactive = max(10, 2 * num_possible_cpus());
+		rp->maxactive = max_t(unsigned int, 10, 2*num_possible_cpus());
 #else
 		rp->maxactive = num_possible_cpus();
 #endif
