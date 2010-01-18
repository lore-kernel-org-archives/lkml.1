Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388Ab0AROx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0AROx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948Ab0AROxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:53:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:11373 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab0AROxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:53:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TamwfsK3ADagaYEaaxlpClmC7lvhJFPrqgRULFs15cN68nFt4B+HPoXWh0cnL/K8uW
         wZgP4DftvSHrA3e1zj0DqfZtsT6xr3zkXxTO7D/3pYcSiZH73YTg74MwNrtwr6dci59r
         eUkm/mAf7I2Ggqw/0C9t2c+xt131w41gp5cog=
Date: Mon, 18 Jan 2010 15:53:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
Message-ID: <20100118145346.GF10364@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com> <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop> <20100118142004.GD10364@nowhere> <1263825421.4283.597.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263825421.4283.597.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 03:37:01PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 15:20 +0100, Frederic Weisbecker wrote:
> > 
> > > Then there's still the question of having events of multiple hw pmus in
> > > a single group, I'd be perfectly fine with saying that's not allowed,
> > > what to others think?
> > 
> > 
> > I guess we need that. It can be insteresting to couple
> > hardware counters with memory accesses...or whatever.
> 
> That really depends on how easy it is to correlate events from the
> various pmus. This case could indeed do that, but the core vs uncore
> tihng is a lot less clear.



Not sure what you both mean by this core VS uncore thing :)
Is it about hardware counters that apply to single hardware threads
or shared among them inside a same core?


 
> > Perf stat combines cache miss counting with page faults,
> > cpu clock counters.
> 
> perf stat also doesn't use groups and it still works quite nicely.


Ah? I thought it does.


 
> > We shouldn't limit such possibilities for technical/cleanliness
> > reasons. We should rather adapt.
> 
> Maybe, I'm not a very big fan of groups myself, but they are clearly
> useful within a pmu, measuring cache misses through total-access for
> example, but the use between pmus is questionable.


Cross pmu, these seem to only make sense for non pinned groups.
If you want two non-pinned counters to be paired and not randomly
and separately scheduled.

For other cases, indeed I'm not sure it is useful :)

