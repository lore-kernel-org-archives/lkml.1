Return-Path: <linux-kernel-owner+w=401wt.eu-S1763921AbXKQRq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763921AbXKQRq4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 12:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbXKQRqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 12:46:47 -0500
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:51151 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759577AbXKQRqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 12:46:46 -0500
Message-Id: <473EE1AE.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Sat, 17 Nov 2007 12:42:22 -0500
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Steven Rostedt" <rostedt@goodmis.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH v3 17/17] (Avoid overload)
References: <20071117062104.177779113@goodmis.org>
 <20071117062405.792778237@goodmis.org>
 <20071117063318.GA31442@goodmis.org>
In-Reply-To: <20071117063318.GA31442@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Sat, Nov 17, 2007 at  1:33 AM, in message
<20071117063318.GA31442@goodmis.org>, Steven Rostedt <rostedt@goodmis.org>
wrote: 

> Sorry!  I forgot to put in a prologue for this patch.
> 
> Here it is.
> 
> ====
> 
> This patch changes the searching for a run queue by a waking RT task
> to try to pick another runqueue if the currently running task
> is an RT task.
> 
> The reason is that RT tasks behave different than normal
> tasks. Preempting a normal task to run a RT task to keep
> its cache hot is fine, because the preempted non-RT task
> may wait on that same runqueue to run again unless the
> migration thread comes along and pulls it off.
> 
> RT tasks behave differently. If one is preempted, it makes
> an active effort to continue to run. So by having a high
> priority task preempt a lower priority RT task, that lower
> RT task will then quickly try to run on another runqueue.
> This will cause that lower RT task to replace its nice
> hot cache (and TLB) with a completely cold one. This is
> for the hope that the new high priority RT task will keep
>  its cache hot.
> 
> Remeber that this high priority RT task was just woken up.
> So it may likely have been sleeping for several milliseconds,
> and will end up with a cold cache anyway. RT tasks run till
> they voluntarily stop, or are preempted by a higher priority
> task. This means that it is unlikely that the woken RT task
> will have a hot cache to wake up to. So pushing off a lower
> RT task is just killing its cache for no good reason.

You make some excellent points here.  Out of curiosity, have you tried a comparison to see if it helps?

-Greg


