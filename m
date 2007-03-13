Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbXCMT6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbXCMT6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXCMT6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:58:39 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1411 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041AbXCMT6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:58:38 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <jeremy@goop.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Tue, 13 Mar 2007 12:58:01 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIELACDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <45F6E69B.9000602@goop.org>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 13 Mar 2007 11:58:18 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 13 Mar 2007 11:58:18 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> There's a distinction between giving it more cpu and giving it higher
> priority: the important part about having high priority is getting low
> latency access to the cpu when its needed.

I agree. Tasks that voluntarily relinquish their timeslices should get lower
latency compared to other processes at the same static priority.

> This really seems like the wrong approach to me.  The implication here
> and in other mails is that fairness is an inherently good thing which
> should obviously take preference over any other property.

Yes, that is the implication. The alternative to fairness is arbitrary
unfairness. "Rational unfairness" is a form of fairness.

> The old unix-style dynamic priority scheme was designed to give
> interactive processes high priorities, by using the observation that
> "interactive" means "spends a lot of time blocked waiting for input".
> That model of interactive is way too simple now, and the attempts to try
> an find an equivalent heuristic have been flawed and lead to - in some
> cases - wildly bad behaviours.  I'm guessing the emphasis on "fairness"
> is in reaction to this, which is fair enough.

I don't think it makes sense for the scheduler to look for some hint that
the user would prefer a task to get more CPU and try to give it more. That's
what 'nice' is for.

> But saying that the user needs to explicitly hold the schedulers hand
> and nice everything to tell it how to schedule seems to be an abdication
> of duty, an admission of failure.  We can't expect users to finesse all
> their processes with nice, and it would be a bad user interface to ask
> them to do so.

Then you will always get cases where the scheduler does not do what the user
wants because the scheduler does not *know* what the user wants. You always
have to tell a computer what you want it to do, and the best it can do is
faithfully follow your request.

I think it's completely irrational to ask for a scheduler that automatically
gives more CPU time to CPU hogs.

> And if someone/distro *does* go to all the effort of managing how to get
> all the processes at the right nice levels, you have this big legacy
> problem where you're now stuck keeping all those nice values meaningful
> as you continue to develop the scheduler.  Its bad enough to make them
> do the work in the first place, but its worse if they need to make it a
> kernel version dependent function.

I agree. I'm not claiming to have the perfect solution. Let's not let the
perfect be the enemy of the good though.

DS


