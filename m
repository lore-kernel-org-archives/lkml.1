Return-Path: <linux-kernel-owner+w=401wt.eu-S933629AbZKXQ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbZKXQ5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbZKXQ5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:57:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:60284 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933574AbZKXQ5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:57:14 -0500
Date: Tue, 24 Nov 2009 16:56:07 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4b0b71e1.0508d00a.075e.ffff84a3@mx.google.com>
References: <4b0b71e1.0508d00a.075e.ffff84a3@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix bogus copy_to_user() in perf_event_read_group()
Message-ID: <tip-184d3da8ef0ca552dffa0fdd35c046e058a2cf9a@git.kernel.org>
Git-Commit-ID: 184d3da8ef0ca552dffa0fdd35c046e058a2cf9a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  184d3da8ef0ca552dffa0fdd35c046e058a2cf9a
Gitweb:     http://git.kernel.org/tip/184d3da8ef0ca552dffa0fdd35c046e058a2cf9a
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 23 Nov 2009 21:40:49 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Nov 2009 08:55:27 +0100

perf_events: Fix bogus copy_to_user() in perf_event_read_group()

When using an event group, the value and id for non leaders events
were wrong due to invalid offset into the outgoing buffer.

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: paulus@samba.org
Cc: perfmon2-devel@lists.sourceforge.net
LKML-Reference: <4b0b71e1.0508d00a.075e.ffff84a3@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 9425c96..accfd7b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1831,7 +1831,7 @@ static int perf_event_read_group(struct perf_event *event,
 
 		size = n * sizeof(u64);
 
-		if (copy_to_user(buf + size, values, size)) {
+		if (copy_to_user(buf + ret, values, size)) {
 			ret = -EFAULT;
 			goto unlock;
 		}
