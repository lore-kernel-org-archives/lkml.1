Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbZBJSpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbZBJSpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 13:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZBJSov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 13:44:51 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:56226 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbZBJSou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 13:44:50 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 3/3] trace: fix sparce warning: attribute function with
	__acquires/__releases
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Feb 2009 19:44:45 +0100
Message-ID: <20090210184443.28131.8584.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090210184214.28131.90564.stgit@vmbox.hanneseder.net>
References: <20090210184214.28131.90564.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  kernel/trace/trace.c:458:9: warning: context imbalance in 'register_tracer' - unexpected unlock

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 kernel/trace/trace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 16b8be4..5762fa5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -439,6 +439,8 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
  * Register a new plugin tracer.
  */
 int register_tracer(struct tracer *type)
+__releases(kernel_lock)
+__acquires(kernel_lock)
 {
 	struct tracer *t;
 	int len;

