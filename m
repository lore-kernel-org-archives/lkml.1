Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbZCPSWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbZCPSWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbZCPSWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:22:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbZCPSWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:22:19 -0400
Message-ID: <49BE97D5.4010002@zytor.com>
Date: Mon, 16 Mar 2009 11:17:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org> <49BE84D6.3010006@kernel.org> <49BE9248.6050707@goop.org>
In-Reply-To: <49BE9248.6050707@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Yinghai Lu wrote:
>> could be max_pfn_mapped change in head_32.S that reduce mapping range 
>> to _end only.
>>   
> 
> Yes, I would say you're right.  Trimming the mapping to _end only leaves 
> the space under the kernel avaliable for allocating pagetable from e820 
> space.  In this case we've got DEBUG_PAGEALLOC enabled, which inhibits 
> the use of PSE, and BIOS corruption checking on, which eats a chunk of 
> low memory.  In combination, there's only 0x8f000 bytes free below the 
> kernel, and it needs 0xe1000 to allocate for pagetables.
> 
> Reverting 2bd2753ff46346543ab92e80df9d96366e21baa5 fixes the problem for 
> me, though it does result in a kernel with a 73MB BSS...
> 

Waitaminute... there is no way we could end up with 73 MB page tables 
unless something is seriously screwy.  Even with PAE and !PSE, we only 
get 2 MB worth of page tables for each 1 GB mapped -- even with a 4:4 
scheme this is only 8 MB.

	-hpa

