Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbXGSK6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbXGSK6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbXGSK60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:58:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57369 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871AbXGSK60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:58:26 -0400
Date: Thu, 19 Jul 2007 12:58:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070719105816.GA15852@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707191144.24434.olaf.kirch@oracle.com> <20070719100135.GA2986@elte.hu> <200707191237.56455.olaf.kirch@oracle.com> <20070719104756.GA13769@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719104756.GA13769@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Olaf Kirch <olaf.kirch@oracle.com> wrote:
> 
> > On Thursday 19 July 2007 12:01, Ingo Molnar wrote:
> > >  Calling initcall 0xc0603f55: netpoll_init+0x0/0x39()
> > >  initcall 0xc0603f55: netpoll_init+0x0/0x39() returned 0.
> > >  initcall 0xc0603f55 ran for 0 msecs: netpoll_init+0x0/0x39()
> > >  Calling initcall 0xc0604257: netlink_proto_init+0x0/0x12a()
> > >  NET: Registered protocol family 16
> > > 
> > > and no output ever since - and the box has been up for a few minutes.
> > 
> > Okay, I need to ask a stupid question - did you verify that it's not 
> > spinning on a spinlock?

ok, i just to make my description clearer: 'netconsole output hung' 
means that on the netconsole-receiving box (which is not the laptop with 
the problem) i dont get any netconsole output printed. (i.e. UDP packets 
are not being sent by the laptop.) The above snippet is the last i get. 
Otherwise the laptop boots up fine, but has that early tx timeout and 
subsequently no networking. I can still do things on the laptop as 
normal, but eth0 irqs do not advance (are stuck at 5) and networking is 
stuck.

i.e. it's the classic 'eth0 got stuck somehow' tx/rx state machine 
hickup symptoms, with no other bad symptoms such as lockups or crashes.

	Ingo
