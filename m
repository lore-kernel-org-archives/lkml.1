Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbYKWB7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbYKWB7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 20:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbYKWB7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 20:59:38 -0500
Received: from vpnflf.ccur.com ([12.192.68.2]:39721 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754410AbYKWB7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 20:59:37 -0500
Date: Sat, 22 Nov 2008 20:59:23 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] create /proc/timer-wheel-list
Message-ID: <20081123015923.GA26478@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20081121221113.GA13566@tsunami.ccur.com> <20081122173423.GC2748@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081122173423.GC2748@x200.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 12:34:23PM -0500, Alexey Dobriyan wrote:
> On Fri, Nov 21, 2008 at 05:11:13PM -0500, Joe Korty wrote:
> > Create /proc/timer_wheel_list.
> >
> > This does for the timer wheel what /proc/timer_list
> > does for hrtimers -- provide a way of displaying what
> > timers are running on what cpus, and their attributes.
> 
> The fact that it's called a timer wheel is just an implementation detail
> unsuitable for permanent file.

Agreed.  I'll come up with something else.  lrtimer_list is
a good candidate.

> And you invented totally new (broken) way to print jiffies.

You'll have to be more explicit about what's broken.  

> For printing nice function pointers we have %pF now.

I'll go play with that again.  IIRC, the first
time I played with it, it's output was of the form
'symbol+0xoffset/0xsize' rather than just 'symbol'.

> late_initcall usage is taken out of air.

I'm open to suggestions.  My thought was that it was as
good as any other initcall, since none of this stuff can
be referenced until after applications start running off
of /sbin/init.  So what one picks is a bit of a crapshoot.

> Can we put all this shit in debugfs, please?

I kinda like the debugfs idea.  Though there is
some attraction to making it parallel to the existing
/proc/timer_list, rather than putting it somewhere else
entirely.

I can see a migration path here .. put lrtimers_list in
debugfs, later move /proc/timers_list to debugfs (perhaps
as hrtimers_list) and make /proc/timers_list itself a
symbolic link to the debugfs version.

Regards,
Joe
