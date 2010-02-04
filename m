Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab0BDPaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:30:22 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39599 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab0BDPaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:30:20 -0500
Date: Thu, 4 Feb 2010 21:00:13 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: jdike@addtoit.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, aarcange@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH] emulate accessed bit for EPT
Message-ID: <20100204153013.GK19641@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100203161103.11e2b572@annuminas.surriel.com>
 <20100204041212.GI19641@balbir.in.ibm.com>
 <4B6ACE5B.9080601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4B6ACE5B.9080601@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2010-02-04 08:40:43]:

> On 02/03/2010 11:12 PM, Balbir Singh wrote:
> >* Rik van Riel<riel@redhat.com>  [2010-02-03 16:11:03]:
> >
> >>Currently KVM pretends that pages with EPT mappings never got
> >>accessed.  This has some side effects in the VM, like swapping
> >>out actively used guest pages and needlessly breaking up actively
> >>used hugepages.
> >>
> >>We can avoid those very costly side effects by emulating the
> >>accessed bit for EPT PTEs, which should only be slightly costly
> >>because pages pass through page_referenced infrequently.
> 
> >Quite a clever implementation, one side effect is that one would see a
> >larger number of minor faults with EPT enabled and an increase in
> >allocation/frees of rmap entries, but that can be easily explained.
> 
> I suspect it won't be very many. I have been monitoring
> /proc/meminfo on my system while testing this patch, and
> it is quite typical that the size of the inactive anon
> list does not change for minutes at a time.
> 
> In other words, no pages are moved onto or off of the
> inactive anon list for several minutes. That corresponds
> to a very small number of minor faults introduced by my
> patch.
> 
> Of course, when the system is swapping, we will have more
> minor faults.  However, minor faults should be less of a
> performance issue than major faults :)
>

I do agree with you. 

-- 
	Balbir
