Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbXLSODi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbXLSODi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 09:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXLSOD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 09:03:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38696 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbXLSOD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 09:03:27 -0500
Date: Wed, 19 Dec 2007 15:03:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: Inline local_bh_disable when TRACE_IRQFLAGS
Message-ID: <20071219140313.GE21282@elte.hu>
References: <20071219034033.GA5770@gondor.apana.org.au> <20071219113152.GD20736@elte.hu> <20071219115019.GA9099@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219115019.GA9099@gondor.apana.org.au>
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Dec 19, 2007 at 12:31:52PM +0100, Ingo Molnar wrote:
> >
> > > So I'm wondering if it would be reasonable to make it out-of-line 
> > > when TRACE_IRQFLAGS is off.  This may make a difference because 
> > > the networking stack is a frequent user of local_bh_disable and 
> > > local_bh_enable.
> > 
> > do you mean to make it inline again?
> 
> Yes I meant in-line :)

if that decreases code size then i guess we could do that.

> > (btw., generally i think local_bh_disable() is a poor API because it 
> > is opaque about the data structure dependency that it governs. 
> > Explicit exclusion rules generally work better.)
> 
> I see where you're coming from especially with your preemptible 
> softirq work.  However I'm mostly thinking about the existing callers 
> of local_bh_disable in the networking stack.

yeah, i was just commenting on the general concept of 'naked' 
local_bh_disable(). And just to make it clear: with that i'm not 
implying anything about the quality of the networking code - networking 
is one of the cleanest [if not the cleanest] subsystems in the kernel. 

It's just that it's long term more useful for us if our "global scope" 
APIs have direct, programmatic relationship to the data structures / 
data flow they control. So i'd love to have the same flow/performance, 
just coded a bit more explicitly. [preempt_disable() for example has 
similar issues.]

	Ingo
