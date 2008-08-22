Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbYHVWaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbYHVWaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 18:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYHVWaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 18:30:10 -0400
Received: from gw.goop.org ([64.81.55.164]:43259 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbYHVWaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 18:30:09 -0400
Message-ID: <48AF3DE9.1050709@goop.org>
Date: Fri, 22 Aug 2008 15:30:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ehabkost@redhat.com, benh@kernel.crashing.org, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1 of 3] add phys_addr_t for holding physical addresses
References: <patchbomb.1219176169@localhost>	<73196c9129c7298f2428.1219176170@localhost>	<20080822130235.af69ccb5.akpm@linux-foundation.org>	<48AF2B74.5030605@goop.org> <20080822143515.512ff182.akpm@linux-foundation.org>
In-Reply-To: <20080822143515.512ff182.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 22 Aug 2008 14:11:16 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Andrew Morton wrote:
>>     
>>> On Tue, 19 Aug 2008 13:02:50 -0700
>>> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>
>>>   
>>>       
>>>> Add a kernel-wide "phys_addr_t" which is guaranteed to be able to hold
>>>> any physical address.  By default it equals the word size of the
>>>> architecture, but a 32-bit architecture can set ARCH_PHYS_ADDR_T_64BIT
>>>> if it needs a 64-bit phys_addr_t.
>>>>
>>>>     
>>>>         
>>> You say this is a bugfix but you don't describe the bug.  This makes it
>>> rather hard to make the 2.6.2[5678] decisions.
>>>
>>> Ditto on [patch 2/3].
>>>   
>>>       
>> 1/3 is not a bugfix in itself, but a pre-requisite for 2/3.
>>
>> 2/3 replaces an ad-hoc Xen fix with a general fix to prevent address
>> truncation when using PFN_PHYS() on any PFN above the 4G mark.  The Xen
>> crash is the only bug I know of that's directly attributable to this,
>> and it was already addressed in older kernels with the casts in the Xen
>> code that this patch removes.
>>
>> So I don't think there's any strong need to push this to earlier kernels.
>>
>>     
>
> Still confused.  The above implies that 2.6.27 doesn't need fixing
> either, because the typecasts already avoid the crash.
>   

Yes, that's true.  It's a bit more of a comprehensive and correct fix; 
I think it's fairly low risk at this point in the -rc series, but it
could be deferred (or just defer 3/3, which really is cosmetic).

    J
