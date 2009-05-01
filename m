Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbZEAXoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbZEAXoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 19:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZEAXnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 19:43:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZEAXnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 19:43:51 -0400
Date: Fri, 1 May 2009 19:43:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 1/2]  ftrace: add notrace to ARM sched_clock routines
In-Reply-To: <20090501233744.GF6404@nowhere>
Message-ID: <alpine.DEB.2.00.0905011942390.20374@gandalf.stny.rr.com>
References: <49FB77ED.3010800@am.sony.com> <20090501233744.GF6404@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2 May 2009, Frederic Weisbecker wrote:
> >  }
> > @@ -203,7 +203,7 @@ static struct clocksource clocksource_32
> >   * Returns current time from boot in nsecs. It's OK for this to wrap
> >   * around for now, as it's just a relative time stamp.
> >   */
> > -unsigned long long sched_clock(void)
> > +unsigned long long notrace sched_clock(void)
> >  {
> >  	unsigned long long ret;
> 
> 
> I've looked into all of these functions and they don't seem to call
> anything that could be traced. I could have missed something though
> but it looks good.

I think the issue is that the tracing clock will call these functions, and 
we will waste time recursing into them.

> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Heck I'll add mine too ;-)

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

