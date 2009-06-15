Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZFOC4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZFOC4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbZFOCzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:55:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58190 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbZFOCzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:55:55 -0400
Message-ID: <4A35B898.2050607@cn.fujitsu.com>
Date: Mon, 15 Jun 2009 10:57:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] tracing: replace a GFP_ATOMIC with GFP_KERNEL allocation
References: <4A35B84B.40904@cn.fujitsu.com>
In-Reply-To: <4A35B84B.40904@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atomic allocation is not needed here.

[ Impact: clean up ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7355a38..0f57f1b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3627,7 +3627,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	struct trace_seq *s;
 	unsigned long cnt;
 
-	s = kmalloc(sizeof(*s), GFP_ATOMIC);
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return ENOMEM;
 
-- 
1.5.4.rc3


