Return-Path: <linux-kernel-owner+w=401wt.eu-S938689AbXGSQNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938689AbXGSQNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765544AbXGSQNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:13:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47482 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765396AbXGSQNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:13:23 -0400
Date: Thu, 19 Jul 2007 18:13:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070719161311.GA4711@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707191144.24434.olaf.kirch@oracle.com> <20070719100135.GA2986@elte.hu> <200707191237.56455.olaf.kirch@oracle.com> <20070719104756.GA13769@elte.hu> <20070719105816.GA15852@elte.hu> <20070719150728.GA17000@elte.hu> <20070719153217.GA25544@elte.hu> <20070719155230.GA31267@elte.hu> <20070719160556.GA3330@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719160556.GA3330@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > i'll now check whether removing ignore_on_loglevel (no other 
> > changes) makes the hang go away. Maybe ignore_on_loglevel is buggy - 
> > or it produces an immediate printk (going out to the interface) 
> > during a particularly sensitive period of network initialization.
> 
> nope, that didnt have any effect. I have another theory: i had a 
> network-intense stress-test going on in the past few hours on the same 
> network (not involving the laptop) and i stopped it recently. Perhaps 
> that network-intense test also produced periodic broadcast packets 
> that got the e1000 out of its weird state before the tx timeout could 
> hit. Now that i've stopped the test, the network is quiescent again 
> and the e1000 hangs.

yep - i can confirm this theory now: if i start a broadcast ping on 
another box while the laptop is booting up, the network hang does not 
happen. If i stop the ping and do another bootup with the very same 
kernel, it hangs. So for the hang to happen, the network has to be very 
quiet. At least one mystery solved :-/

	Ingo
