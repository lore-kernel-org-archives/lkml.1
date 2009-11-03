Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZKCRwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZKCRwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZKCRwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:52:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41006 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZKCRwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:52:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 1/1] perf symbols: Initialize dso->loaded
Date: Tue,  3 Nov 2009 15:52:18 -0200
Message-Id: <1257270738-5669-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Brown paper bag bug introduced in:

66bd8424cc05e800db384053bf7ab967e4658468

Without this we were not loading any symtabs that happened to be on a
DSO for which the allocated memory for ->loaded was !0.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ec99d79..ac94d7b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -121,6 +121,7 @@ struct dso *dso__new(const char *name)
 		self->find_symbol = dso__find_symbol;
 		self->slen_calculated = 0;
 		self->origin = DSO__ORIG_NOT_FOUND;
+		self->loaded = false;
 	}
 
 	return self;
-- 
1.6.2.5

