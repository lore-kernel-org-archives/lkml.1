Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbYKKWgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbYKKWgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYKKWgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:36:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44091 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbYKKWgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:36:05 -0500
Message-ID: <491A08D0.9030502@redhat.com>
Date: Wed, 12 Nov 2008 00:36:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, chrisw@redhat.com,
       izike@qumranet.com
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
 one page into another
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com> <1226409701-14831-2-git-send-email-ieidus@redhat.com> <1226409701-14831-3-git-send-email-ieidus@redhat.com> <20081111114555.eb808843.akpm@linux-foundation.org> <20081111210655.GG10818@random.random> <Pine.LNX.4.64.0811111522150.27767@quilx.com> <4919FB95.4060105@redhat.com> <Pine.LNX.4.64.0811111544350.28346@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0811111544350.28346@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 11 Nov 2008, Avi Kivity wrote:
>
>   
>> Christoph Lameter wrote:
>>     
>>> page migration requires the page to be on the LRU. That could be changed
>>> if you have a different means of isolating a page from its page tables.
>>>
>>>       
>> Isn't rmap the means of isolating a page from its page tables?  I guess I'm
>> misunderstanding something.
>>     
>
> In order to migrate a page one first has to make sure that userspace and
> the kernel cannot access the page in any way. User space must be made to
> generate page faults and all kernel references must be accounted for and
> not be in use.
>
> The user space portion involves changing the page tables so that faults
> are generated.
>
> The kernel portion isolates the page from the LRU (to exempt it from
> kernel reclaim handling etc).
>
>   

Thanks.

> Only then can the page and its metadata be copied to a new location.
>
> Guess you already have the LRU portion done. So you just need the user
> space isolation portion?
>   

We don't want to limit all faults, just writes.  So we write protect the 
page before merging.

What do you mean by page metadata?  obviously the dirty bit (Izik?), 
accessed bit and position in the LRU are desirable (the last is quite 
difficult for ksm -- the page occupied *two* positions in the LRU).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

