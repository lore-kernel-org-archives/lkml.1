Return-Path: <linux-kernel-owner+w=401wt.eu-S1764680AbXK3Srl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764680AbXK3Srl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761716AbXK3Srb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:47:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43837 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763647AbXK3Sra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:47:30 -0500
Date: Fri, 30 Nov 2007 19:46:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Mark Lord <lkml@rtr.ca>, Pavel Machek <pavel@ucw.cz>,
       Mark Lord <liml@rtr.ca>, Thomas Gleixner <tglx@linutronix.de>,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071130184625.GB9928@elte.hu>
References: <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca> <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca> <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <20071130125628.GA30773@lazybastard.org> <20071130133546.GB29679@elte.hu> <20071130134312.GA32273@elte.hu> <20071130183510.GA1570@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071130183510.GA1570@lazybastard.org>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Jörn Engel <joern@logfs.org> wrote:

> On Fri, 30 November 2007 14:43:12 +0100, Ingo Molnar wrote:
> > 
> >   http://redhat.com/~mingo/latency-tracing-patches/latency-tracing-v2.6.24-rc3.combo.patch
> > 
> > does it work any better?
> 
> It compiles.  It boots with a 512M RAM (384M was too little with all
> the other debug options on).  But it seems to lock up when running
> trace-cmd.  On a rerun it locks up again, but with different output.

hm, you should decrease MAX_TRACE in kernel/latency_tracing.c from 1 
million to 16K or so. 1 million entries probably depletes lowmem quite 
seriously.

> Rerun was captured:
> http://logfs.org/~joern/trace1.jpg

hm, that looks weird. if you disable CONFIG_PROVE_LOCKING, does that 
improve things? (or just turns a noisy lockup into a silent lockup?)

> I should do a couple of runs, but my girlfriend claims realtime 
> priority for the evening.

yeah, SCHED_IDLE is not generally well received by them.

	Ingo
