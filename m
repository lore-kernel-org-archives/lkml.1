Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbZLJIp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbZLJIp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757967AbZLJIpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:45:22 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48857 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469AbZLJIpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:45:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Dec 2009 17:42:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com
Subject: Re: [RFC mm][PATCH 2/5] percpu cached mm counter
Message-Id: <20091210174230.8367a46c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091210083310.GB6834@elte.hu>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210075454.GB25549@elte.hu>
	<20091210172040.37d259d3.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210083310.GB6834@elte.hu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 09:33:10 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > I'm sorry If I miss your point...are you saying remove all mm_counter 
> > completely and remake them under perf ? If so, some proc file 
> > (/proc/<pid>/statm etc) will be corrupted ?
> 
> No, i'm not suggesting that - i'm just suggesting that right now MM 
> stats are not very well suited to be exposed via perf. If we wanted to 
> measure/sample the information in /proc/<pid>/statm it just wouldnt be 
> possible. We have a few events like pagefaults and a few tracepoints as 
> well - but more would be possible IMO.
> 

Ah, ok. More events will be useful.

This patch itself is for reduce(not increase) cache miss in page fault pass..
And counters I'll add is for task monitoring, like ps or top, and for improving
OOM killer. Not for counting events but for showing current _usage_ to users
via procfs or to oom killer.

I'll continue to make an efforts to find better synchronization scheme
rather than adding hook to schedule() but...

Thanks,
-Kame

