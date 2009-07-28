Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZG1CXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZG1CXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 22:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZG1CXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 22:23:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39932 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZG1CXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 22:23:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] Add walltime support for ring-buffer
Cc: kosaki.motohiro@jp.fujitsu.com, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090728015351.GF5147@nowhere>
References: <20090728103227.D7FB.A69D9226@jp.fujitsu.com> <20090728015351.GF5147@nowhere>
Message-Id: <20090728105931.D801.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 28 Jul 2009 11:23:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jul 28, 2009 at 10:43:11AM +0900, KOSAKI Motohiro wrote:
> > Hi Zhaolei,
> > 
> > > Hi Zhaolei,
> > > 
> > > Could you not just save the wall time in some 64bit format within the 
> > > current timestamp?  Right now there's three clocks that can be used by 
> > > ftrace. Two that you can really get two (I need to add access to the 
> > > third).  The default clock is sched_clock. But there's an option to get to 
> > > global_clock:
> > > 
> > >  debug/tracing/options/global-clock
> > > 
> > > # echo 1 > /debug/tracing/options/global-clock
> > > 
> > > Will enable the global clock. Perhaps we can add a "wall clock" version 
> > > that will map the timestamps to the wall clock?
> > > 
> > > I really hate adding any more fields to the ring buffer headers. That 
> > > takes away from the amount that you can record per page.
> > 
> > I think wall-time recording on every event is too slow. slower tracer
> > isn't useful.
> > Instead, Can we make pseudo wall-time recording event periodically?
> > 
> > In nowadays, many workload run on cluster machine environment. Then
> > We often need compare different machines tracing log. it mean TSC isn't
> > sufficient. but nobody want performance reduce.
> > Fortunatelly, ntp time adjustment is not happend so frequently. we
> > don't need wall-time on _every_ event.
> > 
> > Thanks.
> 
> 
> Yeah, that would really slow the tracing.
> 
> Can't we get a snapshot of the couple (walltime, cpu clock) once
> at startup.
> Then we can retrieve the walltime when cpu_clock was 0 and compute
> the walltime for each traces at output time using the trace timestamp as
> a delta?


It can. but I don't think it is sufficient.
On flight recorder use-case, The tracing run more than one year. And,
Administrator only see last N sec log. (previous logs were overwritten
by ring-buffer go-around)

Thanks.


