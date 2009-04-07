Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZDGPdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZDGPdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbZDGPdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:33:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:37716 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbZDGPdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:33:43 -0400
Cc: beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       jeremy@goop.org, ian.campbell@citrix.com
Message-Id: <9C76D5F2-5D3C-4499-B358-129428FA6F33@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090407180928Y.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 5/7] swiotlb: (re)Create swiotlb_unmap_single
Date: Tue, 7 Apr 2009 10:32:20 -0500
References: <1238810209-24499-6-git-send-email-beckyb@kernel.crashing.org> <20090407112247W.fujita.tomonori@lab.ntt.co.jp> <FCEB8195-191B-4835-B895-D70C19DE23DE@kernel.crashing.org> <20090407180928Y.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 7, 2009, at 4:09 AM, FUJITA Tomonori wrote:

> On Tue, 7 Apr 2009 01:34:44 -0500
> Kumar Gala <galak@kernel.crashing.org> wrote:
>
>>
>> On Apr 6, 2009, at 9:24 PM, FUJITA Tomonori wrote:
>>
>>> On Fri,  3 Apr 2009 20:56:47 -0500
>>> Becky Bruce <beckyb@kernel.crashing.org> wrote:
>>>
>>>> This mirrors the current swiotlb_sync_single() setup
>>>> where the swiotlb_unmap_single() function is static to this
>>>> file and contains the logic required to determine if we need
>>>> to call actual sync_single.  Previously, swiotlb_unmap_page
>>>> and swiotlb_unmap_sg were duplicating very similar code.
>>>> The duplicated code has also been reformatted for
>>>> readability.
>>>>
>>>> Note that the swiotlb_unmap_sg code was previously doing
>>>> a complicated comparison to determine if an addresses needed
>>>> to be unmapped where a simple is_swiotlb_buffer() call
>>>> would have sufficed.
>>>>
>>>> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
>>>> ---
>>>> lib/swiotlb.c |   36 +++++++++++++++++++++++-------------
>>>> 1 files changed, 23 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
>>>> index af2ec25..602315b 100644
>>>> --- a/lib/swiotlb.c
>>>> +++ b/lib/swiotlb.c
>>>
>>> I don't think 'swiotlb_unmap_single' name is appropriate.
>>>
>>> swiotlb_unmap_single sounds like an exported function that IOMMUs  
>>> can
>>> use (and it was) however it should not be.
>>
>> What do you suggest we call it?  __swiotlb_unmap_single.
>
> I think that __swiotlb_unmap_single is better because the name implies
> that it's an internal function. It's fine by me.
>
> If it is odd that __swiotlb_unmap_single() is just a wrapper function
> of unmap_single(), which does the real job to unmap a dma mapping, it
> might be another possible option to rename unmap_single to
> do_unamp_single and use unmap_single.

I think you lost me here.  I'd prefer to just use  
__swiotlb_unmap_single at this point and get this code into the tree  
and work on such renaming after the fact (if that's ok).

- k
