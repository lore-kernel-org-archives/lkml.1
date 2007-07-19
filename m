Return-Path: <linux-kernel-owner+w=401wt.eu-S1764736AbXGSKsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764736AbXGSKsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXGSKsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:48:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58488 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbXGSKsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:48:06 -0400
Date: Thu, 19 Jul 2007 12:47:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070719104756.GA13769@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707191144.24434.olaf.kirch@oracle.com> <20070719100135.GA2986@elte.hu> <200707191237.56455.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707191237.56455.olaf.kirch@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Olaf Kirch <olaf.kirch@oracle.com> wrote:

> On Thursday 19 July 2007 12:01, Ingo Molnar wrote:
> >  Calling initcall 0xc0603f55: netpoll_init+0x0/0x39()
> >  initcall 0xc0603f55: netpoll_init+0x0/0x39() returned 0.
> >  initcall 0xc0603f55 ran for 0 msecs: netpoll_init+0x0/0x39()
> >  Calling initcall 0xc0604257: netlink_proto_init+0x0/0x12a()
> >  NET: Registered protocol family 16
> > 
> > and no output ever since - and the box has been up for a few minutes.
> 
> Okay, I need to ask a stupid question - did you verify that it's not 
> spinning on a spinlock?

the box is fully usable after it has booted up and (as you can see it in 
the config i've uploaded) i've got every kernel debug option enabled, 
including lockdep.

> Specifically, I'm wondering whether the net_rx_action softirq may be 
> scheduled while we're in poll_napi holding the poll_lock. 
> net_rx_action would try to take the poll_lock as well, and we'd be 
> hung for good. The patch with local_bh_disable/enable was supposed to 
> test that idea (this is the "trickle" patch)

the box isnt hung - it just has no networking. (i couldnt get the logs 
out if it were hung - netconsole is the only remote debugging option and 
with that broken i can only get info out if it boots up fine)

	Ingo
