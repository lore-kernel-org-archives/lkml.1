Return-Path: <linux-kernel-owner+w=401wt.eu-S1030622AbXDWDuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030622AbXDWDuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 23:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030656AbXDWDuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 23:50:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030622AbXDWDui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 23:50:38 -0400
Message-ID: <462C2F33.8090508@redhat.com>
Date: Sun, 22 Apr 2007 23:59:47 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>,
       jakub@redhat.com, drepper@redhat.com
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com>	<20070420135715.f6e8e091.akpm@linux-foundation.org>	<462932BE.4020005@redhat.com> <20070420150618.179d31a4.akpm@linux-foundation.org> <4629524C.5040302@redhat.com> <462ACA40.8070407@yahoo.com.au> <462B0156.9020407@redhat.com> <462BFAF3.4040509@yahoo.com.au> <462C2DC7.5070709@redhat.com>
In-Reply-To: <462C2DC7.5070709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Nick Piggin wrote:
>> Rik van Riel wrote:
>>> Nick Piggin wrote:
>>>
>>>> Rik van Riel wrote:
>>
>>>>> Here are the transactions/seconds for each combination:
> 
> I've added a 5th column, with just your mmap_sem patch and
> without my madv_free patch.  It is run with the glibc patch,
> which should make it fall back to MADV_DONTNEED after the
> first MADV_FREE call fails.
> 
>>>>>    vanilla   new glibc  madv_free kernel   madv_free + mmap_sem  
>>>>> mmap_sem
>>>>> threads
>>>>>
>>>>> 1     610         609             596                545         534
>>>>> 2    1032        1136            1196               1200        1180
>>>>> 4    1070        1128            2014               2024        2027
>>>>> 8    1000        1088            1665               2087        2089
>>>>> 16    779        1073            1310               1999        2012

Now that I think about it - this is all with the rawhide kernel
configuration, which has an ungodly number of debug config
options enabled.

I should try this with a more normal kernel, on various different
systems.

It would also be helpful if other people tried this same benchmark,
and others, on their systems.

