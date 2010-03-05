Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0CESoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:44:16 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41789 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab0CESoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:44:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S0uUW6yf1Gy5kVoEFB0LDyEoFAE2ptPxlA1uMd2YH8wzL9vJGrJ1MBRLTmEvOxPcMW
         X5AbRcYsfzxHO7WcTegVasQ1GIWxN/b29f/lMOHuoEI6wHZLBW+u20N6go5YWkbLEIeZ
         ltQDDZWUJTJQX1ItybpAT/N72nL3fp0ksqxG4=
Date: Fri, 5 Mar 2010 19:43:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.33: ftrace triggers soft lockup
Message-ID: <20100305184358.GG5244@nowhere>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com> <1267710847.10871.102.camel@gandalf.stny.rr.com> <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com> <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com> <1267801603.10871.1725.camel@gandalf.stny.rr.com> <20100305171614.GC5244@nowhere> <1267814100.10871.1780.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267814100.10871.1780.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 01:35:00PM -0500, Steven Rostedt wrote:
> On Fri, 2010-03-05 at 18:16 +0100, Frederic Weisbecker wrote:
> 
> > It's true it has a high overhead, but not to the point of
> > making the whole system unusable. We are supposed to be even
> > far from that. I'm currently able to turn on the function graph
> > tracer and use firefox without problems. It's just a bit slower
> > but it's far from a visible starvation.
> > 
> > And Li seems to see the same thing.
> > For now I can not test, but I will try this week-end.
> 
> Americo said he's seen the issue as far back as 2.6.32. So perhaps some
> CPUs take a bigger hit from the function graph tracer than others. I
> have several different boxes that I can try. I've seen noticeable slow
> downs but never something that cripples the box.
> 
> The only time that I've seen it cripple the box is when LOCKDEP_DEBUG
> was set (which according to Americo's config it was not). But that's
> because LOCKDEP_DEBUG updates a global variable every time interrupts
> are enabled or disabled. This caused a huge cache line bouncing with the
> function graph tracer since it caused this variable to be updated 4
> times for every function call!



Ouch...that's the hardirqs_off_events/redundant_hardirqs_off variables?
Those should be clearly made per cpu.

