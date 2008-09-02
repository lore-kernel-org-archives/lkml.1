Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbYIBHgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbYIBHgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 03:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbYIBHfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 03:35:42 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:36314 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751021AbYIBHfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 03:35:41 -0400
Message-ID: <48BCECB5.8070107@linux.vnet.ibm.com>
Date: Tue, 02 Sep 2008 13:05:17 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
References: <20080831174756.GA25790@balbir.in.ibm.com> <48BBAFDD.1000902@openvz.org>  <48BBB326.3080505@linux.vnet.ibm.com> <1220275162.8426.61.camel@twins>
In-Reply-To: <1220275162.8426.61.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-09-01 at 14:47 +0530, Balbir Singh wrote:
>> Pavel Emelyanov wrote:
>>> Balbir Singh wrote:
>>>> This is a rewrite of a patch I had written long back to remove struct page
>>>> (I shared the patches with Kamezawa, but never posted them anywhere else).
>>>> I spent the weekend, cleaning them up for 2.6.27-rc5-mmotm (29 Aug 2008).
>>>>
>>>> I've tested the patches on an x86_64 box, I've run a simple test running
>>>> under the memory control group and the same test running concurrently under
>>>> two different groups (and creating pressure within their groups). I've also
>>>> compiled the patch with CGROUP_MEM_RES_CTLR turned off.
>>>>
>>>> Advantages of the patch
>>>>
>>>> 1. It removes the extra pointer in struct page
>>>>
>>>> Disadvantages
>>>>
>>>> 1. It adds an additional lock structure to struct page_cgroup
>>>> 2. Radix tree lookup is not an O(1) operation, once the page is known
>>>>    getting to the page_cgroup (pc) is a little more expensive now.
>>> And besides, we also have a global lock, that protects even lookup
>>> from this structure. Won't this affect us too much on bug-smp nodes?
>> Sorry, not sure I understand. The lookup is done under RCU. Updates are done
>> using the global lock. It should not be hard to make the radix tree per node
>> later (as an iterative refinement).
> 
> Or you could have a look at the concurrent radix tree, esp for dense
> trees it can save a lot on lock bouncing.
> 
> Latest code available at:
> 
> http://programming.kicks-ass.net/kernel-patches/concurrent-pagecache/27-rc3/

I'll try them later. I see a lot of slab allocations/frees (expected). I am
trying to experiment with alternatives to reduce them.

-- 
	Balbir
