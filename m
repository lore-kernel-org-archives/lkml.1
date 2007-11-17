Return-Path: <linux-kernel-owner+w=401wt.eu-S1765996AbXKQSzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765996AbXKQSzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbXKQSzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:55:44 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:33819 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626AbXKQSzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:55:44 -0500
Date: Sat, 17 Nov 2007 13:55:11 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH v3 17/17] (Avoid overload)
In-Reply-To: <473EE1AE.BA47.005A.0@novell.com>
Message-ID: <Pine.LNX.4.58.0711171353030.12054@gandalf.stny.rr.com>
References: <20071117062104.177779113@goodmis.org> <20071117062405.792778237@goodmis.org>
 <20071117063318.GA31442@goodmis.org> <473EE1AE.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 17 Nov 2007, Gregory Haskins wrote:

> >>> On Sat, Nov 17, 2007 at  1:33 AM, in message
> > This patch changes the searching for a run queue by a waking RT task
> > to try to pick another runqueue if the currently running task
> > is an RT task.
> >
> > The reason is that RT tasks behave different than normal
> > tasks. Preempting a normal task to run a RT task to keep
> > its cache hot is fine, because the preempted non-RT task
> > may wait on that same runqueue to run again unless the
> > migration thread comes along and pulls it off.
> >
> > RT tasks behave differently. If one is preempted, it makes
> > an active effort to continue to run. So by having a high
> > priority task preempt a lower priority RT task, that lower
> > RT task will then quickly try to run on another runqueue.
> > This will cause that lower RT task to replace its nice
> > hot cache (and TLB) with a completely cold one. This is
> > for the hope that the new high priority RT task will keep
> >  its cache hot.
> >
> > Remeber that this high priority RT task was just woken up.
> > So it may likely have been sleeping for several milliseconds,
> > and will end up with a cold cache anyway. RT tasks run till
> > they voluntarily stop, or are preempted by a higher priority
> > task. This means that it is unlikely that the woken RT task
> > will have a hot cache to wake up to. So pushing off a lower
> > RT task is just killing its cache for no good reason.
>
> You make some excellent points here.  Out of curiosity, have you tried a comparison to see if it helps?

hehe, I was waiting for the "where's the numbers". Right now I don't have
them. Mainly because I don't have boxes with more that 4 CPUs on them. And
4 really doesn't make much of a difference.

If others out there would like to test, I'll write up a couple of versions
of this code and that way we can really get numbers for them.

Or perhaps someone would like to send me a 16way box. Although my wife
would kill me. ;-)

Hmm, I'm sure I can get to our lab and run some tests too.

-- Steve

