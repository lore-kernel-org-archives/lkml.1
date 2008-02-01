Return-Path: <linux-kernel-owner+w=401wt.eu-S934895AbYBAHv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934895AbYBAHv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965185AbYBAHpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:45:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934965AbYBAHpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:45:05 -0500
Subject: Re: [Regression] 2.6.24-git9: RT sched mishandles artswrapper
	(bisected)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200802010304.06703.rjw@sisk.pl>
References: <200802010237.59320.rjw@sisk.pl>
	 <200802010304.06703.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 08:44:56 +0100
Message-Id: <1201851896.32654.34.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-01 at 03:04 +0100, Rafael J. Wysocki wrote:
> On Friday, 1 of February 2008, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > This is related to the problem I reported earlier this week:
> > http://lkml.org/lkml/2008/1/30/554
> > 
> > Apparently artswrapper, run by KDE in openSUSE 10.3 with a real time priority,
> > is mishandled by the scheduler.  The problem is that after the user logs out,
> > artswrapper stays in TASK_RUNNING forever and prevents other tasks from being
> > scheduled on the CPU occupied by it.  In this state it also breaks suspend and
> > hibernation (it cannot be frozen).
> > 
> > Since the problem is 100% reproducible on my test boxes, I carried out a
> > bisection which turned out the following commit:
> > 
> > commit 6f505b16425a51270058e4a93441fe64de3dd435
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Fri Jan 25 21:08:30 2008 +0100
> > 
> >     sched: rt group scheduling
> > 
> > I'm now checking if the problem disappears after reverting this patch (along a
> > couple of dependent ones).
> 
> Yes, it does.
> 
> Please let me know what I can do to debug it further.

It arts run as root, or does it use RLIMIT_RTPRIO to allow users to
execute realtime tasks?



