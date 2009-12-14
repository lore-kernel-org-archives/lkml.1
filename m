Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZLNJvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZLNJvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZLNJvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:51:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:39880 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbZLNJvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:51:49 -0500
Date: Mon, 14 Dec 2009 09:49:44 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091214092412.GA5242@osiris.boeblingen.de.ibm.com>
References: <20091214092412.GA5242@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] hw-breakpoints: Let modify_user_hw_breakpoint() return an int
Message-ID: <tip-4983ee49cf0393fd786891dd53af41146cf9f98b@git.kernel.org>
Git-Commit-ID: 4983ee49cf0393fd786891dd53af41146cf9f98b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4983ee49cf0393fd786891dd53af41146cf9f98b
Gitweb:     http://git.kernel.org/tip/4983ee49cf0393fd786891dd53af41146cf9f98b
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Mon, 14 Dec 2009 10:24:12 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Dec 2009 10:42:57 +0100

hw-breakpoints: Let modify_user_hw_breakpoint() return an int

Let modify_user_hw_breakpoint return an int to avoid hundreds of
compile warnings like this one:

 include/linux/hw_breakpoint.h: In function 'modify_user_hw_breakpoint':
 include/linux/hw_breakpoint.h:96:
  warning: return makes integer from pointer without a cast

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091214092412.GA5242@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/hw_breakpoint.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 41235c9..3f3ac2f 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -90,7 +90,7 @@ static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
 static inline struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
-			    struct task_struct *tsk)	{ return NULL; }
+			    struct task_struct *tsk)	{ return 0; }
 static inline int
 modify_user_hw_breakpoint(struct perf_event *bp,
 			  struct perf_event_attr *attr)	{ return -ENOSYS; }
