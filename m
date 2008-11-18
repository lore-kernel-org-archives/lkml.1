Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbYKROcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbYKROcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYKROc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:32:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37117 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYKROc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:32:27 -0500
Date: Tue, 18 Nov 2008 09:32:26 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: ftrace: preemptoff selftest not working
In-Reply-To: <20081118135221.GE31146@elte.hu>
Message-ID: <alpine.DEB.1.10.0811180931270.15003@gandalf.stny.rr.com>
References: <20081118125359.GA4417@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0811180826510.15003@gandalf.stny.rr.com> <20081118135221.GE31146@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Nov 2008, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > Hence the trace buffer will be empty. The patch below makes the 
> > > selftests working for me, since then they run in preemptible 
> > > context. But it is ugly and I'm not proposing it for upstream ;)
> > > 
> > > Just wanted to make you aware that there is a bug.
> > 
> > Yep, this might be a better answer than what I put into linux-tip 
> > (and my git repo).
> > 
> > See:
> > 
> >   ftrace: force pass of preemptoff selftest
> > 
> > The cause of the bug was the conversion of the BKL back to a 
> > spinlock, and making it non preempt.  The initcall code is called 
> > with the BKL applied which now means it can not preempt. This breaks 
> > the preempt tracer selftest.
> > 
> > My solution was to just force a pass if this is detected. Perhaps 
> > moving the test might be better.
> 
> it would be better to just drop the BKL in that selftest. (or in all 
> selftests - an elevated preempt count will skew a number of things)

I have no problem with that, but does the BKL play any role for being 
held? I have no idea why it is taken in boot up, so I'm hestiant to touch 
it.

-- Steve

