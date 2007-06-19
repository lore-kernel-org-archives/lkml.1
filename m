Return-Path: <linux-kernel-owner+w=401wt.eu-S933488AbXFSTxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbXFSTxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761775AbXFSTxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:53:38 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2678 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760868AbXFSTxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:53:37 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 19 Jun 2007 12:53:34 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
In-Reply-To: <20070619140646.GB27343@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0706191244090.16740@alien.or.mcafeemobile.com>
References: <1182064500.2798.6.camel@entropy>
 <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com>
 <1182108399.3794.4.camel@entropy> <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
 <1182125303.3794.8.camel@entropy> <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com>
 <1182127391.26853.207.camel@localhost.localdomain>
 <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org>
 <20070619091452.GA94@tv-sign.ru> <1182254988.26853.334.camel@localhost.localdomain>
 <20070619140646.GB27343@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Oleg Nesterov wrote:

> On 06/19, Benjamin Herrenschmidt wrote:
> >
> > On Tue, 2007-06-19 at 13:14 +0400, Oleg Nesterov wrote:
> > 
> > > The commited "Fix signalfd interaction with thread-private signals"
> > > (commit caec4e8dc85e0644ec24aeb36285e1ba02da58cc) doesn't implement
> > > this.
> > 
> > Indeed, if you want what Davide described, you need to also change
> > signalfd side. The patch I did merely prevents another thread from
> > dequeuing somebody else private signals.
> 
> Yes I see, but why do we need this change? Yes, we can dequeue SIGSEGV
> from another thread. Just don't do it if you have a handler for SIGSEGV?

I believe it can be confusing to have private signals dequeued from 
another thread. The kernel expect those to be dequeued by the target 
thread.


- Davide


