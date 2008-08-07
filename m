Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbYHGVwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbYHGVwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYHGVwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:52:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46537 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYHGVwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:52:24 -0400
Message-ID: <489B6E83.7000202@kernel.org>
Date: Thu, 07 Aug 2008 14:52:03 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org>	 <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>	 <489B6A5C.8030400@kernel.org> <1218145344.20178.347.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1218145344.20178.347.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
>>>
>> Okay, you lost me about halfway through that... could you perhaps
>> describe the problem from the beginning, exactly what you're trying to do?
> 
> A kernel compiled with VMI enabled may run on a non-VMI platform.  If
> that is the case, the fixmap should not be relocated.  If however, a VMI
> ROM is found, we need to hijack up to 64-MB of linear address space from
> the top of memory down.  This means moving the fixmap down by the same
> amount.
> 

I take it there are no alternatives other than putting this at the end 
of memory?

> Right now the code is structured in such a way that it wants to know how
> much physical memory there is, so it can register a mapping table for
> mapping linear addresses in the lowmem area to physical addresses.  This
> causes the code to depend on max_low_pfn being initialized, which
> accounts for the current placement.
> 
> But it also must be called before anything that creates the fixmap,
> because the same code which registers the linear address mapping also
> reserves high memory above the fixmap.
> 
> My point is 1) these could be two separate calls, or 2) the lowmem
> mapping table need not depend on max_low_pfn at all, it is safe to
> create an extra large mapping which covers all possible lowmem instead
> of the physical ram that is actually available.

Realistically speaking, any (virtual) machine which does *not* have a 
full complement of lowmem (i.e. less than 896 MB in the common case) 
will not suffer significatly from losing a few megabytes of address space.

	-hpa

