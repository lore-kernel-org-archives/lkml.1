Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbZD0XNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbZD0XNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbZD0XNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:13:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60594 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbZD0XNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:13:33 -0400
Message-ID: <49F63BC0.9090804@redhat.com>
Date: Tue, 28 Apr 2009 02:12:00 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com,
       mtosatti@redhat.com, hugh@veritas.com
Subject: Re: [PATCH 5/5] add ksm kernel shared memory driver.
References: <1240191366-10029-1-git-send-email-ieidus@redhat.com>	<1240191366-10029-2-git-send-email-ieidus@redhat.com>	<1240191366-10029-3-git-send-email-ieidus@redhat.com>	<1240191366-10029-4-git-send-email-ieidus@redhat.com>	<1240191366-10029-5-git-send-email-ieidus@redhat.com>	<1240191366-10029-6-git-send-email-ieidus@redhat.com> <20090427153421.2682291f.akpm@linux-foundation.org>
In-Reply-To: <20090427153421.2682291f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 20 Apr 2009 04:36:06 +0300
> Izik Eidus <ieidus@redhat.com> wrote:
>
>   
>> Ksm is driver that allow merging identical pages between one or more
>> applications in way unvisible to the application that use it.
>> Pages that are merged are marked as readonly and are COWed when any
>> application try to change them.
>>     
>
> Breaks sparc64 and probably lots of other architectures:
>
> mm/ksm.c: In function `try_to_merge_two_pages_alloc':
> mm/ksm.c:697: error: `_PAGE_RW' undeclared (first use in this function)
>
> there should be an official arch-independent way of manipulating
> vma->vm_page_prot, but I'm not immediately finding it.
>   
Hi,

vm_get_page_prot() will probably do the work.

I will send you patch that fix it,
but first i am waiting for Andrea and Chris to say they are happy with 
small changes that i made to the api after conversation i had with them
(about checking if this api is robust enough so we wont have to change 
it later)

When i will get their acks, i will send you patch against this togather 
with the api (until then it is ok to just leave it only for x86)

changes are:
1) limiting the number of memory regions registered per file descriptor 
- so while (1){ (ioctl(KSM_REGISTER_MEMORY_REGION()) ) wont omm the host

2) checking if memory is overlap in registration (more effective to 
ignore such cases)

3) allow removing specific memoy regions inside fd.

Thanks.


> An alternative (and quite inferior) "fix" would be to disable ksm on
> architectures which don't implement _PAGE_RW.  That's most of them.
>
>   

