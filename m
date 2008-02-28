Return-Path: <linux-kernel-owner+w=401wt.eu-S1760055AbYB1QNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbYB1QNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYB1QNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:13:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:51235 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752022AbYB1QNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:13:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18QNXpIDDEQJQTQuQnjCb6Y/VsWmVdNUqc6H9QDXq
	TMPKRx2TbH5g4m
Subject: Re: [PATCH] sched: revert load_balance_monitor()
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080228132627.GA24096@elte.hu>
References: <1203942167.6242.142.camel@lappy>
	 <1203949799.4688.9.camel@homer.simson.net>
	 <20080225143518.GA29275@linux.vnet.ibm.com>
	 <1203950233.4688.11.camel@homer.simson.net>
	 <20080228132627.GA24096@elte.hu>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 17:13:11 +0100
Message-Id: <1204215191.4319.7.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 14:26 +0100, Ingo Molnar wrote: 

> Mike, could you check whether today's sched-devel.git (which includes 
> the full revert) works well for you? (with group scheduler enabled)

No, it's fairly lurchy with three root chew-max and one user chew-max
running.  Moving the mouse around while they're running, I can see/feel
the load, and max latency for the user chew-max quickly shoots to
>500ms.

Running the same with mainline + full revert, the load is not palpable
and max latency  for user task was 83ms.

Group CPU distribution otoh is better than mainline git + full revert.

root 
out   16 ms [max:  295, avg:   14, flu:    2, avg_flu:    7], ran for   20 ms
out   16 ms [max:  295, avg:   14, flu:    0, avg_flu:    7], ran for    9 ms
out    5 ms [max:  295, avg:   14, flu:   10, avg_flu:    7], ran for   13 ms
out   33 ms [max:  295, avg:   14, flu:   28, avg_flu:    7], ran for   12 ms
out   12 ms [max:  295, avg:   14, flu:   20, avg_flu:    7], ran for   13 ms
out   16 ms [max:  295, avg:   14, flu:    3, avg_flu:    7], ran for    4 ms
out   21 ms [max:  295, avg:   14, flu:    4, avg_flu:    7], ran for    8 ms

root
out    7 ms [max:  248, avg:   14, flu:    3, avg_flu:    8], ran for    5 ms
out   27 ms [max:  248, avg:   14, flu:   20, avg_flu:    8], ran for   13 ms
out   17 ms [max:  248, avg:   14, flu:   10, avg_flu:    8], ran for    9 ms
out    8 ms [max:  248, avg:   14, flu:    8, avg_flu:    8], ran for    7 ms
out    6 ms [max:  248, avg:   14, flu:    2, avg_flu:    8], ran for    9 ms
out   10 ms [max:  248, avg:   14, flu:    3, avg_flu:    8], ran for   10 ms
out    8 ms [max:  248, avg:   14, flu:    1, avg_flu:    8], ran for   12 ms
out   13 ms [max:  248, avg:   14, flu:    5, avg_flu:    8], ran for    9 ms

root
out   11 ms [max:  366, avg:   14, flu:    2, avg_flu:    6], ran for    7 ms
out   10 ms [max:  366, avg:   14, flu:    1, avg_flu:    6], ran for    5 ms
out   12 ms [max:  366, avg:   14, flu:    1, avg_flu:    6], ran for    9 ms
out   10 ms [max:  366, avg:   14, flu:    1, avg_flu:    6], ran for    8 ms
out   13 ms [max:  366, avg:   14, flu:    2, avg_flu:    6], ran for   13 ms
out   11 ms [max:  366, avg:   14, flu:    2, avg_flu:    6], ran for   13 ms
out    9 ms [max:  366, avg:   14, flu:    2, avg_flu:    6], ran for    9 ms

user
out    3 ms [max:  509, avg:   20, flu:    1, avg_flu:   13], ran for   27 ms
out    2 ms [max:  509, avg:   20, flu:    0, avg_flu:   13], ran for   12 ms
out    2 ms [max:  509, avg:   20, flu:    0, avg_flu:   13], ran for    2 ms
out   25 ms [max:  509, avg:   20, flu:   22, avg_flu:   13], ran for   74 ms
out    3 ms [max:  509, avg:   20, flu:   21, avg_flu:   13], ran for   29 ms
out    6 ms [max:  509, avg:   20, flu:    3, avg_flu:   13], ran for   17 ms
out    5 ms [max:  509, avg:   20, flu:    0, avg_flu:   13], ran for   28 ms
out    2 ms [max:  509, avg:   20, flu:    3, avg_flu:   13], ran for   34 ms

	-Mike





