Return-Path: <linux-kernel-owner+w=401wt.eu-S1763325AbXFRNma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763325AbXFRNma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 09:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbXFRNmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 09:42:22 -0400
Received: from mail.screens.ru ([213.234.233.54]:43327 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756265AbXFRNmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 09:42:22 -0400
Date: Mon, 18 Jun 2007 17:42:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: And now for something _totally_ different: Linux v2.6.22-rc5
Message-ID: <20070618134233.GA265@tv-sign.ru>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org> <1182064500.2798.6.camel@entropy> <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com> <1182108399.3794.4.camel@entropy> <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Davide Libenzi wrote:
>
> On Sun, 17 Jun 2007, Nicholas Miell wrote:
> > 
> > But there's still no way for multiple threads to read from a single
> > signalfd and get their own thread-specific signals in addition to
> > process-wide signals, right? I think this was agreed to be the least
> > surprising behavior.
> 
> Multiple threads can wait on the signalfd. Each one will dequeue either 
> its own private signals (tsk->pending) or the process shared ones 
> (tsk->signal->shared_pending). This will be the behaviour once Ben's patch 
> is applied.

What if we pass a signalfd to another process with unix socket? Which signals
should be dequeued in that case? Only shared ones?

I tried to follow this discussion, but I can't understans why the current
behaviour is bad.

Yes, a thread has to create its own signalfd if it wants to dequeue private
signals. But this is simple and understandable. May be I missed something
else ?

Oleg.

