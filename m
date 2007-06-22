Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbXFVLmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbXFVLmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 07:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbXFVLl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 07:41:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:55386 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbXFVLlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 07:41:55 -0400
Subject: Re: Fix signalfd interaction with thread-private signals
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070622084034.GA134@tv-sign.ru>
References: <20070619140646.GB27343@tv-sign.ru>
	 <1182295473.26853.386.camel@localhost.localdomain>
	 <20070620111415.GA91@tv-sign.ru>
	 <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org>
	 <20070621082509.GA88@tv-sign.ru>
	 <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
	 <20070621182340.GA92@tv-sign.ru>
	 <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org>
	 <20070621185856.GA153@tv-sign.ru>
	 <1182468604.24740.22.camel@localhost.localdomain>
	 <20070622084034.GA134@tv-sign.ru>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 21:41:13 +1000
Message-Id: <1182512473.24740.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> OK. But in that case I think we should go further, and make signalfd
> "per process", not "per thread", see
> 
> 	http://marc.info/?l=linux-kernel&m=118241815219430
> 
> Every thread gets its own local signals plus shared ones.
> 
> (I promise, this is the last piece of spam from me on this topic, but
>  please-please-please nack this patch explicitly if you don't like it :)

No, I think your patch do make sense.

That is, it -does- make sense to be able to create a signal singalfd in
a process and have N threads reading from it and getting either shared
signals or their local private signals.

I just don't like the actual implementation of it by changing the task
pointer on the fly...

My main issue is a matter of consistency of the signalfd API as a
whole... the whole bloody thing is instanciated & attached to a thread
in the first place. Maybe we should change that and say that one
instanciates a signalfd on a thread group... that is, it always gets
attached to the leader.

It might well be that signalfd's concept of context is wrong in the
first place and it should be attached to processes rather than threads
and that made more explicit in the first place... but that leaves the
door open to what a write() API should be ...

Ben.


