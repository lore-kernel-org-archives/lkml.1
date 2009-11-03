Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbZKCR67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbZKCR67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZKCR66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:58:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:47244 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbZKCR66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:58:58 -0500
Date: Tue, 3 Nov 2009 17:57:50 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257270738-5669-1-git-send-email-acme@infradead.org>
References: <1257270738-5669-1-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Initialize dso->loaded
Message-ID: <tip-6d7aa9d721c8c640066142fd9534afcdf68d7f9d@git.kernel.org>
Git-Commit-ID: 6d7aa9d721c8c640066142fd9534afcdf68d7f9d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d7aa9d721c8c640066142fd9534afcdf68d7f9d
Gitweb:     http://git.kernel.org/tip/6d7aa9d721c8c640066142fd9534afcdf68d7f9d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 3 Nov 2009 15:52:18 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 3 Nov 2009 18:56:06 +0100

perf symbols: Initialize dso->loaded

Brown paper bag bug introduced in:

 66bd8424cc05e800db384053bf7ab967e4658468 ("perf tools: Delay
 loading symtabs till we hit a map with it")

Without this we were not loading any symtabs that happened to be
on a DSO for which the allocated memory for ->loaded was !0.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1257270738-5669-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/symbol.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index cf2c7f7..93c49f4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -121,6 +121,7 @@ struct dso *dso__new(const char *name)
 		self->find_symbol = dso__find_symbol;
 		self->slen_calculated = 0;
 		self->origin = DSO__ORIG_NOT_FOUND;
+		self->loaded = false;
 	}
 
 	return self;
