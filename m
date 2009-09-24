Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZIXPGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZIXPGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbZIXPGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:06:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:45663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbZIXPGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:06:34 -0400
Subject: Re: [patch 12/12] Tracepoints - Immediate Values
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <20090924150333.GA26389@Krystal>
References: <20090924132626.485545323@polymtl.ca>
	 <20090924133400.830759403@polymtl.ca> <1253803872.18939.28.camel@laptop>
	 <20090924150333.GA26389@Krystal>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 17:06:19 +0200
Message-Id: <1253804779.18939.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 11:03 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Thu, 2009-09-24 at 09:26 -0400, Mathieu Desnoyers wrote:
> > > plain text document attachment (tracepoints-immediate-values.patch)
> > > Use immediate values in tracepoints.
> > 
> > I might have missed it, but did both the Intel and AMD cpu folks clear
> > the SMP code rewrite bits?
> > 
> 
> SMP handling is performed with stop_machine() in this patchset. Nothing
> fancy here.
> 
> I've got other patches, not included in this patchset, which implements
> nmi-safe code modification, based on a scheme using breakpoints and
> IPIs, inspired from djprobes. That one might be worth clearing with
> intel/amd devs before merging.
> 
> However, doing code patching within stop_machine() is pretty safe, given
> all other CPUs are busy-looping with interrupts off while this happens.
> Ftrace already does this.

Agreed, I missed this relied on stopmachine. No problem then.

It would be good to reduce reliance on stopmachine, so it would be good
to get some CPU folks looking at your alternative implementation.

Thanks!

