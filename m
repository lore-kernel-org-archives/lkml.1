Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbYF0MZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbYF0MZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbYF0MZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:25:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47971 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbYF0MZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:25:32 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <11849640.1214569478380.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 27 Jun 2008 21:24:38 +0900 (JST)
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: Re: [-mm][PATCH 8/10] fix shmem page migration incorrectness on memcgroup
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20080627182952.f8d2b0c3.nishimura@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <20080627182952.f8d2b0c3.nishimura@mxp.nes.nec.co.jp>
 <20080625190750.D864.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<28c262360806262208i6791d67at446f7323ded16206@mail.gmail.com>
	<20080627142950.7A83.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<28c262360806270057w2b2d3e56ob4dde9aacf42327b@mail.gmail.com>
	<20080627175201.cbe86a06.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----

>> But situation is a bit complicated.
>> - shmem's page is charged as file-cache.
>> - shmem's swap cache is still charged by mem_cgroup_cache_charge() because
>>   it's implicitly (to memcg) converted to swap cache. 
>> - anon's swap cache is charged by mem_cgroup_uncharge_cache_page()
>> 
>I'm sorry if I misunderstand something.
>
>I think anon's swap cache is:
>
>- charged by nowhere as "cache".
yes.
>  If anon pages are also on swap cache, charges for them remain charged
>  even when mem_cgroup_uncharge_page() is called, because it checks PG_swapca
che.
>  So, as a result, anon's swap cache is charged.
yes.

>- uncharged by memcgroup_uncharge_page() in __delete_from_swap_cache()
>  after clearing PG_swapcache.
>
>right?
>
You're right. Sorry for confusion.

Thanks,
-Kame

