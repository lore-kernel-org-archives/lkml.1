Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753154AbYLQOyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbYLQOyu (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 09:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYLQOyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 09:54:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38785 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYLQOyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 09:54:36 -0500
Date: Wed, 17 Dec 2008 16:06:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nils Smeds <nils.smeds@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        William Cohen <wcohen@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Robert Richter <robert.richter@amd.com>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Stephane Eranian <eranian@googlemail.com>,
        Paul Mackerras <paulus@samba.org>, Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        perfctr-devel@lists.sourceforge.net,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Perfctr-devel] [patch] Performance Counters for Linux, v4
Message-ID: <20081217150647.GE25779@one.firstfloor.org>
References: <20081214212829.GA9435@elte.hu> <494807D2.3060808@redhat.com> <87prjr1scl.fsf@basil.nowhere.org> <20081217015601.GE5147@const.famille.thibault.fr> <d484eb1f0812162357n7a851f2fncc0abaae9bd293a4@mail.gmail.com> <20081217091845.GC25779@one.firstfloor.org> <d484eb1f0812170611s597e014cl5fb98d6dd81afd49@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d484eb1f0812170611s597e014cl5fb98d6dd81afd49@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, now I see where I got the understanding of this thread.
> PERF_COUNT_CACHE_REFERENCES did not refer to a PAPI event. My error.

Ok that makes sense. 

> A suggested kernel/user API that obscures the underlying PMU hardware
> counters instead of exposing it to user level code should be dropped as

It doesn't really obscure it (although there are some doubts it can
express many of the more powerful/complicated features of modern PMUs),
but provides a set of generalized standard events in addition, plus
a "raw mode". The current list of events as of v4 is:

+       PERF_COUNT_CYCLES               =  0,
+       PERF_COUNT_INSTRUCTIONS         =  1,
+       PERF_COUNT_CACHE_REFERENCES     =  2,
+       PERF_COUNT_CACHE_MISSES         =  3,
+       PERF_COUNT_BRANCH_INSTRUCTIONS  =  4,
+       PERF_COUNT_BRANCH_MISSES        =  5,

I think cache_references/misses is not well defined enough to be useful.

The Intel architectural perfmon (which is a standard set of event
supported over a range of Intel x86 micro architectures) has similar
events defined as hitting the LLC (last level cache). With that
it makes some sense.

-Andi

-- 
ak@linux.intel.com
