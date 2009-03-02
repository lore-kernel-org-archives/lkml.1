Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZCBWKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZCBWKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZCBWKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:10:30 -0500
Received: from n28.bullet.mail.mud.yahoo.com ([68.142.206.223]:31722 "HELO
	n28.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754309AbZCBWK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:10:29 -0500
X-Yahoo-Newman-Id: 845999.71097.bm@omp412.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uGEzKIdgkNob59g8nC0dKZCJCJQxs52FJoOqs8M4APw3GOD9faaLRVWENsHU0wkEVrkFKjm7MAuA7TOG7KMvZfi1ksST9Z61eR0pB81VxwccAypNB7Ip02O6pGiUy6iK8rTs/X+vdN2a60FM1TnjHIL/R3NDpFFvUEK/T5gqLmA=  ;
X-YMail-OSG: imMBTgUVM1lIaef5fSfws2NBEyxBeCjHVEoHAJEEubhU34QuWALL6XEWx5lPYUep6N5ZfryiwQCO1hOkV9QNWMWvfF8HtdXprHMIIb5yVKVbVERdZvoTc1hRjPeUnkBJ6dixvuGOZ54Dyvpy.1z.ysLtYN_hr8W.RqQuiE2IdG.ht18u3GQK0DrbnMqt
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Mon, 2 Mar 2009 14:10:25 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902271518.58246.david-b@pacbell.net> <1235999770.5330.367.camel@laptop>
In-Reply-To: <1235999770.5330.367.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021410.25889.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Peter Zijlstra wrote:
> On Fri, 2009-02-27 at 15:18 -0800, David Brownell wrote:
> > 
> > This stuff just pokes at some annoying current gaps in the
> > IRQ framework.  I'll be glad when eventually there's no
> > need to work around those weaknesses ... that is, when
> > real threaded IRQ support is available.
> 
> Its unfortunate that you prefer these dinky little hacks over
> helping out providing whatever infrastructure you need.

That's an unfair and unreasonable criticism.  You don't
know what I "prefer", or how much time I have to "help"
with.  Plus, you discount the work involved in actually
tracking down root causes ... and your evaluation of at
least this issue is biased.

What's unfortunate is that you prefer not to fix that
IRQF_DISABLED bug in lockdep, which you co-"maintain".
When running with lockdep, that bug (a) introduces bugs
in some drivers and (b) hides bugs in others.  You've
rejected even a minimal warning fix, to help minimize
the amount of time developers waste on (a) and (b).

Attacking folk for having to cope with such bugs escalates
things beyond "unfortunate".  If lockdep is "maintained",
your response should be fixing that lockdep bug.  Once
that's done, all workarounds for that bug can be removed.


> There's plenty good reasons for mandating that irq handlers run with
> irqs disabled, if you need threaded handlers -- that's fine, but then
> teach the generic code about them.

There are many ways to "teach" such things, of course,
and the learning goes both ways ... the initial set of
perceived requirements changes when 

And since there have been folk at work on such issues for
some time, I'm not sure why you think I shouldn't give
them a fair chance to deliver, and help improve those
(long anticipated) solutions.  There's a saying that
"too many cooks spoil the broth"; and in software, it's
well known that extra developers aren't necessarily any
kind of help.


> What you do _NOT_ do is hack your way around things, that's not how
> Linux works, and by doing that you make the world a slightly worse place
> for everyone.

Linux has lots of bug workarounds and odd constraints, like
any other large system does.  The "world" is full of them;
DNA-coded machinery is felt to consist *mostly* of them.
(And many folk argue that monoculture is dangerous...)

The sign of a bad workaround is that it sits in core code
and impacts everything using it.  Like, oh, that lockdep
bug, preventing various systems from ever using it because
they rely on mechanisms broken by that bug.


On the other hand, the main valid complaint about one-line
workarounds is needing them at all.  Boiling down a system
misbehavior to a one-line workaround *IS* a way to help
make the (kernel) world a better place, by fingerpointing
a real issue ... setting trail markers for a better way.

In this case there's a real bug in the lockdep code.

The recent threaded IRQ proposal moves some support down
a layer (into genirq) and generalizes it a bit, but some
drivers (e.g. I2C ones) have threaded IRQs for a long time
now -- out of necessity, not just performance tweaking.

- Dave

