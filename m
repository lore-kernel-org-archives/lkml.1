Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753224AbYLRMCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbYLRMCQ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYLRMB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:01:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40028 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbYLRMB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:01:58 -0500
Date: Thu, 18 Dec 2008 13:01:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: trace: fix task state printout
Message-ID: <20081218120140.GC21123@elte.hu>
References: <alpine.LFD.2.00.0812172229490.3492@localhost.localdomain> <alpine.DEB.1.10.0812171727160.4839@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812171727160.4839@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 17 Dec 2008, Thomas Gleixner wrote:
> 
> > Impact: tracer task state decoding is wrong, size check is buggy
> 
> The Imact line seems more of a subject line. The real Impact line should 
> be something like:
> 
> Impact: fix wrong decoding of task state int tracer
> 
> Keyword is 'fix'
> 
> > 
> > The tracing code has interesting varieties of printing out task state. 
> > Unfortunalely only one of the instances is correct as it copies the 
> > code from sched.c:sched_show_task(). The others are plain wrong as 
> > they treatthe bitfield as an integer offset into the character array. 
> > Also the size check of the character array is wrong as it includes the 
> > trailing \0.
> > 
> > Use a common state decoder inline which does the Right Thing.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>
> 
> Ingo, this is a low risk fix that probably should be pushed towards 
> Linus for inclusion into 2.6.28.

ok, we can do that after a few days of testing.

Btw., note that when capturing traces via trace_pipe, i still see frequent 
mistakes of PIDs being matched up to the wrong 'comm' string

 loop-1sec-2895 ...
      Xorg-2895 ...

the Xorg-2895 is bogus. I have been seeing these for a long time and 
thought we fixed it, but i noticed them yesterday once more, while i was 
tracing some code. Any ideas about what's wrong there?

	Ingo
