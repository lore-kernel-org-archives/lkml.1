Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZDTUo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZDTUo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbZDTUos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:44:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47631 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZDTUor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:44:47 -0400
Date: Mon, 20 Apr 2009 16:44:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] [GIT PULL] tracing: recursion and compile fixes
In-Reply-To: <20090420203347.GD5974@nowhere>
Message-ID: <alpine.DEB.2.00.0904201641570.10097@gandalf.stny.rr.com>
References: <20090420173819.957332585@goodmis.org> <20090420175533.GA22449@elte.hu> <20090420192803.GA25629@elte.hu> <20090420194542.GB5974@nowhere> <alpine.DEB.2.00.0904201616430.10097@gandalf.stny.rr.com> <20090420203347.GD5974@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 20 Apr 2009, Frederic Weisbecker wrote:
> > > 
> > 
> > Hmm, doesn't the trace wakeup test if the runqueue lock is locked or not?
> > 
> > -- Steve
> > 
> 
> 
> Hmm, yes it does but that's not the first time we meet this problem
> (sched switch event tracing recursions by the past). So either the
> test doesn't work well or this is about another lock that
> wake_up_common takes...

Ug, it is the task's rq lock. Not the current rq lock. wakeup takes the 
runqueue lock of the task. The "runqueue_is_locked" only tests the lock of 
current CPU, which is not what we can have.

Thus, the function tracer (gag, and probably the event tracing!) should 
not call wakeups.

-- Steve

