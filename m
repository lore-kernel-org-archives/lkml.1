Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZFRXtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZFRXtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 19:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZFRXtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 19:49:10 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:51112 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZFRXtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 19:49:10 -0400
Message-ID: <4A3AD263.806@nortel.com>
Date: Thu, 18 Jun 2009 17:48:51 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, Chris Adams <cmadams@hiwaay.net>,
       510478@bugs.debian.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] v2 Re: Bug: Status/Summary of slashdot leap-second crash
 on new years 2008-2009
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>	 <20090103002114.GA1538533@hiwaay.net>	 <20090103022358.GA2454@dastardly.home.dghda.com>	 <20090103044143.GB1538533@hiwaay.net>	 <20090103045227.GA5994@dastardly.home.dghda.com>	 <20090103180148.GA1375968@hiwaay.net> <1244427498.21215.200.camel@deadeye>	 <4A3AC0FF.20808@nortel.com> <1245365887.4616.417.camel@deadeye>
In-Reply-To: <1245365887.4616.417.camel@deadeye>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2009 23:48:52.0750 (UTC) FILETIME=[55C0BAE0:01C9F06F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:
> On Thu, 2009-06-18 at 16:34 -0600, Chris Friesen wrote:

> Having investigated further, I believe it has been safe since this
> change made in 2.6.27 (which cleverly preempted the new year):
> 
> commit b845b517b5e3706a3729f6ea83b88ab85f0725b0
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Aug 8 21:47:09 2008 +0200
> 
>     printk: robustify printk
>     
>     Avoid deadlocks against rq->lock and xtime_lock by deferring the klogd
>     wakeup by polling from the timer tick.
>     
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
>> In addition, is it allowed for older kernels also or is Chris Adams'
>> patch something that should get picked up for the 2.6.27 stable series?
> 
> Anything older than 2.6.27 appears to need a change along the lines of
> the above-mentioned commit or Chris's patch.  Note that this was not the
> only case where printk() could be called under xtime_lock.  For example,
> in arch/alpha/kernel/time.c timer_interrupt() calls set_rtc_mmss() which
> can call printk().


It appears that the patch in question went into mainline in 2.6.28-rc1
after being developed on the -tip tree.  So it doesn't appear to be
present in the mainline 2.6.27 kernel.

Chris
