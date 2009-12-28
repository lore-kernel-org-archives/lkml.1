Return-Path: <linux-kernel-owner+w=401wt.eu-S1751405AbZL1A5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbZL1A5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 19:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZL1A5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 19:57:54 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34597 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbZL1A5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 19:57:53 -0500
Date: Mon, 28 Dec 2009 06:27:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
Subject: Re: [RFC PATCH] asynchronous page fault.
Message-ID: <20091228005746.GE3601@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
 <1261912796.15854.25.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1261912796.15854.25.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2009-12-27 12:19:56]:

> Your changelog states as much.
> 
> "Even if RB-tree rotation occurs while we walk tree for look-up, we just
> miss vma without oops."
> 
> However, since this is the case, do we still need the
> rcu_assign_pointer() conversion your patch does? All I can see it do is
> slow down all RB-tree users, without any gain.

Don't we need the rcu_assign_pointer() on the read side primarily to
make sure the pointer is still valid and assignments (writes) are not
re-ordered? Are you suggesting that the pointer assignment paths be
completely atomic?

-- 
	Balbir
