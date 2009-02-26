Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbZBZPgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbZBZPgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 10:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZBZPg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 10:36:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37020 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbZBZPg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 10:36:26 -0500
Date: Thu, 26 Feb 2009 16:35:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090226153559.GC352@elte.hu>
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com> <20090222123543.359C.A69D9226@jp.fujitsu.com> <49A5765C.2020001@redhat.com> <20090225165747.GC3123@redhat.com> <20090225173412.GA14269@Krystal> <20090226151105.GA3122@redhat.com> <alpine.DEB.2.00.0902261031460.26792@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902261031460.26792@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 26 Feb 2009, Jason Baron wrote:
> > 
> > maybe...although that would require re-arranging the 'while' loop in
> > 'handle_IRQ_event' from a do..while loop to a 'while' loop, which will
> > require an extra branch check, and then we still have to record the last 'ret'
> > value. I'm not that keen on re-arranging this for trace data...
> > 
> > Using Steve's new 'DEFINE_TRACE_FMT', I can get function graph trace
> > as follows using the original two tracepoints (patch below):
> > 
> >  3)               |                      handle_IRQ_event() {
> >  3)               |                        /* (irq_handler_entry) irq=28 handler=eth0 */
> >  3)               |                        e1000_intr_msi() {
> >  3)   2.460 us    |                          __napi_schedule();
> >  3)   9.416 us    |                        }
> >  3)               |                        /* (irq_handler_exit) irq=28 handler=eth0 return=handled */
> >  3) + 22.935 us   |                      }
> > 
> > thanks,
> > 
> > -Jason
> 
> Looks good, one minor note:

[...]
> > +DEFINE_TRACE_FMT(irq_handler_entry,
> 
> I've renamed DEFINE_TRACE_FMT to TRACE_FORMAT. I believe that 
> is already in Ingo's tree.
> 
> Other than that:
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>

i've changed that in the patch and have applied Jason's patch to 
tip:tracing/ftrace. Thanks guys!

	Ingo
