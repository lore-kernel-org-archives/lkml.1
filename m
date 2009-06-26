Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZFZDOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZFZDOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 23:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZFZDOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 23:14:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56837 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbZFZDOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 23:14:46 -0400
Message-ID: <4A443D59.4080307@cn.fujitsu.com>
Date: Fri, 26 Jun 2009 11:15:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: fix the output of profile
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first entry of the ftrace profile was always skipped when
reading trace_stat/functionX.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5771cc1..673fc8b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -291,7 +291,9 @@ function_stat_next(void *v, int idx)
 	pg = (struct ftrace_profile_page *)((unsigned long)rec & PAGE_MASK);
 
  again:
-	rec++;
+	if (idx != 0)
+		rec++;
+
 	if ((void *)rec >= (void *)&pg->records[pg->index]) {
 		pg = pg->next;
 		if (!pg)
-- 
1.5.4.rc3

