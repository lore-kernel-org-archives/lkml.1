Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZG1Bx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZG1Bx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 21:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZG1Bxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 21:53:55 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:63909 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZG1Bxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 21:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bhWr2xVr3cCr9VTG+JF7kHxA/ci+BvDmi7qhSCkNYbEgOUbcVjJw2BNnKp4hAgm4HC
         MNkmeVumWCdAMPHtERjILYfMz9MjlXfwgQJxXEbOL5iDuUVOdqAiD1YSPv4fB5qEbHTC
         tpiQ9sJ6E8F0WI/kuSE88Heax30jzlaluPDoE=
Date: Tue, 28 Jul 2009 03:53:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add walltime support for ring-buffer
Message-ID: <20090728015351.GF5147@nowhere>
References: <4A698F90.90501@cn.fujitsu.com> <alpine.DEB.2.00.0907240902030.17438@gandalf.stny.rr.com> <20090728103227.D7FB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728103227.D7FB.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 10:43:11AM +0900, KOSAKI Motohiro wrote:
> Hi Zhaolei,
> 
> > Hi Zhaolei,
> > 
> > Could you not just save the wall time in some 64bit format within the 
> > current timestamp?  Right now there's three clocks that can be used by 
> > ftrace. Two that you can really get two (I need to add access to the 
> > third).  The default clock is sched_clock. But there's an option to get to 
> > global_clock:
> > 
> >  debug/tracing/options/global-clock
> > 
> > # echo 1 > /debug/tracing/options/global-clock
> > 
> > Will enable the global clock. Perhaps we can add a "wall clock" version 
> > that will map the timestamps to the wall clock?
> > 
> > I really hate adding any more fields to the ring buffer headers. That 
> > takes away from the amount that you can record per page.
> 
> I think wall-time recording on every event is too slow. slower tracer
> isn't useful.
> Instead, Can we make pseudo wall-time recording event periodically?
> 
> In nowadays, many workload run on cluster machine environment. Then
> We often need compare different machines tracing log. it mean TSC isn't
> sufficient. but nobody want performance reduce.
> Fortunatelly, ntp time adjustment is not happend so frequently. we
> don't need wall-time on _every_ event.
> 
> Thanks.


Yeah, that would really slow the tracing.

Can't we get a snapshot of the couple (walltime, cpu clock) once
at startup.
Then we can retrieve the walltime when cpu_clock was 0 and compute
the walltime for each traces at output time using the trace timestamp as
a delta?

Thanks,
Frederic.

