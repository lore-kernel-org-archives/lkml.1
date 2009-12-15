Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbZLOCP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbZLOCP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758650AbZLOCP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:15:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64668 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610AbZLOCP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:15:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Nhci+g/cQ7Sy5IjHLNw7pva2PsmcS883wXz3FslHo+eYBUlY3bEABpC2E0i6uX11cF
         d3Bwk26+y/aLulkTO18htDapuXEnr59uwyJdAguChv4IY8m9Y6/BMe8Qt8etlKDGSzwH
         Z0aznGuH2J+JuPGtNXtrWY0g9l2C2C+P6C7tk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf tools: Make symbol_conf static
Date: Tue, 15 Dec 2009 03:15:22 +0100
Message-Id: <1260843322-6602-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf top, report and annotate all define their own symbol_conf, it
should be static.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/builtin-report.c |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 142c475..83b4b67 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -52,7 +52,7 @@ static int		exclude_other = 1;
 
 static char		callchain_default_opt[] = "fractal,0.5";
 
-struct symbol_conf	symbol_conf;
+static struct symbol_conf	symbol_conf;
 
 
 static size_t
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 3b212bb..296e809 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -80,7 +80,7 @@ static int			dump_symtab                     =      0;
 static bool			hide_kernel_symbols		=  false;
 static bool			hide_user_symbols		=  false;
 static struct winsize		winsize;
-struct symbol_conf		symbol_conf;
+static struct symbol_conf	symbol_conf;
 
 /*
  * Source
-- 
1.6.2.3

