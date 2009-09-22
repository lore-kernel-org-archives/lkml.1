Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbZIVNFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbZIVNFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbZIVNFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:05:10 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:60371 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442AbZIVNFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:05:08 -0400
Message-ID: <4AB8CB81.4080309@in.ibm.com>
Date: Tue, 22 Sep 2009 18:35:05 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie> <20090921174656.GS12726@csn.ul.ie> <alpine.DEB.1.10.0909211349530.3106@V090114053VZO-1> <20090921180739.GT12726@csn.ul.ie> <4AB85A8F.6010106@in.ibm.com> <20090922125546.GA25965@csn.ul.ie>
In-Reply-To: <20090922125546.GA25965@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Tue, Sep 22, 2009 at 10:33:11AM +0530, Sachin Sant wrote:
>   
>> Mel Gorman wrote:
>>     
>>> On Mon, Sep 21, 2009 at 01:54:12PM -0400, Christoph Lameter wrote:
>>>   
>>>       
>>>> Lets just keep SLQB back until the basic issues with memoryless nodes are
>>>> resolved.
>>>>     
>>>>         
>>> It's not even super-clear that the memoryless nodes issues are entirely
>>> related to SLQB. Sachin for example says that there was a stall issue
>>> with memoryless nodes that could be triggered without SLQB. Sachin, is
>>> that still accurate?
>>>   
>>>       
>> I think there are two different problems that we are dealing with.
>>
>> First one is the SLQB not working on a ppc64 box which seems to be specific
>> to only one machine and i haven't seen that on other power boxes.The patches
>> that you have posted seems to allow the box to boot, but eventually it hits
>> the stall issue(related to percpu dynamic allocator not working on ppc64),
>> which is the second problem we are dealing with.
>>
>>     
>
> Ok, I've sent out V3 of this. It's only a partial fix but it's about as
> far as it can be brought until the other difficulties are resolved.
>   
Thanks Mel.

>   
>> The stall issue seems to be much more critical as it is affecting almost
>> all of the power boxes that i have tested with (4 in all).
>> This issue is seen with Linus tree as well and was first seen with
>> 2.6.31-git5 (0cb583fd..) 
>>
>> The stall issue was reported here:
>> http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-September/075791.html
>>
>>     
>
> Can you bisect this please?
>   
The problem seems to have been introduced with
commit ada3fa15057205b7d3f727bba5cd26b5912e350f.

Specifically this patch : 
powerpc64: convert to dynamic percpu allocator

If i revert this patch i am able to boot latest git
on a powerpc box.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

