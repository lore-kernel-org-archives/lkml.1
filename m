Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbXFTB0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbXFTB0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 21:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbXFTBZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 21:25:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:59869 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757102AbXFTBZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 21:25:58 -0400
Subject: Re: Fix signalfd interaction with thread-private signals
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706191643400.16740@alien.or.mcafeemobile.com>
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
Content-Type: text/plain
Date: Wed, 20 Jun 2007 11:25:39 +1000
Message-Id: <1182302739.22337.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 16:49 -0700, Davide Libenzi wrote:

> Actually, I think signalfd is fine as is, with Ben's patch applied. 
> Signalfd should only fetch shared signals, not specific ones (in any 
> case).

The only advantage of that additional patch is that it will allow any
thread to fetch its own private signals via signalfd, regardless of what
context is attached to the signalfd in the first place.

Without the patch (with what's currently in Linus tree), a thread will
only get its own private signals if it's also the thread that created
the signalfd (and thus is attached to the signalfd "context").

I don't mind either way, up to you guys to decide what semantics you
want.

Ben.


