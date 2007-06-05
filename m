Return-Path: <linux-kernel-owner+w=401wt.eu-S1762946AbXFEDWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762946AbXFEDWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 23:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbXFEDWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 23:22:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:48704 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130AbXFEDWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 23:22:43 -0400
Subject: Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other
	woes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com>
References: <1181006711.31677.97.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
	 <1181009413.31677.117.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 13:22:36 +1000
Message-Id: <1181013756.31677.123.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 19:38 -0700, Davide Libenzi wrote:
> >  - I still think there's something wrong with dequeue_signal() being
> > potentially called with a task different than current by signalfd, since
> > __dequeue_signal() (among others) mucks around with current regardless.
> > I'd love to just make signalfd's read() only do anything if current ==
> > ctx->tsk and remove the task argument from dequeue_signal... that would
> > fix it nicely too no ?
> 
> There's got to be a clean solution that does not limit signalfd, no? I 
> have no time to look at it immediately, but I can look into it in the 
> next few days, if someone else does not do it before...

Is there a real usage to dequeuing somebody else signals with signalfd ?
If yes, then we can do something around the lines of passing task down
to __dequeue_signal, though I'm not too sure waht this notifier is about
and wether it might rely on being called from within the affected task
context...

Ben.


