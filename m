Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbXCMR76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbXCMR76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 13:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbXCMR76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 13:59:58 -0400
Received: from gw.goop.org ([64.81.55.164]:36596 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbXCMR75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 13:59:57 -0400
Message-ID: <45F6E69B.9000602@goop.org>
Date: Tue, 13 Mar 2007 10:59:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: davids@webmaster.com
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
References: <MDEHLPKNGKAHNMBLJOLKMEJDCDAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKMEJDCDAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
> Good interactivity for tasks that aren't themselves CPU hogs. A task should
> get low latency if and only if it's yielding the CPU voluntarily most of the
> time. If it's not, it can only get better interactivity at the cost of
> fairness, and you have to *ask* for that. (Common sense says you can't give
> a task *more* CPU because it yields the CPU a lot. And how else do you
> determine interactivity other than nice level?)
>   

There's a distinction between giving it more cpu and giving it higher
priority: the important part about having high priority is getting low
latency access to the cpu when its needed.

> This scheduler will not give you greater interactivity at the cost of
> fairness unless you really ask for it. I think that's a good thing, though I
> do agree it might take some getting used to.
>   

This really seems like the wrong approach to me.  The implication here
and in other mails is that fairness is an inherently good thing which
should obviously take preference over any other property.

It's a nice simple stance, and its relatively easy to code up and test
to see that its working, but it doesn't really give people what they want.

The old unix-style dynamic priority scheme was designed to give
interactive processes high priorities, by using the observation that
"interactive" means "spends a lot of time blocked waiting for input". 
That model of interactive is way too simple now, and the attempts to try
an find an equivalent heuristic have been flawed and lead to - in some
cases - wildly bad behaviours.  I'm guessing the emphasis on "fairness"
is in reaction to this, which is fair enough.

But saying that the user needs to explicitly hold the schedulers hand
and nice everything to tell it how to schedule seems to be an abdication
of duty, an admission of failure.  We can't expect users to finesse all
their processes with nice, and it would be a bad user interface to ask
them to do so. 

And if someone/distro *does* go to all the effort of managing how to get
all the processes at the right nice levels, you have this big legacy
problem where you're now stuck keeping all those nice values meaningful
as you continue to develop the scheduler.  Its bad enough to make them
do the work in the first place, but its worse if they need to make it a
kernel version dependent function.

    J
