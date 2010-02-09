Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab0BIER6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 23:17:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46922 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab0BIER5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 23:17:57 -0500
Date: Tue, 9 Feb 2010 05:17:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC perf,x86] P4 PMU early draft
Message-ID: <20100209041739.GA11280@elte.hu>
References: <20100208184504.GB5130@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208184504.GB5130@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Hi all,
> 
> first of all the patches are NOT for any kind of inclusion. It's not ready 
> yet. More likely I'm asking for glance review, ideas, criticism.

A quick question: does the code produce something on a real P4? (possibly 
only running with a single event - but even that would be enough.)

> The main problem in implementing P4 PMU is that it has much more 
> restrictions for event to MSR mapping. [...]

One possibly simpler approach might be to represent the P4 PMU via a maximum 
_two_ generic events only.

Last i looked at the many P4 events, i've noticed that generally you can 
create any two events. (with a few exceptions) Once you start trying to take 
advantage of the more than a dozen seemingly separate counters, additional 
non-trivial constraints apply.

So if we only allowed a maximum of _two_ generic events (like say a simple 
Core2 has, so it's not a big restriction at all), we wouldnt have to map all 
the constraints, we'd only have to encode the specific event-to-MSR details. 
(which alone is quite a bit of work as well.)

We could also use the new constraints code to map them all, of course - it 
will certainly be more complex to implement.

Hm?

	Ingo
