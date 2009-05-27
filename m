Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbZE0DDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbZE0DDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbZE0DDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:03:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57538 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbZE0DDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:03:24 -0400
Message-ID: <4A1CADD0.4070309@cn.fujitsu.com>
Date: Wed, 27 May 2009 11:04:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing/stat: remember to free root node
References: <4A1CADBA.7000707@cn.fujitsu.com>
In-Reply-To: <4A1CADBA.7000707@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When closing a trace_stat file, we destroy the rbtree constructed during
file open, but there is memory leak that the root node is not freed.

[ Impact: fix memory leak when closing a trace_stat file ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_stat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 8b7420a..a80d947 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -60,8 +60,8 @@ static struct rb_node *release_next(struct rb_node *node)
 		return node->rb_right;
 	else {
 		if (!parent)
-			return NULL;
-		if (parent->rb_left == node)
+			;
+		else if (parent->rb_left == node)
 			parent->rb_left = NULL;
 		else
 			parent->rb_right = NULL;
-- 
1.5.4.rc3


