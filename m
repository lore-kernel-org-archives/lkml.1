Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbZFAUvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbZFAUvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758867AbZFAUvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:51:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58768 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758853AbZFAUvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:51:19 -0400
Date: Mon, 1 Jun 2009 17:50:57 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 2/2] perf_counter tools: Add missing rb_erase in
	dso__delete_symbols
Message-ID: <20090601205057.GB7805@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Documentation/perf_counter/util/symbol.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/util/symbol.c b/Documentation/perf_counter/util/symbol.c
index 31e8fae..039931f 100644
--- a/Documentation/perf_counter/util/symbol.c
+++ b/Documentation/perf_counter/util/symbol.c
@@ -58,6 +58,7 @@ static void dso__delete_symbols(struct dso *self)
 	while (next) {
 		pos = rb_entry(next, struct symbol, rb_node);
 		next = rb_next(&pos->rb_node);
+		rb_erase(&pos->rb_node, &self->syms);
 		symbol__delete(pos, self->sym_priv_size);
 	}
 }
-- 
1.6.0.6

