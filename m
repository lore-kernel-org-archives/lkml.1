Return-Path: <linux-kernel-owner+w=401wt.eu-S1751718AbZIXVYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbZIXVYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZIXVYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:24:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbZIXVYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:24:14 -0400
Date: Thu, 24 Sep 2009 14:24:00 -0700
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] perf top: Remove dead {min,max}_ip unused variables
Message-ID: <20090924212400.GA15321@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4002ccb..a92e82b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -96,9 +96,6 @@ static int			display_weighted		= -1;
  * Symbols
  */
 
-static u64			min_ip;
-static u64			max_ip = -1ll;
-
 struct sym_entry {
 	struct rb_node		rb_node;
 	struct list_head	node;
@@ -826,8 +823,6 @@ static int symbol_filter(struct dso *self, struct symbol *sym)
 
 static int parse_symbols(void)
 {
-	struct rb_node *node;
-	struct symbol  *sym;
 	int use_modules = vmlinux_name ? 1 : 0;
 
 	kernel_dso = dso__new("[kernel]", sizeof(struct sym_entry));
@@ -837,14 +832,6 @@ static int parse_symbols(void)
 	if (dso__load_kernel(kernel_dso, vmlinux_name, symbol_filter, verbose, use_modules) <= 0)
 		goto out_delete_dso;
 
-	node = rb_first(&kernel_dso->syms);
-	sym = rb_entry(node, struct symbol, rb_node);
-	min_ip = sym->start;
-
-	node = rb_last(&kernel_dso->syms);
-	sym = rb_entry(node, struct symbol, rb_node);
-	max_ip = sym->end;
-
 	if (dump_symtab)
 		dso__fprintf(kernel_dso, stderr);
 
-- 
1.6.2.5


