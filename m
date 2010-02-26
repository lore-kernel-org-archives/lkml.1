Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab0BZKZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:25:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:34374 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406Ab0BZKZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:25:36 -0500
Date: Fri, 26 Feb 2010 10:24:49 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
       davem@davemloft.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, davem@davemloft.net,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Report the MMAP pgoff value in bytes
Message-ID: <tip-3a0304e90aa5a2c0c308a05d28f7d109a48d8539@git.kernel.org>
Git-Commit-ID: 3a0304e90aa5a2c0c308a05d28f7d109a48d8539
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 10:24:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a0304e90aa5a2c0c308a05d28f7d109a48d8539
Gitweb:     http://git.kernel.org/tip/3a0304e90aa5a2c0c308a05d28f7d109a48d8539
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 26 Feb 2010 10:33:41 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Feb 2010 10:56:52 +0100

perf_events: Report the MMAP pgoff value in bytes

DaveM reported that currently perf interprets the pgoff value reported by
the MMAP events as a byte range, but the kernel reports it as a page
offset.

Since its broken (and unusable) anyway, change the kernel behaviour (ABI)
to report bytes indeed, avoiding the need for userspace to deal with
PAGE_SIZE things.

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 087025f..5a69abb 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3749,7 +3749,7 @@ void __perf_event_mmap(struct vm_area_struct *vma)
 			/* .tid */
 			.start  = vma->vm_start,
 			.len    = vma->vm_end - vma->vm_start,
-			.pgoff  = vma->vm_pgoff,
+			.pgoff  = (u64)vma->vm_pgoff << PAGE_SHIFT,
 		},
 	};
 
