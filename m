Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZJTNTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZJTNTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 09:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZJTNTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 09:19:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbZJTNTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 09:19:42 -0400
Subject: Re: [PATCH] perf tools: Shut up compiler warning
From: Steven Rostedt <srostedt@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20091020055439.GA29531@elte.hu>
References: <y> <1255971369-11368-1-git-send-email-acme@redhat.com>
	 <20091020055439.GA29531@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 20 Oct 2009 09:19:19 -0400
Message-Id: <1256044759.2669.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-20 at 07:54 +0200, Ingo Molnar wrote:
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> 
> > cc1: warnings being treated as errors
> > util/trace-event-parse.c: In function ‘parse_ftrace_printk’:
> > util/trace-event-parse.c:289: warning: ‘fmt’ may be used uninitialized in this function
> > 
> > Cc: Steven Rostedt <srostedt@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > ---
> >  tools/perf/util/trace-event-parse.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> > index 4b61b49..0b8a01b 100644
> > --- a/tools/perf/util/trace-event-parse.c
> > +++ b/tools/perf/util/trace-event-parse.c
> > @@ -286,7 +286,7 @@ void parse_ftrace_printk(char *file, unsigned int size __unused)
> >  	char *line;
> >  	char *next = NULL;
> >  	char *addr_str;
> > -	char *fmt;
> > +	char *fmt = NULL;
> >  	int i;
> >  
> >  	line = strtok_r(file, "\n", &next);
> 
> Actually, this might be a real bug that GCC pointed out: what makes sure 
> that strtok_r() does not return a NULL (no more tokens) and hence fmt 
> remains NULL (crashing the rest of the parser)?

Ug, yeah that's a bug. That was one of the later changes I did at night.
I'll go look at it and see how it should really be.

Thanks,

-- Steve


