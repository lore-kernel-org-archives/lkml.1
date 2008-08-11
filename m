Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYHKO0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYHKO0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYHKOZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:25:57 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:37795 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbYHKOZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:25:56 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [RFC 0/1][PATCH] POSIX SCHED_SPORADIC implementation for tasks
	and	groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Dario Faggioli <raistlin@linux.it>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <48A0487B.7080600@redhat.com>
References: <1218462574.6450.24.camel@Palanthas>
	 <48A0487B.7080600@redhat.com>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 16:25:53 +0200
Message-Id: <1218464753.10800.92.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-11 at 07:11 -0700, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Dario Faggioli wrote:
> > I'm spending some time implementing the POSIX real-time SCHED_SPORADIC
> > scheduling policy on top of the mainline Linux kernel, and here it is
> > the code in its very first version.
> 
> I'm not commenting on the code or usefulness of ht features.  I just
> want to point out a problem.
> 
> The authors of that POSIX extension unfortunately decided to extend the
> sched_param structure.  If you look at the definition of that structure
> Linux uses you'll see that there is no place for this.  I.e., any
> implementation of that feature following the POSIX spec to the letter
> will introduce major headache in the form of binary incompatibility.
> 
> In case the features is useful enough (I actually always thought it
> isn't an have actually proposed to remove it again from POSIX) then I
> would rather prefer to not claim support for this feature in the POSIX
> way.  One could still implement it as described.  But change the
> interface to not require the sched_param change.

Whichever way you turn SCHED_SPORADIC or SCHED_EDF etc.. you'll need
some place to pass along extra data. The single int in sched_param is
not enough for these policies.

My suggestion would be to create struct sched_param2 with plenty of
padding to support future expansion and add
sys_sched_setscheduler2()/sys_sched_getscheduler2() to deal with this
new structure.

I think at least 3 struct timespec fields and a flags field might be
needed for the most exotic deadline parameters:

 - budget
 - deadline
 - period

My own take is that SCHED_SPORADIC is a nice excersice in scheduler
development - but I'm not sure its actually in demand from application
developers (those of you who actually write RT progs, please holler if
you care - I'm interested to hear your stories).

SCHED_EDF is in great demand - and is being worked on - albeit not as
much as I'd like to, due to me being too busy with other stuff atm :-/

