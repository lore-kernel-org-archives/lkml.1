Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYIAHQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYIAHQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 03:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYIAHQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 03:16:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34287 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbYIAHQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 03:16:11 -0400
Date: Mon, 1 Sep 2008 16:19:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       hugh@veritas.com, menage@google.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
Message-Id: <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200809011656.45190.nickpiggin@yahoo.com.au>
References: <20080831174756.GA25790@balbir.in.ibm.com>
	<20080901090102.46b75141.kamezawa.hiroyu@jp.fujitsu.com>
	<200809011656.45190.nickpiggin@yahoo.com.au>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 16:56:44 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Monday 01 September 2008 10:01, KAMEZAWA Hiroyuki wrote:
> > On Sun, 31 Aug 2008 23:17:56 +0530
> >
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > This is a rewrite of a patch I had written long back to remove struct
> > > page (I shared the patches with Kamezawa, but never posted them anywhere
> > > else). I spent the weekend, cleaning them up for 2.6.27-rc5-mmotm (29 Aug
> > > 2008).
> >
> > It's just because I think there is no strong requirements for 64bit
> > count/mapcount. There is no ZERO_PAGE() for ANON (by Nick Piggin. I add him
> > to CC.) (shmem still use it but impact is not big.)
> 
> I think it would be nice to reduce the impact when it is not configured
> anyway. Normally I would not mind so much, but this is something that
> many distros will want to enable but fewer users will make use of it.
> 
> I think it is always a very good idea to try to reduce struct page size.
> When looking at the performance impact though, just be careful with the
> alignment of struct page... I actually think it is going to be a
> performance win in many cases to make struct page 64 bytes.
> 
On 32bit, sizeof(struct page) = 32bytes + 4bytes(page_cgroup)
On 64bit, sizeof(struct page) = 56bytes + 8bytes(page_cgroup)
So, 32bit case is a problem.

> 
> If you do that, it might even be an idea to allocate flat arrays with
> bootmem. It would just be slightly more tricky more tricky to fit this
> in with the memory model. But that's not a requirement, just an idea
> for a small optimisation.
> 
If we make mem_res_controller available only under SPARSEMEM, I think we can
do in very straightfoward way.

Thanks,
-Kame

