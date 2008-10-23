Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbYJWQze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbYJWQze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYJWQzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:55:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48076 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbYJWQzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:55:24 -0400
Date: Thu, 23 Oct 2008 18:55:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: fix a build error on alpha and m68k
Message-ID: <20081023165504.GB25697@elte.hu>
References: <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com> <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com> <49008D12.5090204@gmail.com> <Pine.LNX.4.64.0810231635440.18978@anakin> <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com> <Pine.LNX.4.64.0810231727430.18978@anakin> <4900B414.7090002@gmail.com> <20081023163433.GA3160@x200.localdomain> <20081023163850.GB16591@elte.hu> <c62985530810230951u7ae640d5ya45bed466f030074@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810230951u7ae640d5ya45bed466f030074@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> But they should be able to use the tracing for several other tracers. 
> One other problem is that you need CONFIG_TRACE_IRQFLAGS (is that a 
> lockdep or just trace feature?) to use any tracer since the 
> tracing_cpumask file is always created for all tracer. This file has 
> tracing_cpumask_write() as a write operation, and this func uses 
> raw_local_funcs....
> 
> Perhaps we should disable the tracing_cpu_mask related things if 
> TRACE_IRQFLAGS in not configured?

to answer the "is that a lockdep or just trace feature" question:

trace-irqflags was first written by me for the (crude) ftrace-precursor 
latency tracer code in -rt, years ago. Then i reused it (and changed it 
alot) for upstream lockdep, two years ago. Then ftrace came in this year 
and reused it.

so it's rather symbiotic ;-)

So ... the tracers that rely on irqflags-tracing should definitely be 
limited to architectures that provide TRACE_IRQFLAGS. The core trace.c 
itself should probably not be restricted ... (and it should definitely 
build)

	Ingo
