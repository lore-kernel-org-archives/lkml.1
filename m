Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbYJ0L2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbYJ0L2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYJ0L2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:28:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46737 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYJ0L2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:28:19 -0400
Date: Mon, 27 Oct 2008 12:27:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl, s0mbre@tservice.net.ru,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Message-ID: <20081027112750.GA2771@elte.hu>
References: <20081024.221653.23695396.davem@davemloft.net> <1224914333.3822.18.camel@marge.simson.net> <1224917623.4929.15.camel@marge.simson.net> <20081025.002420.82739316.davem@davemloft.net> <Pine.LNX.4.64.0810260055070.22126@twin.jikos.cz> <1225010790.8566.22.camel@marge.simson.net> <1225011648.27415.4.camel@twins> <20081026021153.47878580.akpm@linux-foundation.org> <alpine.LNX.1.10.0810262002450.12928@jikos.suse.cz> <alpine.LNX.1.10.0810271138470.12928@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0810271138470.12928@jikos.suse.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> Ok, so another important datapoint:
> 
> with c1e4fe711a4 (just before CFS has been merged for 2.6.23), the dbench 
> throughput measures
> 
> 	187.7 MB/s
> 
> in our testing conditions (default config).
> 
> With c31f2e8a42c4 (just after CFS has been merged for 2.6.23), the 
> throughput measured by dbench is
> 
> 	82.3 MB/s
> 
> This is the huge drop we have been looking for. After this, the 
> performance was still going down gradually, up to ~45 MS/ we are 
> measuring for 2.6.27. But the biggest drop (more than 50%) points 
> directly to CFS merge.

that is a well-known property of dbench: it rewards unfairness in IO, 
memory management and scheduling.

The way to get the best possible dbench numbers in CPU-bound dbench 
runs, you have to throw away the scheduler completely, and do this 
instead:

 - first execute all requests of client 1
 - then execute all requests of client 2
 ....
 - execute all requests of client N

the moment the clients are allowed to overlap, the moment their requests 
are executed more fairly, the dbench numbers drop.

	Ingo
