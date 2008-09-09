Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbYIIEew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbYIIEew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYIIEeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:34:44 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:34779 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbYIIEeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:34:44 -0400
Message-ID: <48C5F91D.5070500@linux.vnet.ibm.com>
Date: Mon, 08 Sep 2008 21:18:37 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
References: <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com> <200809011743.42658.nickpiggin@yahoo.com.au> <48BD0641.4040705@linux.vnet.ibm.com> <20080902190256.1375f593.kamezawa.hiroyu@jp.fujitsu.com> <48BD0E4A.5040502@linux.vnet.ibm.com> <20080902190723.841841f0.kamezawa.hiroyu@jp.fujitsu.com> <48BD119B.8020605@linux.vnet.ibm.com> <20080902195717.224b0822.kamezawa.hiroyu@jp.fujitsu.com> <48BD337E.40001@linux.vnet.ibm.com> <20080903123306.316beb9d.kamezawa.hiroyu@jp.fujitsu.com> <20080908152810.GA12065@balbir.in.ibm.com> <20080909125751.37042345.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080909125751.37042345.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 8 Sep 2008 20:58:10 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> Sorry for the delay in sending out the new patch, I am traveling and
>> thus a little less responsive. Here is the update patch
>>
>>
> Hmm.. I've considered this approach for a while and my answer is that
> this is not what you really want.
> 
> Because you just moves the placement of pointer from memmap to
> radix_tree both in GFP_KERNEL, total kernel memory usage is not changed.

Agreed, but we do reduce the sizeof(struct page) without adding on to
page_cgroup's size. So why don't we want this?

> So, at least, you have to add some address calculation (as I did in March)
> to getting address of page_cgroup.

What address calculation do we need, sorry I don't recollect it.

 But page_cgroup itself consumes 32bytes
> per page. Then.....
> 
> My proposal to 32bit system is following 
>  - remove page_cgroup completely.
>    - As a result, there is no per-cgroup lru. But it will not be bad
>      bacause the number of cgroups and pages are not big.
>      just a trade-off between kernel-memory-space v.s. speed.

32 bit systems with PAE can support quite a lot of memory, so I am not sure I
agree. I don't like this approach

>    - Removing page_cgroup and just remember address of mem_cgroup per page.
> 

This is on top of the suggested approach above?

> How do you think ?
> 

I don't like the approach.

-- 
	Balbir
