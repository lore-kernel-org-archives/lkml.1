Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423Ab0ARUBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0ARUBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 15:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296Ab0ARUBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 15:01:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:59726 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab0ARUBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 15:01:20 -0500
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <20100118172935.GM10364@nowhere>
References: <20100118134324.GB10364@nowhere>
	 <1263822898.4283.558.camel@laptop> <20100118142004.GD10364@nowhere>
	 <1263825158.4283.590.camel@laptop> <20100118144556.GE10364@nowhere>
	 <1263826601.4283.603.camel@laptop> <20100118161836.GG10364@nowhere>
	 <1263831973.4283.622.camel@laptop> <20100118165114.GJ10364@nowhere>
	 <1263834806.4283.625.camel@laptop>  <20100118172935.GM10364@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 21:01:06 +0100
Message-ID: <1263844866.4283.629.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 18:29 +0100, Frederic Weisbecker wrote:
> On Mon, Jan 18, 2010 at 06:13:26PM +0100, Peter Zijlstra wrote:
> > On Mon, 2010-01-18 at 17:51 +0100, Frederic Weisbecker wrote:
> > 
> > > Right hw_perf_enable/disable have no action on breakpoint events.
> > > These were somehow considered as software events until now.
> > > 
> > > That raises the question: why perf_disable() only takes care
> > > of hardware events? Very few software events can trigger
> > > between perf_disable() and perf_enable() sections though.
> > > 
> > > May be I should handle breakpoints there.
> > 
> > OK, so maybe I'm not understanding the breakpoint stuff correctly, why
> > is it modeled as a software pmu? It has resource constraints like a
> > hardware pmu.
> 
> 
> It doesn't use the software pmu, it uses its own. But what kind
> of properties can it share with other hardware events?
> 
> It has constraints that only need to be checked when we register
> the event. It has also constraint on enable time but nothing
> tricky that requires an overwritten group scheduling.

the only group scheduling bit is hw_perf_group_sched_in(), and I guess
you can get away without hw_perf_disable() because it doesn't generate
nmis, although I'd have to audit the code to verify a properly placed
breakpoint won't trip things up, since the core code basically assumes
counters won't trigger within perf_disable/enable sections.



