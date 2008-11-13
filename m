Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYKMQVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYKMQVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 11:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYKMQVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 11:21:11 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:53297 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYKMQVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 11:21:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FT3Pex8RVlnX/2SaPkSybtEJSHik+EmBE43ajlbSceaGdcJHprbjkWDNIOx9lOA/Rw
         NiuL1xb2DZ24EEN7qXRAKiIRS9GmCI0MhrtOftu9eTnj5KgHr8XQrk9ndMP9Rc4PxqXa
         7oHd6OFoLLmKb7XB6mvTKGjvd4nkVfIgCvyRE=
From: walimis <walimisdev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ftrace: remove unnecessary if condition of __unregister_ftrace_function
Date: Fri, 14 Nov 2008 00:21:02 +0800
Message-Id: <1226593262-3517-1-git-send-email-walimisdev@gmail.com>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

against ftrace git tree tip/devel branch:
81388fbbc4b00c3bf37db5e193c80106ce5a2abf

Because it has goto out before ftrace_list == &ftrace_list_end,
that's to say, we never meet this condition.

Signed-off-by: walimis <walimisdev@gmail.com>
---
 kernel/trace/ftrace.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index beb21a5..54cb9a7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -179,8 +179,7 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 
 	if (ftrace_enabled) {
 		/* If we only have one func left, then call that directly */
-		if (ftrace_list == &ftrace_list_end ||
-		    ftrace_list->next == &ftrace_list_end)
+		if (ftrace_list->next == &ftrace_list_end)
 			ftrace_trace_function = ftrace_list->func;
 	}
 
-- 
1.6.0.3

