Return-Path: <linux-kernel-owner+w=401wt.eu-S1763646AbYFGSjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763646AbYFGSjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 14:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761869AbYFGSjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 14:39:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46443 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760860AbYFGSjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 14:39:35 -0400
Message-ID: <484AD50E.1080601@kernel.org>
Date: Sat, 07 Jun 2008 11:35:58 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Stable Kernel <stable@kernel.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: set PAE PHYSICAL_MASK_SHIFT to match 64-bit
References: <4848046A.5060006@goop.org> <484823BD.76E4.0078.0@novell.com> <4848096D.9010603@goop.org> <48481846.6060407@kernel.org> <48485732.4090203@goop.org>
In-Reply-To: <48485732.4090203@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> It should either be 52 bits or dynamic based on CPUID information.  
>> The latter is very expensive.
> 
> I'm more concerned that it might not be possible.  I'm trying to think 
> how many places have compile-time constants derived from this mask.  
> Maybe not too many.
> 
>> If there end up being additional control bits assigned in this space 
>> we won't use them  since we know the size of the address space (which 
>> won't include the control bits) and thus will leave them at zero.
> 
> You mean, if new bits appear we can just adjust the mask accordingly to 
> avoid them?  And if we don't use them, then they'll be zero?

Correct. Remember, the page table entries come from the kernel - not 
from some random areas.

>> It's largely theoretical, since I believe Linux on x86-64 relies on 
>> virtual >= physical+N, where I believe N is about 3 bits, and the page 
>> table format or page size need to change to support more than 48 bits 
>> of virtual address space.
> 
> I don't see any relationship between the physical and virtual size.  
> Certainly virtual is fixed at 48 bits (4*9+12), but I don't think 
> there's any deep reason why physical needs to be within 3 bits.
> 

Identity-mapping.  1 bit goes to kernel/user split, then the kernel area 
is split into multiple regions, one of which is identity-mapping.  It 
may be just 2.

	-hpa
