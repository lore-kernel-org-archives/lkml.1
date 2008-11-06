Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYKFVVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYKFVVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYKFVVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:21:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58804 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbYKFVVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:21:01 -0500
Date: Thu, 6 Nov 2008 16:20:50 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, alan@redhat.com, jbaron@redhat.com
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081106212049.GC20928@redhat.com>
References: <1225976138.7803.4485.camel@twins> <20081106060624.58a0f967@infradead.org> <1225981141.7803.4577.camel@twins> <20081106063108.02b4813d@infradead.org> <1225983052.7803.4623.camel@twins> <20081106070157.065b2dcc@infradead.org> <alpine.DEB.1.10.0811061020311.31011@gandalf.stny.rr.com> <20081106094558.50d94bcc@infradead.org> <y0mej1ofvyz.fsf@ton.toronto.redhat.com> <20081106131348.68f8858e@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106131348.68f8858e@infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Nov 06, 2008 at 01:13:48PM -0800, Arjan van de Ven wrote:
> [...]
> fche@redhat.com (Frank Ch. Eigler) wrote:
> 
> > Arjan van de Ven <arjan@infradead.org> writes:
> > 
> > > [...]
> > > what is the real need is
> > > 1) Have a trace point in the source
> > > 2) Associate a "formatting function" with that point 
> > >    (which basically transforms the trace parameters to, say, a
> > > string) 3) A way to turn the trace point on/off.
> > 
> > For 1 and 2, it may be worth considering a plain trace_mark() in
> > do_sync().  The complication that makes this uglier than a one-liner
> 
> no why is that?
> 
> what you really need is to be able to provide a callback function
> pointer that will do the formatting, or as Peter wants it, a format string.
> [...]
> Doing this like you propose is just too complex and too specialistic;
> the reality is that merely formatting the arguments of a trace point is
> the common case, and I suspect for 99.9% of the cases we can get away
> with a standard default formatting.

I don't understand what you're arguing against.  If formatting strings
learn to deal with struct files, then the marker approach would be
even simpler, and the fsync "tracer" would consist of this single line:

   trace_mark (fsync, "process %s fsyncd file %pF\n", comm->execname, file);

Via some simple additional generic code (the generic marker->ftrace
backend), that would turn into exactly the "merely formatting the
arguments ... 99.9% of the cases" you're talking about.


- FChE
