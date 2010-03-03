Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab0CCHFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:05:04 -0500
Received: from mail-gx0-f227.google.com ([209.85.217.227]:54426 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab0CCHEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:04:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sFzwP70j/gN18u5TOOTA80sm3OP7STHTTLs6jFkpdUoAb7EYNqC1+UxECVmW751LQm
         3hriNbu/o6+Yj1beNzLclOHHB3PQHWtQL5Sv7S2E0+Raj907kNmOZVrIG8ga/KtoLQTU
         Y5OJdy/eHV7aqh9ufluMNug7v0Z0UsQPGHg1s=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH 2/2] perf trace: don't use pager if scripting
Date: Wed,  3 Mar 2010 01:04:33 -0600
Message-Id: <1267599873-8193-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1267599873-8193-1-git-send-email-tzanussi@gmail.com>
References: <1267599873-8193-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's useful for paging through raw traces, but just gets in the way
when scripting.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b8153db..407041d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -573,7 +573,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 
 	if (symbol__init() < 0)
 		return -1;
-	setup_pager();
+	if (!script_name)
+		setup_pager();
 
 	session = perf_session__new(input_name, O_RDONLY, 0);
 	if (session == NULL)
-- 
1.6.4.GIT

