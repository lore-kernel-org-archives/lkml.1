Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318Ab0AROhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0AROhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881Ab0AROhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:37:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab0AROhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:37:15 -0500
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <20100118142004.GD10364@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop>
	 <20100118142004.GD10364@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 15:37:01 +0100
Message-ID: <1263825421.4283.597.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 15:20 +0100, Frederic Weisbecker wrote:
> 
> > Then there's still the question of having events of multiple hw pmus in
> > a single group, I'd be perfectly fine with saying that's not allowed,
> > what to others think?
> 
> 
> I guess we need that. It can be insteresting to couple
> hardware counters with memory accesses...or whatever.

That really depends on how easy it is to correlate events from the
various pmus. This case could indeed do that, but the core vs uncore
tihng is a lot less clear.

> Perf stat combines cache miss counting with page faults,
> cpu clock counters.

perf stat also doesn't use groups and it still works quite nicely.

> We shouldn't limit such possibilities for technical/cleanliness
> reasons. We should rather adapt.

Maybe, I'm not a very big fan of groups myself, but they are clearly
useful within a pmu, measuring cache misses through total-access for
example, but the use between pmus is questionable.

But sure, if we can do it without too much pain, that's fine.

