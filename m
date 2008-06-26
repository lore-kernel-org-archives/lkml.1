Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbYFZRp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbYFZRp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbYFZRpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:45:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20677 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbYFZRpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:45:04 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5326"; a="4078536"
Message-ID: <4863D59E.3070604@qualcomm.com>
Date: Thu, 26 Jun 2008 10:45:02 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>
Subject: Re: v2.6.26-rc7/cgroups: circular locking dependency
References: <20080621173859.GA6846@damson.getinternet.no>	 <2f11576a0806220834m3572ee80i72229cb9a1613558@mail.gmail.com>	 <1214149823.3223.313.camel@lappy.programming.kicks-ass.net>	 <48609441.2030901@qualcomm.com> <6599ad830806260025u27458a47j47175ad778ca48a9@mail.gmail.com>
In-Reply-To: <6599ad830806260025u27458a47j47175ad778ca48a9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Second idea - can we just punt the call to rebuild_sched_domains() to
> a workqueue thread if it's due to a flag or cpumask change? Does it
> matter if the call doesn't happen synchronously? The work handler
> could easily nest the cgroup_lock() call inside get_online_cpus() and
> then call rebuild_sched_domains()

I was thinking about exactly the same thing. I kind of don't like async 
nature of it. Maybe it's ok but there might be some interesting races 
with async domain updates.

Max
