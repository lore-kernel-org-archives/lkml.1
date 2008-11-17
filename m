Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYKQTxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYKQTxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYKQTxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:53:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42716 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYKQTxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:53:44 -0500
Date: Mon, 17 Nov 2008 20:53:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, dada1@cosmosbay.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
Message-ID: <20081117195316.GA8235@elte.hu>
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <20081117.113158.200497613.davem@davemloft.net> <alpine.LFD.2.00.0811171134480.18283@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811171134480.18283@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 17 Nov 2008, David Miller wrote:
> > 
> > The scheduler has accounted for at least %10 of the tbench 
> > regressions at this point, what are you talking about?
> 
> I'm wondering if you're not looking at totally different issues.
> 
> For example, if I recall correctly, David had a big hit on the 
> hrtimers. And I wonder if perhaps Ingo's numbers are without 
> hrtimers or something?

hrtimers should not be an issue anymore since this commit:

| commit 0c4b83da58ec2e96ce9c44c211d6eac5f9dae478
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Mon Oct 20 14:27:43 2008 +0200
|
|     sched: disable the hrtick for now
|    
|     David Miller reported that hrtick update overhead has tripled the
|     wakeup overhead on Sparc64.
|    
|     That is too much - disable the HRTICK feature for now by default,
|     until a faster implementation is found.
|    
|     Reported-by: David Miller <davem@davemloft.net>
|     Acked-by: Peter Zijlstra <peterz@infradead.org>
|     Signed-off-by: Ingo Molnar <mingo@elte.hu>

Which was included in v2.6.28-rc1 already.

	Ingo
