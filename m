Return-Path: <linux-kernel-owner+w=401wt.eu-S933093AbXAYAXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093AbXAYAXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933097AbXAYAXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:23:40 -0500
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:39975 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933093AbXAYAXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:23:40 -0500
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jan 2007 19:23:39 EST
From: Paul Cameron Davies <pauld@cse.unsw.EDU.AU>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Thu, 25 Jan 2007 11:17:22 +1100 (EST)
X-X-Sender: pauld@weill.orchestra.cse.unsw.EDU.AU
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Page Table cleanup patch
In-Reply-To: <45B6CE8C.8010807@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0701251116040.4081@weill.orchestra.cse.unsw.EDU.AU>
References: <20070124023828.11302.51100.sendpatchset@weill.orchestra.cse.unsw.EDU.AU>
 <45B6CE8C.8010807@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick

On Wed, 24 Jan 2007, Nick Piggin wrote:

> Paul Davies wrote:
>> This patch is a proposed cleanup of the current page table organisation.
>> Such a cleanup would be a logical first step towards introducing at least
>> a partial clean page table interface, geared towards providing enhanced 
>> virtualization oportunities for x86.  It is also a common sense cleanup in 
>> its own right.
>>
>>  * Creates mlpt.c to hold the page table implementation currently held 
>> in memory.c.
>>  * Adjust Makefile  * Move implementation dependent page table code out of 
>> include/linux/mm.h into include/linux/mlpt-mm.h
>>  * Move implementation dependent page table code out of 
>> include/asm-generic/pgtable.h to include/asm-generic/pgtable-mlpt.h
>> 
>> mlpt stands from multi level page table.
>
> Hi Paul,
>
> I'm not sure that I see the point of this patch alone, as there is still
> all the mlpt implementation details in all the page table walkers. Or
> did you have a scheme to change implementations somehow just using the
> p*d_addr_next?

This patch alone doesn't acheive nearly enough.  Separating out as much
implementation (without tackling the walkers) would be a start though.
The MLPT appears to be intrinsic to the kernel owing to its open coding, 
and starting to isolate its implementation (even partially) is an 
important step towards destroying this misconception.

I strongly prefer not to go down the path of using a scheme to change 
implementations with p*d_addr_next.  I tried this kind of thing early on 
and it was horribly ugly.  There are far cleaner ways to do it.

Cheers

Paul Davies
