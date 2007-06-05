Return-Path: <linux-kernel-owner+w=401wt.eu-S1763743AbXFEH17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763743AbXFEH17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763615AbXFEH1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:27:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:41737 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763576AbXFEH1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:27:48 -0400
Subject: Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other
	woes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1181023787.2785.14.camel@entropy>
References: <1181006711.31677.97.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
	 <1181009413.31677.117.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com>
	 <1181013756.31677.123.camel@localhost.localdomain>
	 <1181023787.2785.14.camel@entropy>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 17:27:33 +1000
Message-Id: <1181028453.31677.127.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 23:09 -0700, Nicholas Miell wrote:
> signalfd() doesn't deliver thread-targeted signals to the wrong
> threads,
> does it?
> 
> Hmm.
> 
> It looks like reading from a signalfd will give you either
> process-global signals or the thread-specific signals that are
> targeted
> towards the thread that originally created the signalfd (regardless of
> which thread actually calls read()).
> 
> Which is weird, to say the least. Definitely needs to be noted in the
> man page, which doesn't seem to exist yet.
> 
> Is there a reason why signalfd() doesn't behave like regular signals
> in
> this regard? 

It's worse than that ... by being able to call dequeue_signal from the
contxt of another thread than the one dequeuing from.

Ben.


