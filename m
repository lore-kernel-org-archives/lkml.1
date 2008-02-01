Return-Path: <linux-kernel-owner+w=401wt.eu-S1764668AbYBACGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764668AbYBACGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 21:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbYBACG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 21:06:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56417 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbYBACGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 21:06:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Regression] 2.6.24-git9: RT sched mishandles artswrapper (bisected)
Date: Fri, 1 Feb 2008 03:04:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200802010237.59320.rjw@sisk.pl>
In-Reply-To: <200802010237.59320.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802010304.06703.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 of February 2008, Rafael J. Wysocki wrote:
> Hi,
> 
> This is related to the problem I reported earlier this week:
> http://lkml.org/lkml/2008/1/30/554
> 
> Apparently artswrapper, run by KDE in openSUSE 10.3 with a real time priority,
> is mishandled by the scheduler.  The problem is that after the user logs out,
> artswrapper stays in TASK_RUNNING forever and prevents other tasks from being
> scheduled on the CPU occupied by it.  In this state it also breaks suspend and
> hibernation (it cannot be frozen).
> 
> Since the problem is 100% reproducible on my test boxes, I carried out a
> bisection which turned out the following commit:
> 
> commit 6f505b16425a51270058e4a93441fe64de3dd435
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Jan 25 21:08:30 2008 +0100
> 
>     sched: rt group scheduling
> 
> I'm now checking if the problem disappears after reverting this patch (along a
> couple of dependent ones).

Yes, it does.

Please let me know what I can do to debug it further.

Thanks,
Rafael
