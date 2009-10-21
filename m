Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZJUOg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZJUOg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbZJUOgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:36:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbZJUOgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:36:53 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/4] tracing: fix trace_seq_printf return value
Date: Wed, 21 Oct 2009 16:36:39 +0200
Message-Id: <1256135801-1849-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
References: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe we want to return the number of written characters,
instead of the available buffer length.

wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_output.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index ed17565..e871125 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -95,7 +95,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 
 	s->len += ret;
 
-	return len;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_printf);
 
-- 
1.6.2.5

