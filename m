Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZLRSeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZLRSeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZLRSeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:34:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:41454 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZLRSeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:34:10 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf diff: Fix usage array, it must end with a NULL entry
Date: Fri, 18 Dec 2009 16:33:56 -0200
Message-Id: <1261161236-23858-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Fixing this:

[acme@doppio linux-2.6-tip]$ perf diff --hell
  Error: unknown option `hell'

 usage: perf diff [<options>] [old_file] [new_file]
Segmentation fault
[acme@doppio linux-2.6-tip]$

Also go over the other such arrays to check if they all were OK, they
are, but there were some minor changes to do like making one static and
renaming another to match the command it refers to.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 4d33b55..5cc5dcd 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -191,6 +191,7 @@ out_delete:
 
 static const char *const diff_usage[] = {
 	"perf diff [<options>] [old_file] [new_file]",
+	NULL,
 };
 
 static const struct option options[] = {
-- 
1.6.2.5

