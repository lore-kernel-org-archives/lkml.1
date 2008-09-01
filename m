Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbYIADm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbYIADm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 23:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYIADmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 23:42:50 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:45425 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbYIADmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 23:42:50 -0400
Message-ID: <48BB64B5.4060208@linux.vnet.ibm.com>
Date: Mon, 01 Sep 2008 09:12:45 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
References: <20080831174756.GA25790@balbir.in.ibm.com> <20080901113918.b6f05ca6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080901113918.b6f05ca6.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Sun, 31 Aug 2008 23:17:56 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> This is a rewrite of a patch I had written long back to remove struct page
>> (I shared the patches with Kamezawa, but never posted them anywhere else).
>> I spent the weekend, cleaning them up for 2.6.27-rc5-mmotm (29 Aug 2008).
>>
>> I've tested the patches on an x86_64 box, I've run a simple test running
>> under the memory control group and the same test running concurrently under
>> two different groups (and creating pressure within their groups). I've also
>> compiled the patch with CGROUP_MEM_RES_CTLR turned off.
>>
>> Advantages of the patch
>>
>> 1. It removes the extra pointer in struct page
>>
>> Disadvantages
>>
>> 1. It adds an additional lock structure to struct page_cgroup
>> 2. Radix tree lookup is not an O(1) operation, once the page is known
>>    getting to the page_cgroup (pc) is a little more expensive now.
>>
>> This is an initial RFC for comments
>>
>> TODOs
>>
>> 1. Test the page migration changes
>> 2. Test the performance impact of the patch/approach
>>
>> Comments/Reviews?
>>
> BTW, how deep this radix-tree on 4GB/32GB/64GB/256GB machine ?

Good Question,

My ball-park estimates are

number of pfns = RADIX_TREE_TAG_LONGS/(RADIX_TREE_TAG_LONGS - 1) *
(RADIX_TREE_LONGS^n - 1)

and "n" is the number we are looking for.

For a 64 bit system with 256 GB and 4KB page size, I've calculated it to be 9
levels deep.

-- 
	Balbir
