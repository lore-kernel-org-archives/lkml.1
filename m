Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbYIKPFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbYIKPFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYIKPFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:05:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33278 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYIKPFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:05:07 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <14174529.1221145313517.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 12 Sep 2008 00:01:53 +0900 (JST)
To: kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: Re: Re: [RFC] [PATCH 8/9] memcg: remove page_cgroup pointer from memmap
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, xemul@openvz.org, hugh@veritas.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, menage@google.com
In-Reply-To: <33551037.1221143889677.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <33551037.1221143889677.kamezawa.hiroyu@jp.fujitsu.com>
 <200809120000.37901.nickpiggin@yahoo.com.au>
 <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com> <20080911202249.df6026ae.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>On Thursday 11 September 2008 21:22, KAMEZAWA Hiroyuki wrote:
>>> Remove page_cgroup pointer from struct page.
>>>
>>> This patch removes page_cgroup pointer from struct page and make it be abl
e
>>> to get from pfn. Then, relationship of them is
>>>
>>> Before this:
>>>   pfn <-> struct page <-> struct page_cgroup.
>>> After this:
>>>   struct page <-> pfn -> struct page_cgroup -> struct page.
>>
>>So...
>>
>>pfn -> *hash* -> struct page_cgroup, right?
>>
>right.
>
>>While I don't think there is anything wrong with the approach, I
>>don't understand exactly where you guys are hoping to end up with
>>this?
>>
>No. but this is simple. I'd like to use linear mapping like
>sparsemem-vmemmap and HUGTLB kernel pages at the end.
>But it needs much more work and should be done in the future.
>(And it seems to have to depend on SPARSEMEM.)
>This is just a generic one.
>
This is my thinking, now.

Adding a patch for FLATMEM is very easy, maybe. (Just Do as Balbir's one.)

Adding a patch for DISCONTIGMEM is doubtful. I'm not sure how it's widely
used now.

When it comes to SPARSEMEM, our target is 64bit arch and we need 
SPARSEMEM_EXTREME...2 level table. Maybe not far different from current hash.

Our way should be linear mapping like SPARSEMEM_VMEMMAP. But it needs
arch dependent code and some difficulty to allocate virtual space,
which can be very Huge.
This should be updated one by one (for each arch.).

Thanks,
-Kame




