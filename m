Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbZA3PNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbZA3PNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbZA3PN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:13:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43662 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbZA3PN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:13:28 -0500
Date: Fri, 30 Jan 2009 16:12:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next/mmotm/resend] kmemtrace: fix printk formats
Message-ID: <20090130151251.GC27549@elte.hu>
References: <200901291030.n0TAUhRI003046@imap1.linux-foundation.org> <4981E86F.60909@oracle.com> <Pine.LNX.4.64.0901292234520.17617@anakin> <49822479.9030908@oracle.com> <20090130074645.GA5218@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130074645.GA5218@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> On Thu, Jan 29, 2009 at 01:49:45PM -0800, Randy Dunlap wrote:
> > Geert Uytterhoeven wrote:
> > > 
> > > %4zu?
> > 
> > Ugh, yes.  Thanks.
> > Here's the updated patch.
> > 
> > -- 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix kmemtrace printk warnings:
> > 
> > kernel/trace/kmemtrace.c:142: warning: format '%4ld' expects type 'long int', but argument 3 has type 'size_t'
> > kernel/trace/kmemtrace.c:147: warning: format '%4ld' expects type 'long int', but argument 3 has type 'size_t'
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > cc:      Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> > ---
> >  kernel/trace/kmemtrace.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > --- linux-next-20090123.orig/kernel/trace/kmemtrace.c
> > +++ linux-next-20090123/kernel/trace/kmemtrace.c
> > @@ -139,12 +139,12 @@ kmemtrace_print_alloc_compress(struct tr
> >  		return TRACE_TYPE_PARTIAL_LINE;
> >  
> >  	/* Requested */
> > -	ret = trace_seq_printf(s, "%4ld   ", entry->bytes_req);
> > +	ret = trace_seq_printf(s, "%4zu   ", entry->bytes_req);
> >  	if (!ret)
> >  		return TRACE_TYPE_PARTIAL_LINE;
> >  
> >  	/* Allocated */
> > -	ret = trace_seq_printf(s, "%4ld   ", entry->bytes_alloc);
> > +	ret = trace_seq_printf(s, "%4zu   ", entry->bytes_alloc);
> >  	if (!ret)
> >  		return TRACE_TYPE_PARTIAL_LINE;
> >
> 
> I didn't notice this either, thanks.
> 
> Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Applied to tip/tracing/kmemtrace, thanks!

	Ingo
