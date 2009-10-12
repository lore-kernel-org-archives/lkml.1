Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZJLJLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZJLJLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZJLJLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:11:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60643 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbZJLJLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:11:23 -0400
Date: Mon, 12 Oct 2009 11:10:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf tools: Provide backward compatibility with
	previous perf.data version
Message-ID: <20091012091028.GB24031@elte.hu>
References: <1255032449-12022-1-git-send-email-fweisbec@gmail.com> <20091008202226.GE5073@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008202226.GE5073@nowhere>
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

> On Thu, Oct 08, 2009 at 10:07:29PM +0200, Frederic Weisbecker wrote:
> > We have merged the trace.info file into perf.data by adding one section
> > in the perf headers. This makes it incompatible with previous version:
> > the new perf tools can't read the older perf.data.
> > 
> > To support the previous format, we check the headers size. If they
> > have the same size than in the previous format, then ignore the trace
> > info section that doesn't exist.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Paul Mackerras <paulus@samba.org>
> > ---
> >  tools/perf/util/header.c |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> > index 212fade..9aae360 100644
> > --- a/tools/perf/util/header.c
> > +++ b/tools/perf/util/header.c
> > @@ -287,10 +287,16 @@ struct perf_header *perf_header__read(int fd)
> >  	do_read(fd, &f_header, sizeof(f_header));
> >  
> >  	if (f_header.magic	!= PERF_MAGIC		||
> > -	    f_header.size	!= sizeof(f_header)	||
> 
> 
> 
> Few notes about this.
> I can send a separate fix for .32 that would just consist in the above line,
> or more likely I can replace it by:
> 
> 	f_header.size < sizeof(f_header)     ||
> 
> and then we'll get a minimal forward compatibility from the older
> tools (can be Cc'ed to stable for .31).

Yep, would be nice.

> Another thing. We may feel the need to add yet another sections in the 
> future.
> 
> So just a suggestion: we could turn this trace_info section into a 
> more generic one in which we could add as much subsections as we want 
> in the future while always ensuring backward compatibility. That could 
> be managed through a versioning of this generic section.

Definitely! (Since it's not upstream yet we can do it without supporting 
the interim version.)

	Ingo
