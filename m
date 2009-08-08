Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZHHLyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZHHLyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 07:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZHHLyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 07:54:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:55086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbZHHLya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 07:54:30 -0400
Date: Sat, 8 Aug 2009 11:52:42 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249698400-5441-6-git-send-email-fweisbec@gmail.com>
References: <1249698400-5441-6-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf_counter: Fix ftrace events raw samples to be aligned to 8 bytes
Message-ID: <tip-eba67b1fd06180d57b94bf97557d89873b0ce61e@git.kernel.org>
Git-Commit-ID: eba67b1fd06180d57b94bf97557d89873b0ce61e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 11:52:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eba67b1fd06180d57b94bf97557d89873b0ce61e
Gitweb:     http://git.kernel.org/tip/eba67b1fd06180d57b94bf97557d89873b0ce61e
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 8 Aug 2009 04:26:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 13:49:23 +0200

perf_counter: Fix ftrace events raw samples to be aligned to 8 bytes

Align the ftrace events raw samples to 8 bytes so that they
meet the perf output event alignment requirements.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1249698400-5441-6-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/trace/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index bbf9042..7fb16d9 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -685,7 +685,7 @@ static void ftrace_profile_##call(proto)				\
 	pc = preempt_count();						\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
-	__entry_size = __data_size + sizeof(*entry);			\
+	__entry_size = ALIGN(__data_size + sizeof(*entry), sizeof(u64));\
 									\
 	do {								\
 		char raw_data[__entry_size];				\
