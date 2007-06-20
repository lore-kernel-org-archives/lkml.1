Return-Path: <linux-kernel-owner+w=401wt.eu-S1761985AbXFTDrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985AbXFTDrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 23:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbXFTDro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 23:47:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:44377 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759291AbXFTDrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 23:47:43 -0400
Subject: Re: Fix signalfd interaction with thread-private signals
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706191908000.16740@alien.or.mcafeemobile.com>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
	 <1182064500.2798.6.camel@entropy>
	 <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com>
	 <1182108399.3794.4.camel@entropy>
	 <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
	 <1182125303.3794.8.camel@entropy>
	 <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com>
	 <1182127391.26853.207.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org>
	 <20070619091452.GA94@tv-sign.ru>
	 <Pine.LNX.4.64.0706191643400.16740@alien.or.mcafeemobile.com>
	 <1182302739.22337.9.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706191908000.16740@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 13:46:57 +1000
Message-Id: <1182311217.22337.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 19:15 -0700, Davide Libenzi wrote:

> Ok, why instead don't we go for something like the attached patch?
> We exclude sync signals from signalfd, but we don't limit signalfd to 
> shared signals. Ie, we should be able to fetch a signal sent with 
> sys_tkill() to threads different from "current", that otherwise we would 
> not be able to fetch.
> Ben, sorry but my memory sucks ... the "notifier" thing was fine in that 
> case, no?

I'm generally nervous about the idea of letting signalfd dequeue
somebody else private signals... even if we filter out SEGV's and
friends but I'll let Linus decide there.

Regarding the notifier, it's dodgy in most cases I'd say but I suppose
it should be allright to only worry about "current" and not the target
task there.

Ben. 

