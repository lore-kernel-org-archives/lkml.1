Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbYAZNsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbYAZNsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 08:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYAZNsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 08:48:45 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:63468 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbYAZNso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 08:48:44 -0500
Date: Sat, 26 Jan 2008 08:48:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/23 -v6] printk - dont wakeup klogd with interrupts
 disabled
In-Reply-To: <Pine.LNX.4.58.0801260804230.16244@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.58.0801260846300.16244@gandalf.stny.rr.com>
References: <20080126042152.526086719@goodmis.org>  <20080126042801.280369398@goodmis.org>
  <20080126091015.GA1794@elf.ucw.cz> <1201341126.27573.20.camel@lappy>
 <Pine.LNX.4.58.0801260804230.16244@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 26 Jan 2008, Steven Rostedt wrote:
> Correct. The only race that this patch has is that there's a slight chance
> you wont wake up the klogd when you could.
>
>   CPU0 						CPU1
>
> 					locks_runqueue(cpu0)
>
>   if (!runqueue_is_locked())
>      [fails and klogd not woken]
>
>
> But this is rare and pretty harmless. But it can be trivally fixed and
> should be. But I'll rename the API to
>
>    current_has_runqueue_lock()
>
> This way we know exactly why it returns what it returns.

Hmm, I'm thinking too much about RT where we can see who owns the locks.
It isn't trivial to see if current has the lock without putting in more
logic into the taking of the rq lock, which is unneeded overhead.

I think the patch as is is good enough then. The worst that can happen is
that we don't wake up klogd, and that should not be too often.

-- Steve

