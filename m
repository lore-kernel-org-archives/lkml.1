Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487Ab0AEQMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0AEQMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095Ab0AEQMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:12:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117Ab0AEQMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:12:17 -0500
Date: Tue, 5 Jan 2010 08:10:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <20100105154047.GA18217@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1001050802401.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001041904250.3630@localhost.localdomain> <1262681834.2400.31.camel@laptop>
 <alpine.LFD.2.00.1001050727400.3630@localhost.localdomain> <20100105154047.GA18217@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Jan 2010, Al Viro wrote:
> 
> - a bunch of fs operations done from RCU callbacks.  Including severely
> blocking ones.

Yeah, you're right (and Peter also pointed out the might_sleep). That is 
likely to be the really fundamental issue. 

You _can_ handle it (make the RCU callback just schedule the work instead 
of doing it directly), but it does sound really nasty. I suspect we should 
explore just about any other approach over this one. 

			Linus
