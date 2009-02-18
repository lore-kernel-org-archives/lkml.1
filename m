Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZBRQLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZBRQLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZBRQKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:10:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42485 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbZBRQKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:10:51 -0500
Date: Wed, 18 Feb 2009 17:10:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] tracing/function-graph-tracer: provide
	documentation for the function graph tracer
Message-ID: <20090218161041.GA29863@elte.hu>
References: <499ba227.077e420a.56d6.ffffc38b@mx.google.com> <20090218140150.GA31620@elte.hu> <20090218155827.GA5765@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218155827.GA5765@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Feb 18, 2009 at 03:01:50PM +0100, Ingo Molnar wrote:
> > 
> > btw., a minor trace-output observation. We currently have this 
> > default output:
> > 
> > # tracer: function_graph
> > #
> > # CPU  DURATION                  FUNCTION CALLS
> > # |     |   |                     |   |   |   |
> > 
> >  0)               |  sys_open() {
> >  0)               |    do_sys_open() {
> >  0)               |      getname() {
> >  0)               |        kmem_cache_alloc() {
> >  0)   1.382 us    |          __might_sleep();
> >  0)   2.478 us    |        }
> > 
> > Wouldnt this tweaked version look even nicer:
> > 
> > #
> > # [ tracer: function_graph ]
> > #
> >  CPU)  <duration>   |  <function-name>
> >  ..............................................
> >    0)               |  sys_open() {
> >    0)               |    do_sys_open() {
> >    0)               |      getname() {
> >    0)               |        kmem_cache_alloc() {
> >    0)   1.382 us    |          __might_sleep();
> >    0)   2.478 us    |        }
> > 
> > 
> > Changes:
> > 
> >  1) Added an empty '#' line to the head. Looks nicer because 
> >     the comment is now symmetric.
> 
> Right.
>  
> >  2) Shifted of the CPU field two positions to the left. Better 
> >     for paste-ability and makes the 'CPU)' header fit as well.
> 
> 
> Good.
> 
> 
> >  3) Changed the field description in the header portion to a 
> >     standard <field> notation.
> 
> 
> I guess it's more a matter of taste here.
> I like the uppercase titles because they draw a good separation between
> titles and traces.

hm, to me they look a bit sloppy. It's hard to align them to the 
colums so they look detached - despite the '| | |' vertical 
lines. Unless you find the <field> notation outright ugly, could 
we try that and see how it goes?

	Ingo
