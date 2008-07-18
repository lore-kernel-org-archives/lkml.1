Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbYGRJFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbYGRJFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYGRJFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:05:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbYGRJF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:05:29 -0400
Date: Fri, 18 Jul 2008 11:05:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, penberg@cs.helsinki.fi, rjw@sisk.pl
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
	overwritten
Message-ID: <20080718090506.GO6875@elte.hu>
References: <20080717214222.GA29449@elte.hu> <19f34abd0807171615s5b477d4cr22d3e9444bcf65df@mail.gmail.com> <20080717.190315.186892939.davem@davemloft.net> <19f34abd0807180003m7bdf832g141777751d7ea563@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807180003m7bdf832g141777751d7ea563@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> But.. it could also be some random corruption coming from elsewhere. 
> Maybe even bad RAM (it's just a single bit anyway). But that's less 
> likely.

ok, i looked at the logs once more and while i thought that it occured 
twice it only occured once:

  Jul 17 20:22:14 europe kernel: BUG skbuff_head_cache: Poison overwritten

... this would explain why my attempts to bisect and reproduce it 
failed. I got too excited about it being seemingly reproducible and 
possibly bisectable (memory corruption bugs rarely are). My overnight 
reboot-the-same-kernel tests didnt show anything either.

It's a known-reliable system with thousands of bootups:

 Jul 17 20:20:54 europe kernel: Linux version 2.6.26-tip (mingo@europe) 
 (gcc version 4.2.2) #3094 SMP Thu Jul 17 20:19:27 CEST 2008

... but a hw fluke is never out of question. (It wasnt a particularly 
hot day but the evening was unusually humid, maybe that made the 
difference.)

So lets close this for now, it's not a reproducible regression that we 
can act upon. I'll update this thread if anything new happens. 
Netconsole is reliable on this system in any case.

	Ingo
