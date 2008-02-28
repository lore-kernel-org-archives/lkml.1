Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbYB1Puq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbYB1Puq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761313AbYB1Pu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:50:28 -0500
Received: from viefep31-int.chello.at ([62.179.121.49]:62176 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761288AbYB1Pu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:50:26 -0500
Subject: Re: [PATCH] proc: Add RLIMIT_RTTIME to /proc/<pid>/limits
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Eugene Teo <eugeneteo@kernel.sg>,
       linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <cfd18e0f0802280744q18ccad3at3c88bac166806118@mail.gmail.com>
References: <20080208145950.GA3910@kernel.sg>
	 <1202483445.6292.1.camel@lappy>
	 <517f3f820802280712o3d756b4fq46461b226515e1f2@mail.gmail.com>
	 <1204212100.12120.9.camel@twins>
	 <cfd18e0f0802280744q18ccad3at3c88bac166806118@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 16:50:21 +0100
Message-Id: <1204213821.12120.15.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 16:44 +0100, Michael Kerrisk wrote:
> Peter,
> 
> Thanks for the text.
> 
> On Thu, Feb 28, 2008 at 4:21 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> >  On Thu, 2008-02-28 at 16:12 +0100, Michael Kerrisk wrote:
> >  > Peter,
> >  >
> >  > Could you please provide some text describing RLIMIT_RTTIMEfor the
> >  > getrlimit.2 man page.
> >
> >  The rlimit sets a timeout in [us] for SCHED_RR and SCHED_FIFO tasks.
> >  This time is measured between sleeps, so a schedule in RR or a
> >  preemption in either is not a sleep - the task needs to be dequeued and
> >  enqueued for the timer to reset.
> 
> Just to clarify: sleep here means a call to some blocking syscall
> (e.g., nanosleep(), read(), select(), etc.), right?  Is there anything
> else that falls under the category of "sleep"?  What about a call to
> sched_yield() where the process explicitly lets go of the CPU?

Yes, and yes, others would be blocking on futexes and the like.

> Also, is this limit per-thread or per-process?  I assume the latter --
> but can you confirm please.

Per process. Requests have been made to allow for per thread, but
rlimits are not.

Its really not meant as a fine-grained deadline notification mechanism,
we have posix timers for that, but as a watchdog to ensure we behave
'well'.


