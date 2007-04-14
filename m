Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbXDNRys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbXDNRys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 13:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXDNRys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 13:54:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60184 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbXDNRyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 13:54:47 -0400
Date: Sat, 14 Apr 2007 19:54:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Willy Tarreau <w@1wt.eu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414175433.GA17527@elte.hu>
References: <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070414132732.GA22103@1wt.eu> <20070414161927.GD3099@elte.hu> <m1abxanahn.fsf@ebiederm.dsl.xmission.com> <20070414172920.GA2433@1wt.eu> <m1647yn956.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1647yn956.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> > Thinking about it, I don't know if there are calls to schedule() 
> > while switching from tty1 to tty2. Alt-F2 had no effect anymore, and 
> > "chvt 2" simply blocked. It would have been possible that a 
> > schedule() call somewhere got starved due to the load, I don't know.
> 
> It looks like there is a call to schedule_work.

so this goes over keventd, right?

> There are two pieces of the path. If you are switching in and out of a 
> tty controlled by something like X.  User space has to grant 
> permission before the operation happens.  Where there isn't a gate 
> keeper I know it is cheaper but I don't know by how much, I suspect 
> there is still a schedule happening in there.

Could keventd perhaps be starved? Willy, to exclude this possibility, 
could you perhaps chrt keventd to RT priority? If events/0 is PID 5 then 
the command to set it to SCHED_FIFO:50 would be:

  chrt -f -p 50 5

but ... events/0 is reniced to -5 by default, so it should definitely 
not be starved.

	Ingo
