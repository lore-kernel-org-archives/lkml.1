Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753Ab0ARR3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0ARR3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691Ab0ARR3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:29:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:18226 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab0ARR3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:29:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VcLA7f1DQF9lloRYVukOT58/xppRGOex4UvA0uTcDLp4z85vaDc2UqE+q99kuGLlsj
         QgNIKLBde8p3ACHcB9x+5FIXtdbRLTyMvmYUb5eKlD9cSOTTUlmIyFU0+a86Qv92soQ3
         nDE4S0qk8uV4idmEYeD3Gn8DW+2x5HeqHxCRo=
Date: Mon, 18 Jan 2010 18:29:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
Message-ID: <20100118172935.GM10364@nowhere>
References: <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop> <20100118142004.GD10364@nowhere> <1263825158.4283.590.camel@laptop> <20100118144556.GE10364@nowhere> <1263826601.4283.603.camel@laptop> <20100118161836.GG10364@nowhere> <1263831973.4283.622.camel@laptop> <20100118165114.GJ10364@nowhere> <1263834806.4283.625.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263834806.4283.625.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 06:13:26PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 17:51 +0100, Frederic Weisbecker wrote:
> 
> > Right hw_perf_enable/disable have no action on breakpoint events.
> > These were somehow considered as software events until now.
> > 
> > That raises the question: why perf_disable() only takes care
> > of hardware events? Very few software events can trigger
> > between perf_disable() and perf_enable() sections though.
> > 
> > May be I should handle breakpoints there.
> 
> OK, so maybe I'm not understanding the breakpoint stuff correctly, why
> is it modeled as a software pmu? It has resource constraints like a
> hardware pmu.


It doesn't use the software pmu, it uses its own. But what kind
of properties can it share with other hardware events?

It has constraints that only need to be checked when we register
the event. It has also constraint on enable time but nothing
tricky that requires an overwritten group scheduling.

And moreover it has no internal counters, it sensibly behaves
much like a software pmu by just triggering events.

