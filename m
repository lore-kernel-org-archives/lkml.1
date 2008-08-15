Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbYHONqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbYHONqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758481AbYHONqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:46:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49607 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758282AbYHONqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:46:13 -0400
Date: Fri, 15 Aug 2008 15:45:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix /proc/meminfo DirectMap
Message-ID: <20080815134545.GB9243@elte.hu>
References: <Pine.LNX.4.64.0808151351220.28840@blonde.site> <20080815131530.GG19125@one.firstfloor.org> <Pine.LNX.4.64.0808151426080.309@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808151426080.309@blonde.site>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> On Fri, 15 Aug 2008, Andi Kleen wrote:
> > On Fri, Aug 15, 2008 at 01:58:32PM +0100, Hugh Dickins wrote:
> > > Do we actually want these DirectMap lines in the x86 /proc/meminfo?
> > > I can see they're interesting to CPA developers and TLB optimizers,
> > > but they don't fit its usual "where has all my memory gone?" usage.
> > 
> > It was intended for the "why is my computer going slower" usage.
> 
> Yes, that's what I meant by the TLB optimizers.  But it's going to be 
> a fractional effect, isn't it, when you're trying to get the last 1% 
> out of the machine?  And in such a case, you might wonder more what 
> all the 4k ones are actually being used for (no problem at all if 
> they've ended up behind vmalloced module text).

i cannot see any performance difference myself between 2MB and 1GB TLBs.

There are measurements that Andi Kleen did originally in this commit:

 commit 8346ea17aa20e9864b0f7dc03d55f3cd5620b8c1
 Author: Andi Kleen <andi@firstfloor.org>
 Date:   Wed Mar 12 03:53:32 2008 +0100

    x86: split large page mapping for AMD TSEG

    [lower is better]
                  no split stddev         split  stddev    delta
    Elapsed Time   87.146 (0.727516)     84.296 (1.09098)  -3.2%
    User Time     274.537 (4.05226)     273.692 (3.34344)  -0.3%
    System Time    34.907 (0.42492)      34.508 (0.26832)  -1.1%
    Percent CPU   322.5   (38.3007)     326.5   (44.5128)  +1.2%

    => About 3.2% improvement in elapsed time for kernbench.
 [...]

meanwhile i have Barcelona class hardware myself and i cannot reproduce 
these claimed improvements in kernbench performance. gbpages versus 
no-gbpages results are dead on the same, within statistical noise.

( i'm sure it could make some difference in synthetic user-space 
  workloads - but gbpages are not exposed to user-space anyway. )

	Ingo
