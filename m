Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbXFUSgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbXFUSgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbXFUSgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:36:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbXFUSgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:36:13 -0400
Date: Thu, 21 Jun 2007 11:35:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
In-Reply-To: <20070621182340.GA92@tv-sign.ru>
Message-ID: <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org>
References: <1182127391.26853.207.camel@localhost.localdomain>
 <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org>
 <20070619091452.GA94@tv-sign.ru> <1182254988.26853.334.camel@localhost.localdomain>
 <20070619140646.GB27343@tv-sign.ru> <1182295473.26853.386.camel@localhost.localdomain>
 <20070620111415.GA91@tv-sign.ru> <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org>
 <20070621082509.GA88@tv-sign.ru> <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
 <20070621182340.GA92@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Oleg Nesterov wrote:
> 
> Yes, the target thread is the one that caused the SIGSEGV, it sends the signal
> to itself. entry.S:ret_from_exception should notice this signal and _dequeue_
> it, no? This signal could be stealed by signal(SIG_IGN) which runs after it
> was delivered.

Right. But it will dequeue it by *taking* it.

IOW, this has absolutely nothing to do with signalfd.

That's all I mean.

> My point was that it is _possible_ to steal a thread-local SIGSEGV even without
> signalfd, nothing bad should happen.

That makes no sense.

You don't "steal" it. You take it. It's what SIGSEGV (and _any_ signal) 
has always been about. You get the signal, enter the signal handler, and 
handle it. 

No "stealing". No signalfd, no *nothing*. Just normal signal behaviour.

		Linus
