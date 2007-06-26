Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbXFZAWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbXFZAWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 20:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbXFZAWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 20:22:41 -0400
Received: from rtr.ca ([64.26.128.89]:4562 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbXFZAWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 20:22:41 -0400
Message-ID: <46805C4F.1050200@rtr.ca>
Date: Mon, 25 Jun 2007 20:22:39 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
References: <20070625200601.GA18980@elte.hu>
In-Reply-To: <20070625200601.GA18980@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Subject: [patch] sys_time() speedup
> From: Ingo Molnar <mingo@elte.hu>
> 
> improve performance of sys_time(). sys_time() returns time in seconds, 
> but it does so by calling do_gettimeofday() and then returning the 
> tv_sec portion of the GTOD time. But the data structure "xtime", which 
> is updated by every timer/scheduler tick, already offers HZ granularity 
> time.

How well synchronized is xtime with real-time ?

Programs invoking sys_time() do expect it to be as accurate
as gettimeofday(), even if only at 1-second boundaries.

Cheers
