Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbXIQUsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbXIQUsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbXIQUsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:48:33 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:42596 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759157AbXIQUsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:48:30 -0400
Message-ID: <46EEE81A.1010404@linux.vnet.ibm.com>
Date: Tue, 18 Sep 2007 02:18:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH mm] fix swapoff breakage; however...
References: <Pine.LNX.4.64.0709171947130.15413@blonde.wat.veritas.com> <46EED1A7.5080606@linux.vnet.ibm.com> <Pine.LNX.4.64.0709172038090.25512@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0709172038090.25512@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Tue, 18 Sep 2007, Balbir Singh wrote:
>> Hugh Dickins wrote:
>>> More fundamentally, it looks like any container brought over its limit in
>>> unuse_pte will abort swapoff: that doesn't doesn't seem "contained" to me.
>>> Maybe unuse_pte should just let containers go over their limits without
>>> error?  Or swap should be counted along with RSS?  Needs reconsideration.
>> Thanks, for the catching this. There are three possible solutions
>>
>> 1. Account each RSS page with a probable swap cache page, double
>>    the RSS accounting to ensure that swapoff will not fail.
>> 2. Account for the RSS page just once, do not account swap cache
>>    pages
> 
> Neither of those makes sense to me, but I may be misunderstanding.
> 
> What would make sense is (what I meant when I said swap counted
> along with RSS) not to count pages out and back in as they are
> go out to swap and back in, just keep count of instantiated pages
> 

I am not sure how you define instantiated pages. I suspect that
you mean RSS + pages swapped out (swap_pte)?

> I say "make sense" meaning that the numbers could be properly
> accounted; but it may well be unpalatable to treat fast RAM as
> equal to slow swap.
> 
>> 3. Follow your suggestion and let containers go over their limits
>>    without error
>>
>> With the current approach, a container over it's limit will not
>> be able to call swapoff successfully, is that bad?
> 
> That's not so bad.  What's bad is that anyone else with the
> CAP_SYS_ADMIN to swapoff is liable to be prevented by containers
> going over their limits.
> 

If a swapoff is going to push a container over it's limit, then
we break the container and the isolation it provides. Upon swapoff
failure, may be we could get the container to print a nice
little warning so that anyone else with CAP_SYS_ADMIN can fix the
container limit and retry swapoff.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
