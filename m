Return-Path: <linux-kernel-owner+w=401wt.eu-S1763959AbYFFIJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763959AbYFFIJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbYFFIIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:08:51 -0400
Received: from gw.goop.org ([64.81.55.164]:37515 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbYFFIIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:08:49 -0400
Message-ID: <4848F068.5060807@goop.org>
Date: Fri, 06 Jun 2008 09:08:08 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Stable Kernel <stable@kernel.org>
Subject: Re: [PATCH] x86: set PAE PHYSICAL_MASK_SHIFT to match 64-bit
References: <4848046A.5060006@goop.org> <20080605214536.0e289ebb@infradead.org>
In-Reply-To: <20080605214536.0e289ebb@infradead.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 05 Jun 2008 16:21:14 +0100
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> When a 64-bit x86 processor runs in 32-bit PAE mode, a pte can
>> potentially have the same number of physical address bits as the
>> 64-bit host ("Enhanced Legacy PAE Paging").
>>
>>     
>
> the problem on 32 bit is that if you have that much ram, you run out of
> lowmem FAST.... so you have bigger problems.
>   

Sure, you'd have to be barking mad to give a 32-bit system 2^40 bytes of 
RAM.  But under Xen the host's physical addresses are used in guest 
pagetables, so you could have a reasonably sized 32-bit PAE Xen guest be 
exposed to huge host physical addresses.

But the basic point is that, given that Enhanced Legacy PAE Paging 
exists, 36-bits is not  correct, so we should fix it.  And if the 
platform allows addressable hardware to be physically discontigious - 
either memory or devices - then you may end up using large numbers of 
physical bits without having a stupid amount of memory actually present.

    J
