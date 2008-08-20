Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbYHTLdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbYHTLdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 07:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYHTLdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 07:33:32 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:47477 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750909AbYHTLdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 07:33:32 -0400
Date: Wed, 20 Aug 2008 20:33:30 +0900 (JST)
Message-Id: <20080820.203330.58805720.taka@valinux.co.jp>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       yamamoto@valinux.co.jp, nishimura@mxp.nes.nec.co.jp, ryov@valinux.co.jp,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH -mm 0/7] memcg: lockless page_cgroup v1
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080820185306.e897c512.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
	<20080820185306.e897c512.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Hi, this is a patch set for lockless page_cgroup.
> 
> dropped patches related to mem+swap controller for easy review.
> (I'm rewriting it, too.)
> 
> Changes from current -mm is.
>   - page_cgroup->flags operations is set to be atomic.
>   - lock_page_cgroup() is removed.
>   - page->page_cgroup is changed from unsigned long to struct page_cgroup*
>   - page_cgroup is freed by RCU.
>   - For avoiding race, charge/uncharge against mm/memory.c::insert_page() is
>     omitted. This is ususally used for mapping device's page. (I think...)
> 
> In my quick test, perfomance is improved a little. But the benefit of this
> patch is to allow access page_cgroup without lock. I think this is good 
> for Yamamoto's Dirty page tracking for memcg.
> For I/O tracking people, I added a header file for allowing access to
> page_cgroup from out of memcontrol.c

Thanks, Kame.
It is a good news that the page tracking framework is open.
I think I can send some feedback to you to make it more generic.

> The base kernel is recent mmtom. Any comments are welcome.
> This is still under test. I have to do long-run test before removing "RFC".
> 

Thanks,
Hirokazu Takahashi.
