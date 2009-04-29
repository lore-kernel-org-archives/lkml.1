Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZD2Uff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZD2Uff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbZD2UfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:35:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56929 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbZD2UfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:35:25 -0400
Date: Wed, 29 Apr 2009 22:34:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rostedt@goodmis.org, fweisbec@gmail.com,
       mathieu.desnoyers@polymtl.ca, wcohen@redhat.com
Subject: Re: [PATCH 1/3] make kernel-doc understand TRACE_EVENT() macro
Message-ID: <20090429203439.GD21421@elte.hu>
References: <200904291745.n3THjPhO019531@ns3.rdu.redhat.com> <49F8A7D1.6010307@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F8A7D1.6010307@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Jason Baron wrote:
> > Add support to kernel-doc for tracepoint comments above TRACE_EVENT()
> > macro definitions. Paves the way for tracepoint docbook.
> > 
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > ---
> >  scripts/kernel-doc |   21 +++++++++++++++++++++
> >  1 files changed, 21 insertions(+), 0 deletions(-)
> > 
> > diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> > index 0f11870..9d9ab4b 100755
> > --- a/scripts/kernel-doc
> > +++ b/scripts/kernel-doc
> > @@ -1827,6 +1827,24 @@ sub reset_state {
> >      $state = 0;
> >  }
> >  
> > +sub tracepoint_munge() {
> > +	my $tracepointname = 0;
> > +	my $tracepointargs = 0;
> > +
> > +	if($prototype =~ m/TRACE_EVENT\((.*?),/) {
> > +		$tracepointname = $1;
> > +	}
> > +	if($prototype =~ m/TP_PROTO\((.*?)\)/) {
> > +		$tracepointargs = $1;
> > +	}
> > +	if (($tracepointname eq 0) || ($tracepointargs eq 0)) {
> > +		print STDERR "Warning: Unrecognized tracepoint format: \n" .
> > +			     "$prototype\n"
> 
> I'd prefer for this warning to use the usual kernel-doc warning format, with
> file:line information:
> 
> 		print STDERR "Warning(${file}:$.): Unrecognized ....

Good point - i'll wait for v2. Or would you like to carry them in 
your kernel-doc tree?

This bit:

 include/trace/events/irq.h            |   46 ++++++++++++++++++++++++++++++---

Has changed in the tracing tree so it's probably better to carry it 
there - once your review feedback has been addressed and once your 
Acked-by is propagated into the patches.

Thanks,

	Ingo
