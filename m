Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbZAFPuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbZAFPuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZAFPtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:49:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42250 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZAFPtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:49:51 -0500
Date: Tue, 6 Jan 2009 10:49:49 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Roel Kluin <roel.kluin@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Liming Wang <liming.wang@windriver.com>
Subject: Re: [PATCH] ftrace: unsigned idx cannot be less than 0
In-Reply-To: <20090102154805.GA6833@nowhere>
Message-ID: <alpine.DEB.1.10.0901061048260.10871@gandalf.stny.rr.com>
References: <495E2987.3070501@gmail.com> <20090102154805.GA6833@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added Liming to CC ]

On Fri, 2 Jan 2009, Frederic Weisbecker wrote:

> On Fri, Jan 02, 2009 at 03:49:43PM +0100, Roel Kluin wrote:
> > // vi kernel/trace/ftrace.c +787
> > struct ftrace_iterator {
> > ...
> >         unsigned                idx;
> > ...
> > };
> > 
> > idx is unsigned and cannot be less than 0.
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > ---
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 2f32969..a344add 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -842,7 +842,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
> >  	void *p = NULL;
> >  
> >  	if (*pos > 0) {
> > -		if (iter->idx < 0)
> > +		if (iter->idx == 0)
> >  			return p;
> >  		(*pos)--;
> >  		iter->idx--;
> 
> 
> Hi Roel,
> 
> I'm not sure this is the right fix.
> If you look at t_next, if there is no more page to look at,
> iter_idx takes -1.
> 
> A 0 value would mean: we are in the first index on the page, which means
> there is something to read and we don't want to return NULL.
> 
> I guess that would be better to turn idx into a signed int.

Correct. This bug was added by:

  50cdaf08a8ec1d7f43987705da7aff7cf949708f
  ftrace: improve seq_operation of ftrace

So the correct fix is to turn it into a signed int.

Thanks,

-- Steve
