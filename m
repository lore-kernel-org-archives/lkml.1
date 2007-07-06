Return-Path: <linux-kernel-owner+w=401wt.eu-S1763274AbXGFUXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763274AbXGFUXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760499AbXGFUXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:23:10 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:55086 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755175AbXGFUXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:23:09 -0400
Message-ID: <468EA27C.9060401@vmware.com>
Date: Fri, 06 Jul 2007 13:13:48 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org
Subject: Re: [PATCH] VMI: remove CONFIG_DEBUG_PAGE_TYPE and associated	bitrotted
 code
References: <Pine.LNX.4.64.0707060847470.23786@localhost.localdomain> <468E890A.1070504@s5r6.in-berlin.de> <20070706201625.GT4306@sequoia.sous-sol.org>
In-Reply-To: <20070706201625.GT4306@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Stefan Richter (stefanr@s5r6.in-berlin.de) wrote:
>   
>>> -#ifdef CONFIG_DEBUG_PAGE_TYPE
>>> +#if 0 /* debug page type */
>>>       
> <snip>
>   
>> This misnamed CONFIG_DEBUG_PAGE_TYPE (it's not a Kconfig variable) has
>> about 120 lines debug code dangling on it.  So, replacing it by #if 0
>> will hopefully motivate a kind janitor to send a removal patch for that
>> debug code eventually.  I don't do so just now because that code went in
>> between 2.6.20 and 2.6.21-rc1, i.e. not so long ago.
>>     
>
> This is Zach's code, his final call.  I know it was pretty useful early
> on, and used to be an actual Kconfig option for VMI.  However, it's
> completely disconnected; the setup call to vmi_apply_boot_page_allocations
> isn't merged and the page->type field isn't either (no surprise on that),
> and some of the VMI_PAGE_ constants have changed names.  Clearly, it is
> ripe for bitrot (already has !CONFIG_NEED_MULTIPLE_NODES dependency,
> dunno if VMI has the same limitation).  It definitely should not have
> a misleading Kconfig name.  I'd nuke it all rather than #if 0.
>
> thanks,
> -chris
>   

I'd rather keep it, even with bitrot - it was non-trivial to get 
correct, and found many surprises in the code; most notably, it can detect

1) PTE writes to pages not declared as page tables
2) Failure to allocate or de-allocate page tables using the paravirt-ops API
3) PTE writes using the wrong level operations

These are most useful properties; in fact, I would like to extend the 
code for 64-bit paravirt-ops and 4-level paging, so rather not kill it 
until then.

I never merged the whole bit upstream because it added a field to struct 
page.

Zach
