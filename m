Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZG1BnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZG1BnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 21:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZG1BnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 21:43:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46312 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZG1BnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 21:43:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/3] Add walltime support for ring-buffer
Cc: kosaki.motohiro@jp.fujitsu.com, Zhaolei <zhaolei@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0907240902030.17438@gandalf.stny.rr.com>
References: <4A698F90.90501@cn.fujitsu.com> <alpine.DEB.2.00.0907240902030.17438@gandalf.stny.rr.com>
Message-Id: <20090728103227.D7FB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 28 Jul 2009 10:43:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhaolei,

> Hi Zhaolei,
> 
> Could you not just save the wall time in some 64bit format within the 
> current timestamp?  Right now there's three clocks that can be used by 
> ftrace. Two that you can really get two (I need to add access to the 
> third).  The default clock is sched_clock. But there's an option to get to 
> global_clock:
> 
>  debug/tracing/options/global-clock
> 
> # echo 1 > /debug/tracing/options/global-clock
> 
> Will enable the global clock. Perhaps we can add a "wall clock" version 
> that will map the timestamps to the wall clock?
> 
> I really hate adding any more fields to the ring buffer headers. That 
> takes away from the amount that you can record per page.

I think wall-time recording on every event is too slow. slower tracer
isn't useful.
Instead, Can we make pseudo wall-time recording event periodically?

In nowadays, many workload run on cluster machine environment. Then
We often need compare different machines tracing log. it mean TSC isn't
sufficient. but nobody want performance reduce.
Fortunatelly, ntp time adjustment is not happend so frequently. we
don't need wall-time on _every_ event.

Thanks.


