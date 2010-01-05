Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170Ab0AEXgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0AEXgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756Ab0AEXgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:36:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754043Ab0AEXgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:36:09 -0500
Date: Tue, 5 Jan 2010 15:35:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <1262684229.2400.37.camel@laptop>
Message-ID: <alpine.LFD.2.00.1001051521320.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>  <20100104182813.753545361@chello.nl>  <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.LFD.2.00.1001041904250.3630@localhost.localdomain> <1262684229.2400.37.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Jan 2010, Peter Zijlstra wrote:
> 
> While looking at that code, I found the placement of might_sleep() a tad
> confusing, I'd expect that to be in fput() since that is the regular
> entry point (all except AIO, which does crazy things).

I think it's the crazy AIO thing that is one of the reasons for doing it 
in __fput. If it's just in fput() it covers the _normal_ cases better, but 
I doubt that those were the primary worry ;). 

		Linus
