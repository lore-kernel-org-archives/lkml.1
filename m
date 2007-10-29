Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbXJ2MGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbXJ2MGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXJ2MF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:05:58 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:18717 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829AbXJ2MF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:05:56 -0400
From: Frans Pop <elendil@planet.nl>
To: balbir@linux.vnet.ibm.com
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Date: Mon, 29 Oct 2007 13:05:51 +0100
User-Agent: KMail/1.9.7
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
References: <200710122231.50739.elendil@planet.nl> <200710161234.35529.borntraeger@de.ibm.com> <4714B5BF.1090001@linux.vnet.ibm.com>
In-Reply-To: <4714B5BF.1090001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710291305.52992.elendil@planet.nl>
X-OriginalArrivalTime: 29 Oct 2007 12:05:55.0329 (UTC) FILETIME=[0F068710:01C81A24]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Balbir,

On Tuesday 16 October 2007, Balbir Singh wrote:
> Christian Borntraeger wrote:
> > Am Dienstag, 16. Oktober 2007 schrieb Balbir Singh:
> >> I am trying to think out loud as to what the root cause of the problem
> >> might be. In one of the discussion threads, I saw utime going
> >> backwards, which seemed very odd, I suspect that those are rounding
> >> errors.
> >>
> >> I don't understand your explanation below
> >>
> >> Initially utime = 9, stime = 0, sum_exec_runtime = S1
> >>
> >> Later
> >>
> >> utime = 9, stime = 1, sum_exec_runtime = S2
> >>
> >> We can be sure that S >= (utime + stime)
> >
> > I think here is the problem. How can we be sure? We cant. utime and
> > stime are sampled, so they can be largely off in any direction,if the
> > program sleeps often and manages to synchronize itself to the timer
> > tick. Lets say a program only does a simple system call and then
> > sleeps. So sum_exec_runtime is increased by lets say 1000 cycles on a
> > 1Ghz box which means 1000ns. If now the timer tick happens exactly at
> > this moment, stime is increased by 1 tick = 1000000ns.
>
> Yes, I thought of that just after I sent out my email. In the case that
> you mention, the utime and stime accounting is incorrect anyway :-)
> I think we need to find a better solution. I was going to propose that
> we round correctly in (the divisions in)
>
> 1. task_utime()
> 2. clock_t_to_cputime()
>
> I suspect we'll need to round task_utime() to p->utime if the value of
> task_utime() < p->utime and the same thing for task_stime(). I've tried
> reproducing the problem on my UML setup without any success. Let me
> try and grab an x86 box.

Any progress on this issue? I noticed that it's still there in current git.

If a better implementation is not expected any time soon, how about an ACK 
on the reversion patch Christian proposed in
http://lkml.org/lkml/2007/10/16/76
so we can at least get rid of the regression?

Thanks,
Frans Pop
