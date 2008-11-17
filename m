Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbYKQWs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbYKQWs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbYKQWsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:48:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34026 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYKQWsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:48:11 -0500
Date: Mon, 17 Nov 2008 23:47:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: dada1@cosmosbay.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
Message-ID: <20081117224751.GA19905@elte.hu>
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <20081117.113158.200497613.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117.113158.200497613.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 17 Nov 2008 17:11:35 +0100
> 
> > Ouch, +4% from a oneliner networking change? That's a _huge_ speedup 
> > compared to the things we were after in scheduler land.
> 
> The scheduler has accounted for at least %10 of the tbench 
> regressions at this point, what are you talking about?

yeah, you are probably right when it comes to task migration policy 
impact - that can have effects in that range. (and that, you have to 
accept, is a fundamentally hard and fragile job to get right, as it 
involves observing the past and predicting the future out of it - at 
1.3 million events per second)

So above i was just talking about straight scheduling code overhead. 
(that cannot have been +10% of the total - as the whole scheduler only 
takes 7% total - TLB flush and FPU restore overhead included. Even the 
hrtimer bits were about 1% of the total.)

	Ingo
