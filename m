Return-Path: <linux-kernel-owner+w=401wt.eu-S1752244AbZFVLum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbZFVLum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbZFVLue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:50:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42205 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZFVLue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:50:34 -0400
Date: Mon, 22 Jun 2009 13:50:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.2 - Grouping
Message-ID: <20090622115017.GC24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2/ Grouping
>
> By design, an event can only be part of one group at a time.
> Events in a group are guaranteed to be active on the PMU at the
> same time. That means a group cannot have more events than there
> are available counters on the PMU. Tools may want to know the
> number of counters available in order to group their events
> accordingly, such that reliable ratios could be computed. It seems
> the only way to know this is by trial and error. This is not
> practical.

Groups are there to support heavily constrained PMUs, and for them
this is the only way, as there is no simple linear expression for
how many counters one can load on the PMU.

The ideal model to tooling is relatively independent PMU registers
(counters) with little constraints - most modern CPUs meet that
model.

All the existing tooling (tools/perf/) operates on that model and
this leads to easy programmability and flexible results. This model
needs no grouping of counters.

Could you please cite specific examples in terms of tools/perf/?
What feature do you think needs to know more about constraints? What
is the specific win in precision we could achieve via that?
