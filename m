Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbZEFIkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbZEFIkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZEFIkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:40:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53619 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbZEFIj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:39:59 -0400
Message-ID: <4A014C7B.9080702@redhat.com>
Date: Wed, 06 May 2009 11:38:19 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, hugh@veritas.com,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 3/6] ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com> <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com> <1241475935-21162-4-git-send-email-ieidus@redhat.com> <4A00DF9B.1080501@redhat.com>
In-Reply-To: <4A00DF9B.1080501@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Izik Eidus wrote:
>> This patch change the KSM_REMOVE_MEMORY_REGION ioctl to be specific per
>> memory region (instead of flushing all the registred memory regions 
>> inside
>> the file descriptor like it happen now)
>>
>> The previoes api was:
>> user register memory regions using KSM_REGISTER_MEMORY_REGION inside 
>> the fd,
>> and then when he wanted to remove just one memory region, he had to 
>> remove them
>> all using KSM_REMOVE_MEMORY_REGION.
>>
>> This patch change this beahivor by chaning the KSM_REMOVE_MEMORY_REGION
>> ioctl to recive another paramter that it is the begining of the virtual
>> address that is wanted to be removed.
>
> This is different from munmap and madvise, which take both
> start address and length.
>
> Why?
>
It work like free, considering the fact that we dont allow memory 
overlay in no way,
If we have the start of the address it is enough for us to know what 
memory we want to remove.

Isnt interface for userspace that work like malloc / free is enough?
