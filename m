Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZFAXBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZFAXBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 19:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZFAXBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 19:01:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:44358 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbZFAXBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 19:01:22 -0400
Date: Mon, 1 Jun 2009 23:00:47 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090601205057.GB7805@ghostprotocols.net>
References: <20090601205057.GB7805@ghostprotocols.net>
Subject: [tip:perfcounters/core] perf_counter tools: Add missing rb_erase in dso__delete_symbols
Message-ID: <tip-3ddcb2a015b55daa8aa3c24d0203865669ebaef8@git.kernel.org>
Git-Commit-ID: 3ddcb2a015b55daa8aa3c24d0203865669ebaef8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 23:00:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ddcb2a015b55daa8aa3c24d0203865669ebaef8
Gitweb:     http://git.kernel.org/tip/3ddcb2a015b55daa8aa3c24d0203865669ebaef8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Jun 2009 17:50:57 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 00:57:14 +0200

perf_counter tools: Add missing rb_erase in dso__delete_symbols

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090601205057.GB7805@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
