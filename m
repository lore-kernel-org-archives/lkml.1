Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYBFVok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYBFVok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYBFVod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:44:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46901 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYBFVoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:44:32 -0500
Subject: Re: [Regression] 2.6.24-git9: RT sched mishandles artswrapper
	(bisected)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <200802061925.19474.rjw@sisk.pl>
References: <200802010237.59320.rjw@sisk.pl>
	 <b647ffbd0802060040wbfe16afq4355e8f4f31ab06b@mail.gmail.com>
	 <1202288548.19243.47.camel@lappy>  <200802061925.19474.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 22:43:48 +0100
Message-Id: <1202334228.6274.1.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-06 at 19:25 +0100, Rafael J. Wysocki wrote:
> On Wednesday, 6 of February 2008, Peter Zijlstra wrote:
> > 
> > On Wed, 2008-02-06 at 09:40 +0100, Dmitry Adamushko wrote:
> > > On 06/02/2008, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Tuesday, 5 of February 2008, Dmitry Adamushko wrote:
> > > > > Rafael, any progress with this issue? (a few questions below).
> > > > >
> > > > > > >
> > > > > > > Does this artsmessage thing also run with RT priority?
> > > > > >
> > > > > > Well, it's in a strange state (after it's broken).  From top:
> > > > > >
> > > > > > PR = -51
> > > > > > NI = 0
> > > > > > S = R
> > > > > > %CPU = 0.0
> > > > > > %MEM = 0.0
> > > > >
> > > > > cat /proc/$PID/stat ; sleep 3; cat /proc/$PID/stat ?
> > > > > cat /proc/sched_debug; sleep 3 ; cat /proc/sched_debug
> > > >
> > > > Well, instead please find appended a test program that allows me to trigger
> > > > the issue.
> > > 
> > > Great, I'll look at this problem in the everning (sure, if nobody else
> > > is faster :-).
> > 
> > Yeah, it seems fixed here (after I made my current queue compile for
> > this silly CONFIG_USER_SCHED thing again).
> > 
> > I'm now refusing realtime tasks in groups that do not have real-time
> > bandwidth assigned.
> 
> If you're referring to this patch: http://lkml.org/lkml/2008/2/4/332 , then
> sorry, but it doesn't fix the issue for me, with the attached config.

Well, that whole queue. Your test program just failed to obtain realtime
scheduling but didn't hang. I'll test your full config.


