Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbXFWGFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbXFWGFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 02:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXFWGFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 02:05:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:46624 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbXFWGFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 02:05:23 -0400
Subject: Re: Fix signalfd interaction with thread-private signals
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706221710150.3880@alien.or.mcafeemobile.com>
References: <20070620111415.GA91@tv-sign.ru>
	 <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org>
	 <20070621082509.GA88@tv-sign.ru>
	 <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
	 <20070621182340.GA92@tv-sign.ru>
	 <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org>
	 <20070621185856.GA153@tv-sign.ru>
	 <1182468604.24740.22.camel@localhost.localdomain>
	 <20070622084034.GA134@tv-sign.ru>
	 <1182512473.24740.54.camel@localhost.localdomain>
	 <20070622160405.GA189@tv-sign.ru>
	 <1182551618.24740.79.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706221540430.3593@woody.linux-foundation.org>
	 <1182554190.24740.84.camel@localhost.localdomain>
	 <1182554371.24740.87.camel@localhost.localdomain>
	 <1182555727.2735.3.camel@entropy>
	 <Pine.LNX.4.64.0706221710150.3880@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Sat, 23 Jun 2007 16:05:08 +1000
Message-Id: <1182578708.24740.95.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 17:12 -0700, Davide Libenzi wrote:
> Wasn't it you that bitched (just a few days ago) because multiple
> threads 
> could not use the same signalfd and they (by your initial thought) had
> to 
> create one per thread?

He said multiple process and you say multiple threads...

If signalfd isn't attached to any context, it would then be useable by
all threads in a process, delivering them their private signals and the
process shared signals. Makes sense to me.

By removing that context thing, you lose the ability to listen to some
other -process- signals, which is probably a bad idea in the first place
anyway... if you're going to do that, use ptrace (yuck) :-)

Now, you -might- have valid uses for that later ability, but if not, it
then makes some sense to only "attach" when an actual read or poll is
done and only for the duration of that read/poll and only for that
reader/poller (not the whole signalfd instance).

I think that's what Nicholas means... and it may even simplify the code.
 
Ben.


