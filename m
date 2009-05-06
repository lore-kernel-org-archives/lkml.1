Return-Path: <linux-kernel-owner+w=401wt.eu-S1761466AbZEFPBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466AbZEFPBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761462AbZEFPAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:00:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37103 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761205AbZEFPAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:00:36 -0400
Message-ID: <4A01A577.2090409@redhat.com>
Date: Wed, 06 May 2009 17:57:59 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       chrisw@redhat.com, device@lanana.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 2/6] ksm: dont allow overlap memory addresses registrations.
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com> <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com> <4A00DD4F.8010101@redhat.com> <4A015C69.7010600@redhat.com> <4A0181EA.3070600@redhat.com> <20090506131735.GW16078@random.random> <Pine.LNX.4.64.0905061424480.19190@blonde.anvils> <20090506140904.GY16078@random.random> <20090506152100.41266e4c@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0905061532240.25289@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0905061532240.25289@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 6 May 2009, Alan Cox wrote:
>   
>>> the max number of ksm pages that can be allocated at any given time so
>>> to avoid OOM conditions, like the swap-compress logic that limits the
>>> swapdevice size to less than ram.
>>>       
>
> (I don't know anything about that swap-compress logic and limitation.)
>
>   
>> Are those pages accounted for in the vm_overcommit logic, as if you
>> allocate a big chunk of memory as KSM will do you need the worst case
>> vm_overcommit behaviour preserved and that means keeping the stats
>> correct.
>>     
>
> As I understand it, KSM won't affect the vm_overcommit behaviour at all.
> Those pages Izik refers to are not allocated up front, they're just a
> limit on the number of process pages which may get held in core at any
> one time, through being shared via the KSM mechanism.
>   

Exactly, this pages are not swappable (now), so we allow the sysadmin to 
control the maximum value of them.
> KSM is not evading vm_committed_space at all, not opening a backdoor
> away from the ordinary mmaps: just collapsing duplicated pages in
> what's been mapped in the usual way, down to single copies.
>
> So the vm_commited_space accounting is exactly as before: it would
> be a bit odd to be running KSM along with OVERCOMMIT_NEVER, but it
> doesn't change its calculations at all - it will and will have to
> be as pessimistic as it ever was.
>
> The only difference would be in how much memory (mostly lowmem)
> KSM's own data structures will take up - as usual, the kernel
> data structures aren't being accounted, but do take up memory.
>
> Hugh
>   

