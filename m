Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYKXTMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYKXTMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYKXTMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:12:12 -0500
Received: from vpnflf.ccur.com ([12.192.68.2]:30411 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751904AbYKXTML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:12:11 -0500
Date: Mon, 24 Nov 2008 14:11:43 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] create /proc/timer-wheel-list
Message-ID: <20081124191143.GA24281@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20081121221113.GA13566@tsunami.ccur.com> <20081122173423.GC2748@x200.localdomain> <20081123015923.GA26478@tsunami.ccur.com> <20081123100424.GW30453@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123100424.GW30453@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 05:04:24AM -0500, Ingo Molnar wrote:
> 
> * Joe Korty <joe.korty@ccur.com> wrote:
> 
> > On Sat, Nov 22, 2008 at 12:34:23PM -0500, Alexey Dobriyan wrote:
> > > On Fri, Nov 21, 2008 at 05:11:13PM -0500, Joe Korty wrote:
> > > > Create /proc/timer_wheel_list.
> > > >
> > > > This does for the timer wheel what /proc/timer_list
> > > > does for hrtimers -- provide a way of displaying what
> > > > timers are running on what cpus, and their attributes.
> > >
> > > The fact that it's called a timer wheel is just an implementation detail
> > > unsuitable for permanent file.
> >
> > Agreed.  I'll come up with something else.  lrtimer_list is a good
> > candidate.
> 
> no - please include it in /proc/timer_list instead. It already lists
> clockevents and hrtimers - listing timer-list timers would be a
> natural extension of that facility.

struct tvec_base and TVR_MASK & family are all local
to kernel/timers.c rather than in some header file,
so parts of the display code would need to remain in
kernel/timers.c.  Seems ugly, but is of course do-able.

Also, I am not sure why we are lumping all sorts of
disparate things in one display file.  Did proc files
become expensive somewhere along the line?

(Just asking before I go down a path that everyone will
hate, once they see the result).

Regards,
Joe
