Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbXCMXJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbXCMXJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 19:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbXCMXJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 19:09:22 -0400
Received: from mail20.syd.optusnet.com.au ([211.29.132.201]:44032 "EHLO
	mail20.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202AbXCMXJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 19:09:21 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>
Subject: RSDL development plans
Date: Wed, 14 Mar 2007 10:08:38 +1100
User-Agent: KMail/1.9.5
Cc: Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703140303.36456.kernel@kolivas.org> <200703140758.30079.kernel@kolivas.org>
In-Reply-To: <200703140758.30079.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703141008.39516.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007 07:58, Con Kolivas wrote:
> On Wednesday 14 March 2007 03:03, Con Kolivas wrote:
> > On Wednesday 14 March 2007 02:31, Con Kolivas wrote:
> > > On Monday 12 March 2007 22:26, Al Boldi wrote:
> > > > I think, it should be possible to spread this max expiration latency
> > > > across the rotation, should it not?
> > >
> > > Can you try the attached patch please Al and Mike? It "dithers" the
> > > priority bitmap which tends to fluctuate the latency a lot more but in
> > > a cyclical fashion. This tends to make the max latency bound to a
> > > smaller value and should make it possible to run -nice tasks without
> > > killing the latency of the non niced tasks. Eg you could possibly run X
> > > nice -10 at a guess like we used to in 2.4 days. It's not essential of
> > > course, but is a workaround for Mike's testcase.
> >
> > Oops, one tiny fix. This is a respin of the patch, sorry.

> Bah with a bit more sleep under my belt it became clear that I forgot to
> update the expired array in any proper way so this change almost breaks
> stuff at the moment in the shape it's in. Please disregard this change for
> now apart from interest in how I'm tackling the nice issue.

The rsdl patches queued up so far are stable and boot fine and are reasonably 
performant on many architectures so I'm quite happy for them to get a run 
in -mm. The changes planned will (as you may have seen on this email thread) 
decrease average latencies across all nice levels, and make differential nice 
levels run better together. This will allow -nice to be used without 
significant latency harm to not niced tasks (as there is presently in rsdl 
and mainline). The change required on top of the patch earlier in this email 
is to make the dynamic bitmap reflect where the tasks will actually be on an 
array swap.

However, I must inform people that I have to arrest the RSDL development for 
at least this week. I have a new and fairly serious neck problem that is 
being exacerbated badly by sitting in front of the computer for any extended 
period.

I suspect the inner workings of RSDL currently are not well understood yet by 
anyone else well enough to hack on it. I'm not at all opposed to someone 
taking up the code at the moment and making the necessary changes I've 
mentioned above in the meantime though if they can get their head around it.

-- 
-ck
