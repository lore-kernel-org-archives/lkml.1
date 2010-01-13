Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185Ab0AMJLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0AMJLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939Ab0AMJLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:11:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46442 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab0AMJLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:11:51 -0500
Date: Wed, 13 Jan 2010 10:11:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 5/6] perf tools: Use rb_for_each_entry
Message-ID: <20100113091135.GE24475@elte.hu>
References: <1262901583-8074-1-git-send-email-acme@infradead.org>
 <1262901583-8074-5-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262901583-8074-5-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Cc: Fr??d??ric Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-annotate.c |   19 ++++++-------------
>  tools/perf/builtin-diff.c     |    5 ++---
>  tools/perf/builtin-kmem.c     |   12 +++++-------
>  tools/perf/builtin-sched.c    |   10 ++--------
>  tools/perf/builtin-top.c      |   10 +++-------
>  tools/perf/util/symbol.c      |   16 ++++++----------
>  6 files changed, 24 insertions(+), 48 deletions(-)

hm, this one doesnt build very well:

touch .perf.dev.null
    CC builtin-annotate.o
    CC builtin-diff.o
    CC builtin-sched.o
    CC builtin-top.o
    CC builtin-kmem.o
    CC util/symbol.o
cc1: warnings being treated as errors
builtin-diff.c: In function 'perf_session__match_hists':
builtin-diff.c:148: error: implicit declaration of function 'rb_for_each_entry'
builtin-diff.c:148: error: nested extern declaration of 'rb_for_each_entry'
builtin-diff.c:148: error: 'rb_node' undeclared (first use in this function)
builtin-diff.c:148: error: (Each undeclared identifier is reported only once
builtin-diff.c:148: error: for each function it appears in.)
builtin-diff.c:149: error: expected ';' before 'pos'
builtin-diff.c:142: error: unused parameter 'old_session'
make: *** [builtin-diff.o] Error 1
make: *** Waiting for unfinished jobs....
cc1: warnings being treated as errors
builtin-annotate.c: In function 'print_summary':
builtin-annotate.c:352: error: implicit declaration of function 'rb_for_each_entry'
builtin-annotate.c:352: error: nested extern declaration of 'rb_for_each_entry'
builtin-annotate.c:352: error: expected ';' before '{' token
builtin-annotate.c: In function 'perf_session__find_annotations':
builtin-annotate.c:426: error: 'rb_node' undeclared (first use in this function)
builtin-annotate.c:426: error: (Each undeclared identifier is reported only once
builtin-annotate.c:426: error: for each function it appears in.)
builtin-annotate.c:426: error: expected ';' before '{' token
make: *** [builtin-annotate.o] Error 1
cc1: warnings being treated as errors
builtin-top.c: In function 'print_sym_table':
builtin-top.c:535: error: implicit declaration of function 'rb_for_each_entry'
builtin-top.c:535: error: nested extern declaration of 'rb_for_each_entry'
builtin-top.c:535: error: 'rb_node' undeclared (first use in this function)
builtin-top.c:535: error: (Each undeclared identifier is reported only once
builtin-top.c:535: error: for each function it appears in.)
builtin-top.c:535: error: expected ';' before '{' token
builtin-top.c:569: error: expected ';' before '{' token
builtin-top.c:446: error: unused variable 'printed'
cc1: warnings being treated as errors
builtin-kmem.c: In function '__print_result':
builtin-kmem.c:364: error: implicit declaration of function 'rb_for_each_entry'
builtin-kmem.c:364: error: nested extern declaration of 'rb_for_each_entry'
builtin-kmem.c:364: error: 'node' undeclared (first use in this function)
builtin-kmem.c:364: error: (Each undeclared identifier is reported only once
builtin-kmem.c:364: error: for each function it appears in.)
builtin-kmem.c:364: error: expected ';' before '{' token
builtin-kmem.c:353: error: unused parameter 'session'
builtin-kmem.c:354: error: unused parameter 'n_lines'
make: *** [builtin-kmem.o] Error 1
make: *** [builtin-top.o] Error 1
cc1: warnings being treated as errors
builtin-sched.c: In function '__cmd_lat':
builtin-sched.c:1719: error: implicit declaration of function 'rb_for_each_entry'
builtin-sched.c:1719: error: nested extern declaration of 'rb_for_each_entry'
builtin-sched.c:1719: error: 'node' undeclared (first use in this function)
builtin-sched.c:1719: error: (Each undeclared identifier is reported only once
builtin-sched.c:1719: error: for each function it appears in.)
builtin-sched.c:1720: error: expected ';' before 'output_lat_thread'
make: *** [builtin-sched.o] Error 1
cc1: warnings being treated as errors
util/symbol.c: In function 'symbols__sort_by_name':
util/symbol.c:297: error: implicit declaration of function 'rb_for_each_entry'
util/symbol.c:297: error: nested extern declaration of 'rb_for_each_entry'
util/symbol.c:297: error: 'rb_node' undeclared (first use in this function)
util/symbol.c:297: error: (Each undeclared identifier is reported only once
util/symbol.c:297: error: for each function it appears in.)
util/symbol.c:298: error: expected ';' before 'symbols__insert_by_name'
util/symbol.c:292: error: unused parameter 'self'
util/symbol.c: In function 'dso__fprintf':
util/symbol.c:378: error: 'rb_node' undeclared (first use in this function)
util/symbol.c:379: error: expected ';' before 'ret'
util/symbol.c: In function 'map_groups__find_by_name':
util/symbol.c:1342: error: 'rb_node' undeclared (first use in this function)
util/symbol.c:1343: error: expected ';' before 'if'
util/symbol.c:1337: error: unused parameter 'name'
make: *** [util/symbol.o] Error 1
rm .perf.dev.null

	Ingo
