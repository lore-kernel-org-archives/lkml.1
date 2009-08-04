Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZHDL3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZHDL3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 07:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZHDL3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 07:29:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52071 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbZHDL3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 07:29:22 -0400
Date: Tue, 4 Aug 2009 13:28:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Jens Axboe <jens.axboe@oracle.com>,
       Anton Blanchard <anton@samba.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, benh@kernel.crashing.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, paulus@samba.org, williams@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090804112859.GA26607@elte.hu>
References: <20090801011429.GA4685@kryten> <20090801082048.GX12579@kernel.dk> <20090801182216.GA25334@ghostprotocols.net> <20090802184148.GB17241@elte.hu> <20090802194454.GC28572@bombadil.infradead.org> <20090802195043.GD24486@elte.hu> <20090802201132.GE28572@bombadil.infradead.org> <20090802204701.GE25334@ghostprotocols.net> <20090803015430.GG25334@ghostprotocols.net> <20090804092540.GA29778@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804092540.GA29778@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Btw., how about the solution below? Will the libbfd system library 
version override this weak alias properly?

	Ingo

-------------->
>From 238762507bb41689df191160ada1986b012b57df Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 4 Aug 2009 13:27:41 +0200
Subject: [PATCH] perf_counter tools: Provide default bfd_demangle() function in case it's not around

Provide weak alias (which does nothing) in case the system does not
offer one.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/symbol.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b4fe057..7bd5128 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -8,6 +8,17 @@
 #include <elf.h>
 #include <bfd.h>
 
+/*
+ * Weak wrapper in case a library version is not available:
+ */
+extern char * __attribute__((weak)) bfd_demangle (bfd *, const char *, int);
+
+char * __attribute__((weak))
+ bfd_demangle (bfd *bfd __used, const char *name __used, int flags __used)
+{
+	return NULL;
+}
+
 const char *sym_hist_filter;
 
 #ifndef DMGL_PARAMS
