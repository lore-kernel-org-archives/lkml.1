Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbZCaM3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbZCaM3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbZCaM2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:28:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48917 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbZCaM2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:28:46 -0400
Message-ID: <49D20B63.8020709@redhat.com>
Date: Tue, 31 Mar 2009 15:24:03 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com, riel@redhat.com,
       jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net,
       yaniv@redhat.com, dmonakhov@openvz.org
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
References: <1238457560-7613-1-git-send-email-ieidus@redhat.com> <1238457560-7613-2-git-send-email-ieidus@redhat.com> <1238457560-7613-3-git-send-email-ieidus@redhat.com> <1238457560-7613-4-git-send-email-ieidus@redhat.com> <1238457560-7613-5-git-send-email-ieidus@redhat.com> <49D17C04.9070307@codemonkey.ws>
In-Reply-To: <49D17C04.9070307@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Izik Eidus wrote:
>> Ksm is driver that allow merging identical pages between one or more
>> applications in way unvisible to the application that use it.
>> Pages that are merged are marked as readonly and are COWed when any
>> application try to change them.
>>
>> Ksm is used for cases where using fork() is not suitable,
>> one of this cases is where the pages of the application keep changing
>> dynamicly and the application cannot know in advance what pages are
>> going to be identical.
>>
>> Ksm works by walking over the memory pages of the applications it
>> scan in order to find identical pages.
>> It uses a two sorted data strctures called stable and unstable trees
>> to find in effective way the identical pages.
>>
>> When ksm finds two identical pages, it marks them as readonly and merges
>> them into single one page,
>> after the pages are marked as readonly and merged into one page, linux
>> will treat this pages as normal copy_on_write pages and will fork them
>> when write access will happen to them.
>>
>> Ksm scan just memory areas that were registred to be scanned by it.
>>
>> Ksm api:
>>
>> KSM_GET_API_VERSION:
>> Give the userspace the api version of the module.
>>
>> KSM_CREATE_SHARED_MEMORY_AREA:
>> Create shared memory reagion fd, that latter allow the user to register
>> the memory region to scan by using:
>> KSM_REGISTER_MEMORY_REGION and KSM_REMOVE_MEMORY_REGION
>>
>> KSM_START_STOP_KTHREAD:
>> Return information about the kernel thread, the inforamtion is returned
>> using the ksm_kthread_info structure:
>> ksm_kthread_info:
>> __u32 sleep:
>>         number of microsecoends to sleep between each iteration of
>> scanning.
>>
>> __u32 pages_to_scan:
>>         number of pages to scan for each iteration of scanning.
>>
>> __u32 max_pages_to_merge:
>>         maximum number of pages to merge in each iteration of scanning
>>         (so even if there are still more pages to scan, we stop this
>> iteration)
>>
>> __u32 flags:
>>        flags to control ksmd (right now just ksm_control_flags_run
>>                   available)
>>   
>
> Wouldn't this make more sense as a sysfs interface?

I belive using ioctl for registering memory of applications make it 
easier....
Ksm doesnt have any complicated API that would benefit from sysfs 
(beside adding more complexity)

> That is, the KSM_START_STOP_KTHREAD part, not necessarily the rest of 
> the API.

What you mean?
>
> Regards,
>
> Anthony Liguori
>

