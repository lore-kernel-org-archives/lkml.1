Return-Path: <linux-kernel-owner+w=401wt.eu-S934325AbZDHQje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325AbZDHQje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760184AbZDHQjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:39:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbZDHQjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:39:22 -0400
Date: Wed, 8 Apr 2009 18:38:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       niv@us.ibm.com, dvhltc@us.ibm.com, dhowells@redhat.com,
       kernel@wantstofly.org, matthew@wil.cx, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] v3 RCU: the bloatwatch edition
Message-ID: <20090408163838.GB14449@elte.hu>
References: <20090203183426.GA14409@linux.vnet.ibm.com> <20090329203118.GA14005@linux.vnet.ibm.com> <20090402223605.GB19007@elte.hu> <20090402224455.GA13777@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402224455.GA13777@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mundt <lethal@linux-sh.org> wrote:

> On Fri, Apr 03, 2009 at 12:36:05AM +0200, Ingo Molnar wrote:
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > This patch is a version of RCU designed for (!SMP && EMBEDDED) 
> > > provided as a proof of concept of a small-footprint RCU 
> > > implementation. In particular, the implementation of 
> > > synchronize_rcu() is extremely lightweight and high performance.  
> > > It passes rcutorture testing in each of the four relevant 
> > > configurations (combinations of NO_HZ and PREEMPT) on x86.  This 
> > > saves about 900 bytes compared to Classic RCU, and a couple 
> > > kilobytes compared to Hierarchical RCU:
> > 
> > Andrew, what do you think?
> > 
> > A worry is yet another RCU variant - we already have 3.
> > 
> > A trick we could use would be to put it into Documentation/rcu/, 
> > linked in via some clever Makefile magic and only usable if a 
> > ultra-embedded developer does a build with something like 
> > CONFIG_RCU_TINY=y. That way there's no real maintenance and testing 
> > overhead.
> > 
> > It _does_ have documentation value beyond the ~900 bytes: it's the 
> > simplest and smallest possible still-working UP RCU implementation 
> > so it would be easy to teach RCU concepts via that, gradually.
> 
> A similar argument could have been used for tiny-shmem when it was 
> first integrated. As this is hiding behind CONFIG_EMBEDDED, most 
> users are not going to run in to it, so the confusion of 1 more 
> RCU variant is not likely to be a problem for those that aren't 
> actively seeking it out.
> 
> So, personally I think it is a good idea, and I have no 
> reservations about default enabling it for a number of more 
> constrained SH platforms.

but at least tiny-shmem is now nicely hidden in mm/shmem.c, in an 
unintrusive !CONFIG_SHMEM branch. There's no CONFIG_TINY_SHMEM 
option anymore - it's all done in the !CONFIG_SHMEM case.

Is tiny-RCU in the same category?

	Ingo
