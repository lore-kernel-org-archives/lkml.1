Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbXCZTUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbXCZTUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 15:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932065AbXCZTUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 15:20:39 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:46592 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932067AbXCZTUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 15:20:39 -0400
Message-ID: <46082B05.9050602@vmware.com>
Date: Mon, 26 Mar 2007 12:20:21 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 1/2] i386: add ptep_test_and_clear_{dirty,young}
References: <Pine.LNX.4.64.0703251731040.19025@chino.kir.corp.google.com> <Pine.LNX.4.64.0703260631150.15998@blonde.wat.veritas.com> <4607713F.6010900@vmware.com> <Pine.LNX.4.64.0703260721490.18961@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0703260721490.18961@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Sun, 25 Mar 2007, Zachary Amsden wrote:
>   
>> If you actually clear the bit, you need to:
>>
>> +         pte_update_defer(vma->vm_mm, addr, ptep);
>>
>> The reason is, when updating PTEs, the hypervisor must be notified.  Using
>> atomic operations to do this is fine for all hypervisors I am aware of.
>> However, for hypervisors which shadow page tables, if these PTE modifications
>> are not trapped, you need a post-modification call to fulfill the update of
>> the shadow page table.
>>     
>
> Thanks for the very rapid response.
>
> So, David just needs to move the pte_update_defer out of
> ptep_clear_flush_* and into ptep_test_and_clear_*?
>   

Yes.

> That leaves me wondering why you deleted ptep_test_and_clear_*
> (while leaving their __HAVE_ARCHes) in the first place?
>   

Because raw use of them in the arch independent MM code would introduce 
exactly this bug on i386, so leaving __HAVE_ARCH but leaving out the 
definition would catch this case.

Zach
