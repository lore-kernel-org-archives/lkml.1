Return-Path: <linux-kernel-owner+w=401wt.eu-S933576AbXCOTvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbXCOTvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933588AbXCOTvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:51:37 -0400
Received: from heisenberg.zen.co.uk ([212.23.3.141]:59498 "EHLO
	heisenberg.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576AbXCOTvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:51:36 -0400
X-Greylist: delayed 126986 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Mar 2007 15:51:35 EDT
Message-ID: <45F9A3C1.3000700@gmail.com>
Date: Thu, 15 Mar 2007 19:51:29 +0000
From: Matt Keenan <tank.en.mate@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       bgoglin@free.fr, addy@quadrics.com
Subject: Re: copy_one_pte()
References: <45F6F84D.20302@free.fr>	<20070313191844.GA4206@infradead.org>	<45F7B3BB.1030404@gmail.com> <20070315110634.a2d08dce.akpm@linux-foundation.org>
In-Reply-To: <20070315110634.a2d08dce.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Heisenberg-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc restored.  Please always do reply-to-all).
>
>   
>> On Wed, 14 Mar 2007 08:35:07 +0000 Matt Keenan <tank.en.mate@gmail.com> wrote:
>> Christoph Hellwig wrote:
>>     
>>> On Tue, Mar 13, 2007 at 08:15:25PM +0100, Zoltan Menyhart wrote:
>>>   
>>>       
>>>> I had a look at copy_one_pte().
>>>> I cannot see any ioproc_update_page() call, not even for the COW pages.
>>>> Is it intentional?
>>>>     
>>>>         
>>> There is no such thing as ioproc_update_page in any mainline tree.
>>> You must be looking at some vendor tree with braindead patches applied.
>>>
>>>   
>>>       
>> It looks like this function exists as a part of patches to support 
>> Quadrics NICs / RDMA (HPC platforms).  The patches are there so the 
>> driver doesn't need to pin pages, it can be informed of page updates 
>> directly.  A patch was submitted to l-k sometime in 2005.
>>     
>
> Oh Dear.
>
> Which vendor's kernel are we talking about here?
>   
I don't know of any vendor's kernels that support this (but then I run 
vanilla kernels on Debian).  I just grep'ed for the patch because it 
sounded interesting.  There was a posting for it to l-k on 26th April 
2005 from David Addison of Quadrics Ltd xref 
http://lkml.org/lkml/2005/4/26/198  According to David, you (Andrew) and 
Andrea Arcangeli asked for it to be posted for some feedback, the main 
feedback was on whitespace issues and COWs w.r.t. fork().  Brice Goglin 
made an interesting comment about using a similar method but tracking 
VMAs rather than address spaces.  By the looks of things it never went 
into the mainline kernel.  I lurk a bit (I sometimes miss things) on l-k 
but I hadn't noticed any other methods for dynamic DMA direct to user 
space (other than pinning pages), is there anything planned?

Matt


p.s. I Cc'ed Brice Goglin and David Addison
