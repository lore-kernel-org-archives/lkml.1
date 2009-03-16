Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbZCPIU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbZCPIU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758249AbZCPITx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:19:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:44672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255AbZCPITv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:19:51 -0400
Date: Mon, 16 Mar 2009 08:19:16 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237151439-6755-5-git-send-email-fweisbec@gmail.com>
References: <1237151439-6755-5-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/syscalls] tracing/core: fix missing mutex unlock on tracing_set_tracer()
Message-ID: <tip-59f586db98919d7d9c43527b26c8de1cdf9ed912@git.kernel.org>
Git-Commit-ID: 59f586db98919d7d9c43527b26c8de1cdf9ed912
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 08:19:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59f586db98919d7d9c43527b26c8de1cdf9ed912
Gitweb:     http://git.kernel.org/tip/59f586db98919d7d9c43527b26c8de1cdf9ed912
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 15 Mar 2009 22:10:39 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Mar 2009 09:13:17 +0100

tracing/core: fix missing mutex unlock on tracing_set_tracer()

Impact: fix possible locking imbalance

In case of ring buffer resize failure, tracing_set_tracer forgot to
release trace_types_lock. Fix it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237151439-6755-5-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index efe3202..c0cf946 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2494,7 +2494,7 @@ static int tracing_set_tracer(const char *buf)
 	if (!ring_buffer_expanded) {
 		ret = tracing_resize_ring_buffer(trace_buf_size);
 		if (ret < 0)
-			return ret;
+			goto out;
 		ret = 0;
 	}
 
