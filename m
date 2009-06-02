Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbZFBBrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbZFBBrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 21:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbZFBBrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 21:47:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:56303 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757976AbZFBBrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 21:47:10 -0400
Date: Tue, 2 Jun 2009 01:46:00 GMT
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
Message-ID: <tip-c8c96525f3c25f43a4fa230e293c4976c0c36cc1@git.kernel.org>
Git-Commit-ID: c8c96525f3c25f43a4fa230e293c4976c0c36cc1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 01:46:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8c96525f3c25f43a4fa230e293c4976c0c36cc1
Gitweb:     http://git.kernel.org/tip/c8c96525f3c25f43a4fa230e293c4976c0c36cc1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Jun 2009 17:50:57 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 03:40:58 +0200

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
