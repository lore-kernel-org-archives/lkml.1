Return-Path: <linux-kernel-owner+w=401wt.eu-S1030866AbXDMWnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030866AbXDMWnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030869AbXDMWnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:43:23 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:57922 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030866AbXDMWnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:43:22 -0400
Message-ID: <462006DB.5070308@vmware.com>
Date: Fri, 13 Apr 2007 15:40:27 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup
 less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org> <462001A9.3030006@vmware.com> <4620038B.5020700@zytor.com>
In-Reply-To: <4620038B.5020700@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Zachary Amsden wrote:
>> H. Peter Anvin wrote:
>>> +    /*
>>> +     * End condition: we must map up to and including
>>> +     * INIT_MAP_BEYOND_END bytes beyond the end of our
>>> +     * own page tables; 0x1000 is the size of the page
>>> +     * table were about to write, and +0x007 is the
>>> +     * attribute bits.
>>> +     */
>>> +    leal (INIT_MAP_BEYOND_END+0x1000+0x007)(%edi),%ebp
>>>   
>>
>> hrmm?  Shouldn't that still be INIT_MAP_BEYOND_END+0x0007?  Seems you 
>> are mapping 4M more than you need.
>>
>
> 4K, not 4M.  This is an actual address, not an indirection.

Ok, the old code was writing the entire page table, so it was mapping up 
4M more than it should have.  It wasn't clear with 10b out of scope in 
the patch.

>
> However, the expression is correct, because it needs to refer to the 
> termination address *after* the current page table is written -- you 
> can think of it as having already allocated 4K for a page table that 
> it is about to be generated.

Correct.

Acked-by: Zachary Amsden <zach@vmware.com>
