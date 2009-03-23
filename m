Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbZCWQK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbZCWQK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757720AbZCWQKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:10:49 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:49465 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbZCWQKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:10:49 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>
Subject: [PATCH] kernel/trace/trace_functions_graph.c: fix nsecs_str buffer size
Date: Mon, 23 Mar 2009 17:10:37 +0100
Message-Id: <1237824637-28190-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel/trace/trace_functions_graph.c, print_graph_duration(), len can
be as low as 1 or 2, which could make snprintf() write beyond the
buffer bounds. (Found by cppcheck, no real-world bug occured)

Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
 kernel/trace/trace_functions_graph.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 930c08e..7533b25 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -281,7 +281,7 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s)
 	unsigned long nsecs_rem = do_div(duration, 1000);
 	/* log10(ULONG_MAX) + '\0' */
 	char msecs_str[21];
-	char nsecs_str[5];
+	char nsecs_str[8];
 	int ret, len;
 	int i;
 
-- 
1.6.2

