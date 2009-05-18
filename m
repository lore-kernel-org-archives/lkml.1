Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbZERMk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbZERMk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 08:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZERMkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 08:40:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:12619 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZERMkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 08:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=PybzO913YntEOlWC0Lg9RPENtk2e4Qo+Dk8lI19WzTHmKDwpHeD193GznqUfwbA88P
         S4BZ2abBD4P2ijxZqo3SBBIRH/VmfG+oQyksiOAaEGHtqvT0LDdRfQniZNcIxhlMzYnt
         r+q3St9IHK1EKOkj1kx4Xe0RyI2luVAgg1YsY=
Date: Mon, 18 May 2009 20:39:57 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] ftrace:fix check for return value of
 register_module_notifier
Message-ID: <20090518203957.0bc1eff8@linux-lm>
In-Reply-To: <4A10B1B4.5080309@cn.fujitsu.com>
References: <1242545498-7285-1-git-send-email-tom.leiming@gmail.com>
	<4A10B1B4.5080309@cn.fujitsu.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d0d91950165f1d0a05ce8f68b333c6f0724b0007 Mon Sep 17 00:00:00 2001
From: Ming Lei <tom.leiming@gmail.com>
Date: Sun, 17 May 2009 15:26:28 +0800
Subject: [PATCH] ftrace:fix check for return value of register_module_notifier(v2)

return zero should be correct, so fix it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com> 
---
 kernel/trace/ftrace.c       |    2 +-
 kernel/trace/trace_events.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0eec0c5..9e91c4a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1174,7 +1174,7 @@ static __init int event_trace_init(void)
 	}
 
 	ret = register_module_notifier(&trace_module_nb);
-	if (!ret)
+	if (ret)
 		pr_warning("Failed to register trace events module notifier\n");
 
 	return 0;
-- 
1.6.0.GIT



-- 
Lei Ming
