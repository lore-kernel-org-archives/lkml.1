Return-Path: <linux-kernel-owner+w=401wt.eu-S1761949AbZDQQXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761949AbZDQQXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbZDQQXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:23:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60567 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761311AbZDQQXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:23:42 -0400
Date: Fri, 17 Apr 2009 18:23:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/4] tracing: move __DO_TRACE out of line
Message-ID: <20090417162326.GG8253@elte.hu>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-2-git-send-email-jeremy@goop.org> <20090417154640.GB8253@elte.hu> <20090417161005.GA16361@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417161005.GA16361@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > > +#define DEFINE_DO_TRACE(name, proto, args)				\
> > > +	void __do_trace_##name(struct tracepoint *tp, TP_PROTO(proto))	\
> > > +	{								\
> > 
> > that needs to be marked notrace, otherwise the function tracer 
> > becomes noisy. (or even lockupy.)
> 
> I guess I'll have to put it more clearly : I am all for minimizing 
> tracepoint header dependency, but I'll be nacking this kind of 
> out-of-lining patch. Taking a function call, and moving it 
> out-of-line (thus duplicating the function call for nothing) seems 
> *really* pointless and will hurt tracer performance.

No need to nak - just say you dont like it and it gets fixed :)

I meant to suggest to Jeremy to measure the effect of this 
out-of-lining, in terms of instruction count in the hotpath.

> If thread_info.h is now so big that it needs a cleanup, I guess 
> we'll just have to do it.

Music to my ears ...

	Ingo
