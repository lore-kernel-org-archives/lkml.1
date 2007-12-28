Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbXL1VjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbXL1VjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 16:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXL1Vi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 16:38:57 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:20983 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbXL1Vi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 16:38:56 -0500
Date: Fri, 28 Dec 2007 15:37:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
In-reply-to: <4755FA35.5000105@shaw.ca>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
Message-id: <47756C98.3080804@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <47463534.9010100@shaw.ca> <4755D1E4.3020601@garzik.org>
 <4755FA35.5000105@shaw.ca>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Jeff Garzik wrote:
>> Robert Hancock wrote:
>>> This fixes some problems with ATAPI devices on nForce4 controllers in 
>>> ADMA mode
>>> on systems with memory located above 4GB. We need to delay setting 
>>> the 64-bit
>>> DMA mask until the PRD table and padding buffer are allocated so that 
>>> they don't
>>> get allocated above 4GB and break legacy mode (which is needed for ATAPI
>>> devices).
>>>
>>> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
>>
>> This is a bit nasty :/
>>
>> I would consider setting the consistent DMA mask to 32-bit, and 
>> setting the overall mask to 64-bit.
>>
>> Seems like that would solve the problem?
> 
> The issue with that is that it would also constrain the ADMA CPB/PRD 
> table allocation to 32-bit, which I'd rather avoid having to do. There 
> are dual-socket Opteron boxes like HP xw9300 that use this controller, 
> and limiting the allocation to 32-bit could force a non-optimal node 
> allocation for the table memory.
> 
> These type of devices really want a version of dma_alloc_coherent that 
> allows overriding the DMA mask for specific allocations to make this 
> cleaner. I'm sure this isn't the only device that has different DMA mask 
> requirements for different consistent memory allocations..
> 
> This patch does has the advantage of being confirmed to fix the 
> reporter's problem (https://bugzilla.redhat.com/show_bug.cgi?id=351451) 
> which there's something to be said for this late in the .24-rc series..
> 
>>
>> Also, does this need to be rebased on top of what I just pushed upstream?
> 
> It don't think so.. this change is independent from the "sata_nv: don't 
> use legacy DMA in ADMA mode (v3)" patch you just merged.

This bug fix is still outstanding. I haven't heard any more comments on 
this one recently..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

