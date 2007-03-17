Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbXCQEhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbXCQEhq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 00:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933334AbXCQEhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 00:37:46 -0400
Received: from [212.12.190.228] ([212.12.190.228]:32804 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933327AbXCQEhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 00:37:45 -0400
From: Al Boldi <a1426z@gawab.com>
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: RSDL v0.31
Date: Sat, 17 Mar 2007 07:40:07 +0300
User-Agent: KMail/1.5
Cc: ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703170055.30747.a1426z@gawab.com> <200703171351.47399.kernel@kolivas.org>
In-Reply-To: <200703171351.47399.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703170740.07530.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Saturday 17 March 2007 08:55, Al Boldi wrote:
> > With X nice'd at -10, and 11 hogs loading the cpu, interactivity looks
> > good until the default timeslice/quota is exhausted and slows down. 
> > Maybe adjusting this according to nice could help.
>
> Not sure what you mean by that. It's still a fair distribution system,
> it's just that nice -10 has quite a bit more cpu allocated than nice 0.
> Eventually if you throw enough load at it it will slow down too.

I mean #DEF_TIMESLICE seems like an initial quota, which gets reset with each 
major rotation.  Increasing this according to nice may give it more room for 
an interactivity boost, before being expired.  Alternatively, you may just 
reset the rotation, if the task didn't use it's quota within one full major 
rotation, effectively skipping the expiry toll.

> > It may also be advisable to fix latencies according to nice, and adjust
> > timeslices instead.  This may help scaleability a lot, as there are some
> > timing sensitive apps that may crash under high load.
>
> You will find that is the case already with this version. Even under heavy
> load if you were to be running one server niced (say httpd nice 19 in the
> presence of mysql nice 0) the latencies would be drastically reduced
> compared to mainline behaviour. I am aware this becomes an issue for some
> heavily loaded servers because some servers run multithreaded while others
> do not, forcing the admins to nice their multithreaded ones.

The thing is, latencies are currently dependent on the number of tasks in the 
run-queue; i.e. more rq-tasks means higher latencies, yet fixed timeslices 
according to nice.  Just switching this the other way around, by fixing 
latencies according to nice, and adjusting the timeslices depending on 
rq-load, may yield a much more scalable system.


Thanks!

--
Al

