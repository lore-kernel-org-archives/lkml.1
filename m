Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZHPPwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZHPPwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 11:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZHPPwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 11:52:11 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:64577 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbZHPPwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 11:52:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vW7mtcov+Vpuv3m+ysCODQBMf9F87CCxzkjKl0CANYN5hOwRTZpSZmlVsU731/2aMD
         3/YBR8XVgtO6lUdhXEq68S810o9OEWN8L1qG3OYumRccxsdApwrNWeO8eQhjkOZL30QY
         G2PYVjZ5oDLm0UTbJ7GY2w7LPz2YzuEYuKp8E=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH] perf tools: Substract -Wformat-nonliteral from Wformat=2 in extra flags
Date: Sun, 16 Aug 2009 17:52:07 +0200
Message-Id: <1250437927-25490-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090816151829.GA8116@elte.hu>
References: <20090816151829.GA8116@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The soon coming perf trace needs to use printf with dynamically built
formats.

But we are using -Wformat=2 which is a shortcut for the following set:
-Wformat -Wformat-security -Wformat-y2k -Wformat-nonliteral

-Wformat-nonliteral warns when it can't check formats because they are
not builtin constant strings, but we want to feature dynamic formats.
What we want instead is Wformat=2 minus -Wformat-nonliteral, which is
what this patch does.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d637aea..5d54ddb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -169,7 +169,7 @@ endif
 #
 # Include saner warnings here, which can catch bugs:
 #
-EXTRA_WARNINGS = -Wcast-align -Wformat=2 -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement
+EXTRA_WARNINGS = -Wcast-align -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement
 
 CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
-- 
1.6.2.3

