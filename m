Return-Path: <linux-kernel-owner+w=401wt.eu-S932678AbYEHXzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbYEHXzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbYEHXzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:55:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60105 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbYEHXzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:55:15 -0400
Message-ID: <482392C4.7080901@zytor.com>
Date: Thu, 08 May 2008 16:54:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Rufus & Azrael <rufus-azrael@numericable.fr>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem
 error
References: <924EFEDD5F540B4284297C4DC59F3DEE010050B6@orsmsx423.amr.corp.intel.com> <482217F3.2040900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010057B4@orsmsx423.amr.corp.intel.com> <4822A6F7.7010704@numericable.fr> <B5B0CFF685D7DF46A05CF1678CFB42ED20E04609@orsmsx423.amr.corp.intel.com> <20080508192555.GA8643@linux-os.sc.intel.com> <48235DA1.5060809@numericable.fr> <20080508213722.GA28372@linux-os.sc.intel.com> <482373C5.1060202@zytor.com> <20080508215931.GA5035@jamoon.sc.intel.com> <20080508234016.GA14169@linux-os.sc.intel.com>
In-Reply-To: <20080508234016.GA14169@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> On Thu, May 08, 2008 at 02:59:31PM -0700, Venkatesh Pallipadi wrote:
>>>
>> I agree we need a better range check in place. But, the current one was not
>> really doing anything useful and actually causing the side-effect
>> regression. So, I felt not having it is better solution for now.
>>
>> Other solution is to stay with start and end range check and just ignore the
>> range check error with WC overlap in case where UC_MINUS is requested.
>>
>> Given the way MTRRs are defined, the only way to do the full range check
>> seems to be to go over page by page (from start to end), and check which
>> variable range MTTR it matches with, which is obviously very excessive. As,
>> this is not a problem in typical usage scenario.
>>

I don't believe that is true in the slightest.  You can iterate over the 
variable MTRRs and see if any part of them overlaps the target range; 
doing exhaustive enumeration is clearly bogus, especially on 64-bit 
platforms.

> 
> Also, note that we only look for start while looking at fixed range MTRRs.
> This is not as scary as it seems. We are finding the effective memory type
> by just looking at the start of the address range. We still go through
> the PAT reserve free mechanism, once we find the effective memory type
> and that list will catch any other users with conflicting type anywhere
> in the start to end range. And we will still keep effective type consistent
> across all mappings.
> 

So what you're saying here is "it's bogus, but it doesn't really matter 
anyway?"  Why bother having it at all, then?

Seriously, if it's not unconditionally correct, then:

a. it should be *clearly* labelled a heuristic.
b. it should be *clearly* explained why having the heuristic is much 
better than not having anything.

In this case, neither of those conditions appear to be addressed.

	-hpa
