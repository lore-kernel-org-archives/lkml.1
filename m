Return-Path: <linux-kernel-owner+w=401wt.eu-S935526AbYBWK0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935526AbYBWK0D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:26:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYBWKZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:25:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58734 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbYBWKZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:25:51 -0500
Date: Sat, 23 Feb 2008 11:25:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: don't save unreliable stack trace entries
Message-ID: <20080223102539.GK23833@elte.hu>
References: <47BF17F5.4040605@gmail.com> <20080222104828.3006cd1d@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222104828.3006cd1d@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> > b/arch/x86/kernel/stacktrace.c index 02f0f61..c28c342 100644
> > --- a/arch/x86/kernel/stacktrace.c
> > +++ b/arch/x86/kernel/stacktrace.c
> > @@ -25,6 +25,8 @@ static int save_stack_stack(void *data, char *name)
> >   static void save_stack_address(void *data, unsigned long addr, int
> > reliable) {
> >   	struct stack_trace *trace = data;
> > +	if (!reliable)
> > +		return;
> >   	if (trace->skip > 0) {
> >   		trace->skip--;
> >   		return;
> > @@ -37,6 +39,8 @@ static void
> >   save_stack_address_nosched(void *data, unsigned long addr, int
> > reliable) {
> >   	struct stack_trace *trace = (struct stack_trace *)data;
> > +	if (!reliable)
> > +		return;
> >   	if (in_sched_functions(addr))
> >   		return;
> >   	if (trace->skip > 0) {
> 
> 
> I was about to make a patch for this second chunk myself and submit 
> it, so for the second chunk a strong:
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>

how about the first chunk?

	Ingo
