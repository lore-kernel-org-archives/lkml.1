Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbZCHKKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbZCHKKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZCHKKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:10:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48848 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZCHKKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:10:09 -0400
Date: Sun, 8 Mar 2009 11:09:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces - v2
Message-ID: <20090308100929.GA14133@elte.hu>
References: <20090307045120.039324630@linux.vnet.ibm.com> <20090307050747.GL23959@in.ibm.com> <20090307222955.25A7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090307222955.25A7.A69D9226@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
> 
> > This patch adds an ftrace plugin to detect and profile memory access over
> > kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> > addresses.
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> > ---
> >  kernel/trace/Kconfig          |    6 
> >  kernel/trace/Makefile         |    1 
> >  kernel/trace/trace.h          |   16 +
> >  kernel/trace/trace_ksym.c     |  448 ++++++++++++++++++++++++++++++++++++++++++
> >  kernel/trace/trace_selftest.c |   36 +++
> >  5 files changed, 507 insertions(+)
> 
> Could you please update Documentation/ftrace.txt?
> I guess many user interesting this patch. :)

Yeah, it has become a really nice feature this way. As i told it 
to K.Prasad before: we need this tracer because the data tracer 
will likely become the most common usecase of this facility. We 
will get the hw breakpoints facility tested and used.

And in fact we can go one step further: it would also be nice to 
wire it up with the ftrace histogram code: so that we can get 
usage histograms of kernel symbol read/write activities without 
the overhead of tracing. (The branch tracer already has this.)

Especially frequently used variables generate a _lot_ of events.

	Ingo
