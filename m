Return-Path: <linux-kernel-owner+w=401wt.eu-S1759932AbXGZOoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932AbXGZOoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbXGZOoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:44:15 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3053 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbXGZOoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:44:14 -0400
Message-ID: <46A8B33E.8010705@shadowen.org>
Date: Thu, 26 Jul 2007 15:44:14 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andy Whitcroft <apw@shadowen.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: 2.6.23-rc1-mm1 sparsemem_vmemamp fix.
References: <20070725040304.111550f4.akpm@linux-foundation.org> <20070726215840.efd7b85f.kamezawa.hiroyu@jp.fujitsu.com> <46A8B22E.1060000@shadowen.org>
In-Reply-To: <46A8B22E.1060000@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> KAMEZAWA Hiroyuki wrote:
>> Fix sparsemem_vmemmap init. sorry if known bug.
>>
>> This patch fixes page table handling in sparsemem_vmammap.
>>
>> Without this, part of vmem_map is not mapped because each section's start addr of
>> mem_map is not aligned to PGD/PMD/PUD. 
>> (In ia64, secion's mem_map size is 3670016bytes. )
>>
>> for example, 
>>
>>  addr     pmd_addr_end(addr_end)         addr + PMD_SIZE
>>   |XXXXXXXXXX|??????????????????????????????|XXXXXXXXXXXXXXXXXX
>>
>>   X ... initialized vmem_map
>>   ? ... not intialized
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I think the code change below is safe enough.  I have not found it easy
> to understand your description above but I think that you are saying
> that if the section we are initialising is bigger than a PMD size, but
> falls offset from the PMD start we will initialise the end of the first
> PMD and the end of the second PMD and so on.  The "start" of the second
> PMD is missed.
> 
> Ahh yes, that I think is what your diagram shows.  Yes this is pretty
> clearly wrong for any sort of offset initialisation, and would be worse
> lower down in the hierachy.  This seems like a clean way to fix the bug.
>  Thanks for finding this.
> 
> Acked-by: Andy Whitcroft <apw@shadowen.org>

Andrew, I'll fold this one into a new version when I get through the
other feedback, but could you pull this into -mm on top for now as its a
boot issue.

-apw
