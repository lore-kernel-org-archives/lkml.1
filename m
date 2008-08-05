Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbYHEDvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbYHEDvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYHEDvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:51:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44324 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbYHEDvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:51:43 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <3182585.1217908165040.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 5 Aug 2008 12:49:25 +0900 (JST)
To: balbir@linux.vnet.ibm.com
Subject: Re: Re: Race condition between putback_lru_page and mem_cgroup_move_list
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <489741F8.2080104@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <489741F8.2080104@linux.vnet.ibm.com>
 <28c262360808040736u7f364fc0p28d7ceea7303a626@mail.gmail.com> <1217863870.7065.62.camel@lts-notebook> <2f11576a0808040937y70f274e0j32f6b9c98b0f992d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>KOSAKI Motohiro wrote:
>> Hi
>> 
>>>> I think this is a race condition if mem_cgroup_move_lists's comment isn't
 right.
>>>> I am not sure that it was already known problem.
>>>>
>>>> mem_cgroup_move_lists assume the appropriate zone's lru lock is already h
eld.
>>>> but putback_lru_page calls mem_cgroup_move_lists without holding lru_lock
.
>>> Hmmm, the comment on mem_cgroup_move_lists() does say this.  Although,
>>> reading thru' the code, I can't see why it requires this.  But then it's
>>> Monday, here...
>> 
>> I also think zone's lru lock is unnecessary.
>> So, I guess below "it" indicate lock_page_cgroup, not zone lru lock.
>> 
>
>We need zone LRU lock, since the reclaim paths hold them. Not sure if I
>understand why you call zone's LRU lock unnecessary, could you elaborate plea
se?
>

I guess the comment should be against mem_cgroup_isolate_pages()...

Thanks,
-Kame

