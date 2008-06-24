Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbYFXG33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbYFXG33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYFXG3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:29:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8323 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYFXG3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:29:20 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5323"; a="3997024"
Message-ID: <48609441.2030901@qualcomm.com>
Date: Mon, 23 Jun 2008 23:29:21 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>
Subject: Re: v2.6.26-rc7/cgroups: circular locking dependency
References: <20080621173859.GA6846@damson.getinternet.no>	 <2f11576a0806220834m3572ee80i72229cb9a1613558@mail.gmail.com> <1214149823.3223.313.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1214149823.3223.313.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-06-23 at 00:34 +0900, KOSAKI Motohiro wrote:
>> CC'ed Paul Jackson
>>
>> it seems typical ABBA deadlock.
>> I think cpuset use cgrou_lock() by mistake.
>>
>> IMHO, cpuset_handle_cpuhp() sholdn't use cgroup_lock() and
>> shouldn't call rebuild_sched_domains().
> 
> Looks like Max forgot to test with lockdep enabled... 
Hmm, I don't think I actually changed any lock nesting/dependencies. Did I ?
Oh, I see rebuild_sched_domains() is now called from cpuset hotplug handler.
I just looked at the comment for rebuild_sched_domains() and it says
" * Call with cgroup_mutex held. ..." that's why I thought it's safe and it
worked on the test stations.

Anyway, we need definitely need to make rebuild_sched_domains() work from the
hotplug handler.

> Well, someone should when you change the online map.
> 
> Max, Paul, can we handle this in update_sched_domains() instead?

That'd be exactly the same as calling rebuild_sched_domains() outside of the
cgroup_lock(). So I do not think it'll help. Paul has more info in his reply
so I'll reply to his email.

Max
