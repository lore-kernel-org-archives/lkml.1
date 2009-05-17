Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZEQHie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZEQHie (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 03:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZEQHiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 03:38:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:1492 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZEQHiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 03:38:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oCWYsqAM6e662BMUxNKyONdb90HLj4+CMJQxRFFarfyZa3BSrhrN1RqRxrAf0uDQ4D
         YAoF+GHPlx5WKon9yvXozWSvDYkBkIC3VdmKMWFbRmlu7BR/gvf9Cw77xSa3flsNCkgI
         F+jkE2ZY2bXmSsmu4RcRGp8aXnnHwuq8mDn7Y=
From: tom.leiming@gmail.com
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] ftrace:fix check for return value of register_module_notifier
Date: Sun, 17 May 2009 15:31:38 +0800
Message-Id: <1242545498-7285-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

return zero should be correct, so fix it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5b606f4..140699a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2826,7 +2826,7 @@ void __init ftrace_init(void)
 				  __stop_mcount_loc);
 
 	ret = register_module_notifier(&ftrace_module_nb);
-	if (!ret)
+	if (ret)
 		pr_warning("Failed to register trace ftrace module notifier\n");
 
 	return;
-- 
1.6.0.GIT

