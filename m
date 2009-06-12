Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbZFLMnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbZFLMnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbZFLMnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:43:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:52555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107AbZFLMnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:43:19 -0400
Date: Fri, 12 Jun 2009 12:42:40 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: PERF_TYPE_HW_CACHE is a hardware counter too
Message-ID: <tip-f1a3c979059b2033d0b1cc4f9ee5c90bf92b5f94@git.kernel.org>
Git-Commit-ID: f1a3c979059b2033d0b1cc4f9ee5c90bf92b5f94
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 12 Jun 2009 12:42:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1a3c979059b2033d0b1cc4f9ee5c90bf92b5f94
Gitweb:     http://git.kernel.org/tip/f1a3c979059b2033d0b1cc4f9ee5c90bf92b5f94
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 11 Jun 2009 17:56:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 12 Jun 2009 14:28:51 +0200

perf_counter: PERF_TYPE_HW_CACHE is a hardware counter too

is_software_counter() was missing the new HW_CACHE category.

( This could have caused some counter scheduling artifacts
  with mixed sw and hw counters and counter groups. )

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 6e13395..7c4f32f 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -621,7 +621,8 @@ extern int perf_counter_overflow(struct perf_counter *counter, int nmi,
 static inline int is_software_counter(struct perf_counter *counter)
 {
 	return (counter->attr.type != PERF_TYPE_RAW) &&
-		(counter->attr.type != PERF_TYPE_HARDWARE);
+		(counter->attr.type != PERF_TYPE_HARDWARE) &&
+		(counter->attr.type != PERF_TYPE_HW_CACHE);
 }
 
 extern void perf_swcounter_event(u32, u64, int, struct pt_regs *, u64);
