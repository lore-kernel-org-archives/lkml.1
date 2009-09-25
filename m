Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbZIYHJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbZIYHJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbZIYHJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:09:08 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:40792 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbZIYHJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:09:07 -0400
Date: Fri, 25 Sep 2009 16:09:11 +0900 (JST)
Message-Id: <20090925.160911.71102299.ryov@valinux.co.jp>
To: balbir@linux.vnet.ibm.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       vgoyal@redhat.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, agk@redhat.com, peterz@infradead.org,
       jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
       riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090925052911.GK4590@balbir.in.ibm.com>
References: <20090925100952.55c2dd7a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090925101821.1de8091a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090925052911.GK4590@balbir.in.ibm.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > I think I must support dirty-ratio in memcg layer. But not yet.
> > 
> 
> We need to add this to the TODO list.
> 
> > OR...I'll add a bufferred-write-cgroup to track bufferred writebacks.
> > And add a control knob as
> >   bufferred_write.nr_dirty_thresh
> > to limit the number of dirty pages generetad via a cgroup.
> > 
> > Because memcg just records a owner of pages but not records who makes them
> > dirty, this may be better. Maybe I can reuse page_cgroup and Ryo's blockio
> > cgroup code.
> 
> Very good point, this is crucial for shared pages.
> 
> > 
> > But I'm not sure how I should treat I/Os generated out by kswapd.
> >
> 
> Account them to process 0 :)

How about accounting them to processes who make pages dirty? I think
that a process which consumes more memory should get penalty. However,
this allows a page request process to use other's bandwidth, but If
a user doesn't want to swap-out the memory, the user should allocate
enough memory for the process by using memcg in advance.

Thanks,
Ryo Tsuruta
