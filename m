Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbXDNST2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbXDNST2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 14:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbXDNST2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 14:19:28 -0400
Received: from 1wt.eu ([62.212.114.60]:1894 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbXDNST1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 14:19:27 -0400
Date: Sat, 14 Apr 2007 20:18:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414181854.GA5826@1wt.eu>
References: <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070414132732.GA22103@1wt.eu> <20070414161927.GD3099@elte.hu> <m1abxanahn.fsf@ebiederm.dsl.xmission.com> <20070414172920.GA2433@1wt.eu> <m1647yn956.fsf@ebiederm.dsl.xmission.com> <20070414175433.GA17527@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414175433.GA17527@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 07:54:33PM +0200, Ingo Molnar wrote:
> 
> * Eric W. Biederman <ebiederm@xmission.com> wrote:
> 
> > > Thinking about it, I don't know if there are calls to schedule() 
> > > while switching from tty1 to tty2. Alt-F2 had no effect anymore, and 
> > > "chvt 2" simply blocked. It would have been possible that a 
> > > schedule() call somewhere got starved due to the load, I don't know.
> > 
> > It looks like there is a call to schedule_work.
> 
> so this goes over keventd, right?
> 
> > There are two pieces of the path. If you are switching in and out of a 
> > tty controlled by something like X.  User space has to grant 
> > permission before the operation happens.  Where there isn't a gate 
> > keeper I know it is cheaper but I don't know by how much, I suspect 
> > there is still a schedule happening in there.
> 
> Could keventd perhaps be starved? Willy, to exclude this possibility, 
> could you perhaps chrt keventd to RT priority? If events/0 is PID 5 then 
> the command to set it to SCHED_FIFO:50 would be:
> 
>   chrt -f -p 50 5
> 
> but ... events/0 is reniced to -5 by default, so it should definitely 
> not be starved.

Well, since I merged the fair-fork patch, I cannot reproduce (in fact,
bash forks 1000 processes, then progressively execs scheddos, but it
takes some time). So I'm rebuilding right now. But I think that Linus
has an interesting clue about GPM and notification before switching
the terminal. I think it was enabled in console mode. I don't know
how that translates to frozen xterms, but let's attack the problems
one at a time.

Willy

