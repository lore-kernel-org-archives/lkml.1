Return-Path: <linux-kernel-owner+w=401wt.eu-S932440AbZHLKJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbZHLKJC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:09:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932416AbZHLKJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:09:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33416 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400AbZHLKJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:09:00 -0400
Date: Wed, 12 Aug 2009 12:08:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [PATCH 1/3] perf tools: Factorize high level dso helpers
Message-ID: <20090812100851.GA18577@elte.hu>
References: <1250069162-13099-1-git-send-email-fweisbec@gmail.com> <1250069162-13099-2-git-send-email-fweisbec@gmail.com> <20090812095933.GB6081@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812095933.GB6081@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Aug 12, 2009 at 11:26:00AM +0200, Frederic Weisbecker wrote:
> > Factorize multiple definitions of high level dso helpers into the
> > symbol source file.
> > 
> > The side effect is a general export of the verbose and eprintf
> > debugging helpers into a new file dedicated to debugging purposes.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Brice Goglin <Brice.Goglin@inria.fr>
> > ---
> >  tools/perf/Makefile           |    1 +
> >  tools/perf/builtin-annotate.c |   96 ----------------------------------------
> >  tools/perf/builtin-record.c   |    1 -
> >  tools/perf/builtin-report.c   |   97 -----------------------------------------
> >  tools/perf/builtin-stat.c     |    1 -
> >  tools/perf/builtin-top.c      |    4 --
> >  tools/perf/builtin.h          |    1 +
> >  tools/perf/perf.h             |    1 +
> >  tools/perf/util/symbol.c      |   97 +++++++++++++++++++++++++++++++++++++++++
> >  tools/perf/util/symbol.h      |   11 +++++
> >  10 files changed, 111 insertions(+), 199 deletions(-)
> > 
> > diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> > index de7beac..2aee21b 100644
> > --- a/tools/perf/Makefile
> > +++ b/tools/perf/Makefile
> > @@ -339,6 +339,7 @@ LIB_OBJS += util/pager.o
> >  LIB_OBJS += util/header.o
> >  LIB_OBJS += util/callchain.o
> >  LIB_OBJS += util/values.o
> > +LIB_OBJS += util/debug.o
> 
> 
> Damn, did I forgot to git-add util/debug.c ?
> 
> How could I fix this? Another pull request?

yeah. I've zapped those commits from perfcounters/core.

	Ingo
