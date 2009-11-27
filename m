Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZK0Saf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZK0Saf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZK0S3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:29:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:43552 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbZK0S3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:29:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 01/12] perf symbols: Avoid annoying message about loading [vdso] symbols
Date: Fri, 27 Nov 2009 16:29:12 -0200
Message-Id: <1259346563-12568-1-git-send-email-acme@infradead.org>
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

This should be properly fixed when we remove the XXX comment in 'perf
report', function resolve_symbol.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 4ed379b..8aab89b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1516,6 +1516,7 @@ static int kernel_maps__create_kernel_map(const struct symbol_conf *conf)
 	vdso = dso__new("[vdso]");
 	if (vdso == NULL)
 		goto out_delete_kernel_map;
+	vdso->loaded = 1;
 
 	if (sysfs__read_build_id("/sys/kernel/notes", kernel->build_id,
 				 sizeof(kernel->build_id)) == 0)
-- 
1.6.2.5

