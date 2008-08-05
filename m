Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbYHEGXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbYHEGXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 02:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYHEGW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:22:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33967 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYHEGW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:22:58 -0400
Date: Tue, 05 Aug 2008 15:20:59 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: Race condition between putback_lru_page and mem_cgroup_move_list
Cc: kosaki.motohiro@jp.fujitsu.com, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <489741F8.2080104@linux.vnet.ibm.com>
References: <2f11576a0808040937y70f274e0j32f6b9c98b0f992d@mail.gmail.com> <489741F8.2080104@linux.vnet.ibm.com>
Message-Id: <20080805151956.A885.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir-san,

> > I also think zone's lru lock is unnecessary.
> > So, I guess below "it" indicate lock_page_cgroup, not zone lru lock.
> 
> We need zone LRU lock, since the reclaim paths hold them. Not sure if I
> understand why you call zone's LRU lock unnecessary, could you elaborate please?

I tought..

1. in general, one data structure should be protected by one lock.
2. memcgroup lru is protected by mem_cgroup_per_zone::lru_lock.


if zone LRU lock must be held, Why do mem_cgroup_per_zone::lru_lock exit?
it should be removed?


Could you explain detail of "race condition with global reclaim race" ?



> > I think both opinion is correct.
> > unevictable lru related code doesn't require pagevec.
> > 
> > but mem_cgroup_move_lists is used by active/inactive list transition too.
> > then, pagevec is necessary for keeping reclaim throuput.
> > 
> 
> It's on my TODO list. I hope to get to it soon.

Very good news!
Thanks.



