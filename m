Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905Ab0AEPk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0AEPk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877Ab0AEPk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:40:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60067 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab0AEPk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:40:57 -0500
Date: Tue, 5 Jan 2010 15:40:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-ID: <20100105154047.GA18217@ZenIV.linux.org.uk>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001041904250.3630@localhost.localdomain> <1262681834.2400.31.camel@laptop> <alpine.LFD.2.00.1001050727400.3630@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001050727400.3630@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 07:34:02AM -0800, Linus Torvalds wrote:

> The only other effects of delaying closing a file I can see are
> 
>  - the ETXTBUSY thing, but we don't need to delay _that_ part, so this may 
>    be a non-issue.
> 
>  - the actual freeing of the data on disk (ie people may expect that the 
>    last close really frees up the space on the filesystem). However, this 
>    is _such_ a subtle semantic thing that maybe nobody cares.

- a bunch of fs operations done from RCU callbacks.  Including severely
blocking ones.  As in "for minutes" in the most severe cases, and with
large numbers of objects involved.  Can get very unpleasant...
