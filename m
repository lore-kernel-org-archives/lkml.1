Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbZCUQS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbZCUQS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZCUQSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:18:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50569 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbZCUQSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:18:46 -0400
Date: Sat, 21 Mar 2009 17:18:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: Fix TRACING_SUPPORT dependency
Message-ID: <20090321161814.GC11183@elte.hu>
References: <20090320150914.GA22769@oksana.dev.rtsoft.ru> <20090320190428.GD6224@elte.hu> <20090320193904.GA13707@oksana.dev.rtsoft.ru> <20090320195743.GA25147@elte.hu> <20090320202247.GA30654@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320202247.GA30654@oksana.dev.rtsoft.ru>
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


* Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> On Fri, Mar 20, 2009 at 08:57:43PM +0100, Ingo Molnar wrote:
> > 
> > * Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> > 
> > > On Fri, Mar 20, 2009 at 08:04:28PM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> > > > 
> > > > > commit 40ada30f9621fbd831ac2437b9a2a399aad34b00 ("tracing: clean 
> > > > > up menu"), despite the "clean up" in its purpose, introduced 
> > > > > behavioural change for Kconfig symbols: we no longer able to 
> > > > > select tracing support on PPC32 (because IRQFLAGS_SUPPORT isn't 
> > > > > yet implemented).
> > > > 
> > > > Could you please solve this by implementing proper 
> > > > irqflag-tracing support? It's been available upstream for almost 
> > > > three years. It's needed for lockdep support as well, etc.
> > > 
> > > Breaking things via clean up patches is an interesting method of 
> > > encouraging something to implement. ;-)
> > >
> > > Surely I'll look into implementing irqflags tracing, but 
> > > considering that no one ever needed this for almost three years, 
> > > [...]
> > 
> > Weird, there's no lockdep support?
> 
> *ashamed*: apparently no such support currently exist for PPC32. ;-)

Hm, do all the tracers even compile on ppc32 with your patch?

We had periodic build failures on weird, unmaintained architectures 
that had no irqflags-tracing support and hence didnt know the 
raw_irqs_save/restore primitives ...

I'm not trying to make things more difficult for you (and we can 
apply your patch if it builds fine and does not cause problems 
elsewhere), but there were some real downsides to not having proper 
irq APIs ...

	Ingo
