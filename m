Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbZEAXy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbZEAXy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 19:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZEAXyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 19:54:19 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:57453 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbZEAXyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 19:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LRAE5atsiLXFFFHDedH7U1PPidEDo+mS/pWhfNPRUG3KrHwxT4IPhsPZrGMCosSam1
         xnFPNlK/VtJat9n+1Y6/eS1B5GkJrXm7CgJWEXK0r2bPsfYkD/10FLa4o2Ust1vzoCP4
         8NfD0+OkKA/NkYUZ///eYG8n6Q1msTUW2lrkU=
Date: Sat, 2 May 2009 01:54:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 1/2]  ftrace: add notrace to ARM sched_clock routines
Message-ID: <20090501235414.GG6404@nowhere>
References: <49FB77ED.3010800@am.sony.com> <20090501233744.GF6404@nowhere> <alpine.DEB.2.00.0905011942390.20374@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905011942390.20374@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 07:43:50PM -0400, Steven Rostedt wrote:
> 
> On Sat, 2 May 2009, Frederic Weisbecker wrote:
> > >  }
> > > @@ -203,7 +203,7 @@ static struct clocksource clocksource_32
> > >   * Returns current time from boot in nsecs. It's OK for this to wrap
> > >   * around for now, as it's just a relative time stamp.
> > >   */
> > > -unsigned long long sched_clock(void)
> > > +unsigned long long notrace sched_clock(void)
> > >  {
> > >  	unsigned long long ret;
> > 
> > 
> > I've looked into all of these functions and they don't seem to call
> > anything that could be traced. I could have missed something though
> > but it looks good.
> 
> I think the issue is that the tracing clock will call these functions, and 
> we will waste time recursing into them.


Indeed, but I wanted to ensure that none of these sched_clock() were calling
any traceable function, or it would recurse inside the function graph
low level helpers which are not protected. Hence an endless stack overrun which
ends up on an immediate reboot :)

But it looks good.
 
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Heck I'll add mine too ;-)
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> -- Steve
> 

