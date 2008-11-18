Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbYKRIax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbYKRIax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbYKRIao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:30:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36664 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbYKRIan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:30:43 -0500
Date: Tue, 18 Nov 2008 09:30:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, dada1@cosmosbay.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       shemminger@vyatta.com
Subject: Re: eth_type_trans(): Re: [Bug #11308] tbench regression on each
	kernel release from 2.6.22 -&gt; 2.6.28
Message-ID: <20081118083018.GI17838@elte.hu>
References: <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117212657.GH12020@elte.hu> <20081117.211645.193706814.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117.211645.193706814.davem@davemloft.net>
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
> Date: Mon, 17 Nov 2008 22:26:57 +0100
> 
> > eth->h_proto access.
> 
> Yes, this is the first time a packet is touched on receive.
> 
> > Given that this workload does localhost networking, my guess would be 
> > that eth->h_proto is bouncing around between 16 CPUs? At minimum this 
> > read-mostly field should be separated from the bouncing bits.
> 
> It's the packet contents, there is no way to "seperate it".
> 
> And it should be unlikely bouncing on your system under tbench, the 
> senders and receivers should hang out on the same cpu unless the 
> something completely stupid is happening.
> 
> That's why I like running tbench with a num_threads command line 
> argument equal to the number of cpus, every cpu gets the two thread 
> talking to eachother over the TCP socket.

yeah - and i posted the numbers for that too - it's the same 
throughput, within ~1% of noise.

	Ingo
