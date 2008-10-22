Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbYJVOHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbYJVOHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYJVOGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:06:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:50311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbYJVOGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:06:54 -0400
Date: Wed, 22 Oct 2008 07:07:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: deep power-saving states
Message-ID: <20081022070701.567f1c9a@infradead.org>
In-Reply-To: <48FF3321.4060809@novell.com>
References: <48FF2DDC.5010600@gmail.com>
	<20081022064738.05818670@infradead.org>
	<48FF3321.4060809@novell.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 10:05:21 -0400
Gregory Haskins <ghaskins@novell.com> wrote:

> Arjan van de Ven wrote:
> > On Wed, 22 Oct 2008 09:42:52 -0400
> > Gregory Haskins <gregory.haskins.ml@gmail.com> wrote:
> >
> >   
> >> What I was thinking is that a simple mechanism to quantify the
> >> power-state penalty would be to add those states as priority
> >> levels in the cpupri namespace.  E.g. We could substitute
> >> IDLE-RUNNING for IDLE, and add IDLE-PS1, IDLE-PS2, .. IDLE-PSn,
> >> OTHER, RT1, .. RT99.  This means the scheduler would favor waking
> >> an IDLE-RUNNING core over an IDLE-PS1-PSn, etc.  The question in
> >> my mind is: can the power-states be determined in a static fashion
> >> such that we know what value to quantify the idle state before we
> >> enter it?  Or is it more dynamic (e.g. the longer it is in an
> >> MWAIT, the deeper the sleep gets). 
> >
> > it's a little dynamic, but just assuming the worst will be a very
> > good approximation of reality. And we know what we're getting into
> > in that sense.
> >   
> 
> Ok, but if we just assume the worst case always, how do I
> differentiate between, say, IDLE-RUNNING and IDLE-PSn?  If I assign
> them all to IDLE-PSn apriori its no better than the basic single IDLE
> state we support today.  Or am I misunderstanding you?

eh yes I wasn't very clear; it's pre-coffee time here ;)

we know *for each C state* we go in, what its maximum latency is.
Now, that is the *maximum*; there are times where it'll be less
(there are several steps for going into a C-state hardware wise, and if
an interrupt comes in before they're all completed, getting out of it
means not having to undo ALL the steps, so it'll be faster)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
