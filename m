Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbZHPMxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbZHPMxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 08:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbZHPMxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 08:53:36 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:65163 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZHPMxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 08:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tq/zfQX5cNmVNpD1qbM5WSnBuQSyL1rVjWEEjiIM9qUh0dh/l4vlvHPaeMbaUOb3ya
         clH0Xw28yPFB09BlmQHYOPlVgXXZW+0Cpg1jcReSgL6cWvnKSQjaTAS5A74tPQ8MjJ+p
         2oRsVUUcc/9P4ENPXGpS7sh38gEhbqbbAwxBo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH] perf tools: Revert the -Wswitch-enum flag
Date: Sun, 16 Aug 2009 14:53:32 +0200
Message-Id: <1250427212-8323-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <tip-83a0944fa919fb2ebcfc1f8933d86e437b597ca6@git.kernel.org>
References: <tip-83a0944fa919fb2ebcfc1f8933d86e437b597ca6@git.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Wswitch-enum warns when a switch statement doesn't handle
every enum values of a given type.

But it also warns whn we have a default case where we handle them.
This forces workarounds like having a rain of ignored enum values
cases falling down to the default case.

We want to be sure that every cases are handled (which is what does
-Wswitch-default), but we don't want to explicitly write what must
fall down to the default case.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d637aea..c7c2645 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -169,7 +169,7 @@ endif
 #
 # Include saner warnings here, which can catch bugs:
 #
-EXTRA_WARNINGS = -Wcast-align -Wformat=2 -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement
+EXTRA_WARNINGS = -Wcast-align -Wformat=2 -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement
 
 CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
-- 
1.6.2.3

