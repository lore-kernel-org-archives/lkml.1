Return-Path: <linux-kernel-owner+w=401wt.eu-S2993385AbXEBPig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993385AbXEBPig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993386AbXEBPig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:38:36 -0400
Received: from www.osadl.org ([213.239.205.134]:52056 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993385AbXEBPif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:38:35 -0400
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of
	CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Lord <lkml@rtr.ca>, Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20070502010527.e64dcce9.akpm@linux-foundation.org>
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>
	 <463653A3.5040606@rtr.ca> <46367D7E.6060502@rtr.ca>
	 <1177976798.12796.286.camel@imap.mvista.com> <463683A6.4010505@rtr.ca>
	 <1178026458.5791.305.camel@localhost.localdomain> <4637419D.8010303@rtr.ca>
	 <463741F1.7050706@rtr.ca> <1178027285.5791.307.camel@localhost.localdomain>
	 <46374B1D.6050509@rtr.ca> <1178035058.5791.333.camel@localhost.localdomain>
	 <46377055.2060605@rtr.ca> <1178092035.5791.349.camel@localhost.localdomain>
	 <20070502010527.e64dcce9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 02 May 2007 17:40:57 +0200
Message-Id: <1178120457.25504.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-02 at 01:05 -0700, Andrew Morton wrote:
> > thanks. Can you apply this patch please:
> > http://lkml.org/lkml/2007/4/13/190
> >
> > It somehow did not make it into 2.6.21.
> > 
> 
> Alas, poor me.  I ain't going to merge a contention-reduction patch when
> we're at -rc6.  If a patch fixes a bug, please tell me!

It was not a bug fix at this point, I merily tried to solve the lock
contention problem, which was reported by Steven Rostedt.

The confusing thing on Marks config bisecting was that the softlock
detection fixed his problem. The only difference of the softlock
detection is that it starts the watchdog thread and a one second timer.
I was looking into the code and noticed that this patch did not make it.

Honestly it was a shot into the dark and I'd really like to know why
this makes the problem go away.

Mark, did you ever enable CONFIG_PROVE_LOCKING as a single add on to
your not working config ? If not, can you please try ?

	tglx


