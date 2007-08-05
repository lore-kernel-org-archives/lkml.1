Return-Path: <linux-kernel-owner+w=401wt.eu-S1761077AbXHEOYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077AbXHEOYd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 10:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbXHEOY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 10:24:26 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:50964 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbXHEOYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 10:24:25 -0400
Date: Sun, 5 Aug 2007 10:24:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG  RT] - rcupreempt.c:133 on 2.6.23-rc1-rt7
In-Reply-To: <20070805065948.GB515@elte.hu>
Message-ID: <Pine.LNX.4.58.0708051019560.8421@gandalf.stny.rr.com>
References: <1186289484.636.5.camel@localhost.localdomain>
 <1186290332.636.8.camel@localhost.localdomain> <20070805065948.GB515@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--

On Sun, 5 Aug 2007, Ingo Molnar wrote:

>
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > > I don't have time to look further now, and it's something that isn't
> > > easily reproducible (Well, it happened once out of two boots). If
> > > you need me to look further, or need a config or dmesg (I have
> > > both), then just give me a holler.
> >
> > Silly me. FYI, I was running with !PREEMPT_RT, but with Hard and
> > Softirqs as threads.  Must have copied the wrong config over :-/
>
> it's still not supposed to happen ... rcu read lock nesting that deep?
>

The code on line 133 is:

	WARN_ON_ONCE(current->rcu_read_lock_nesting > NR_CPUS);

I have NR_CPUS set to 2 since the box I'm running this on only has
2 cpus and I see no reason to waste more data structures.

Is rcu read lock nesting deeper than 2?

-- Steve

