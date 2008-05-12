Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbYELFXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbYELFXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 01:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbYELFWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 01:22:53 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:39649 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751520AbYELFWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 01:22:53 -0400
Message-ID: <4827D429.6060708@snapgear.com>
Date: Mon, 12 May 2008 15:22:49 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: missing sections for linker script
References: <200805070052.m470qdod017612@goober> <20080511004107.GA2675@uranus.ravnborg.org>
In-Reply-To: <20080511004107.GA2675@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Sam Ravnborg wrote:
> On Wed, May 07, 2008 at 10:52:39AM +1000, Greg Ungerer wrote:
>> Inlucde the missing kcrctab and kcrctab_unused sections into the
>> m68knommu linker script.
>>
>> Signed-off-by: Greg Ungerer <gerg@uclinux.org>
>> ---
>>
>> diff -Naurp linux-2.6.25-rc1/arch/m68knommu/kernel/vmlinux.lds.S linux-2.6.25-rc1-uc0/arch/m68knommu/kernel/vmlinux.lds.S
>> --- linux-2.6.25-rc1/arch/m68knommu/kernel/vmlinux.lds.S	2008-05-06 14:52:00.000000000 +1000
>> +++ linux-2.6.25-rc1-uc0/arch/m68knommu/kernel/vmlinux.lds.S	2008-05-06 16:56:47.000000000 +1000
>> @@ -114,6 +114,16 @@ SECTIONS {
>>  		*(__kcrctab_gpl)
>>  		__stop___kcrctab_gpl = .;
>>  
>> +		/* Kernel symbol table: Normal unused symbols */
>> +		__start___kcrctab_unused = .;
>> +		*(__kcrctab_unused)
>> +		__stop___kcrctab_unused = .;
>> +
>> +		/* Kernel symbol table: GPL-only unused symbols */
>> +		__start___kcrctab_unused_gpl = .;
>> +		*(__kcrctab_unused_gpl)
>> +		__stop___kcrctab_unused_gpl = .;
>> +
>>  		/* Kernel symbol table: GPL-future symbols */
>>  		__start___kcrctab_gpl_future = .;
>>  		*(__kcrctab_gpl_future)
> 
> Hi Greg.
> 
> Any specific reasons why m68knommu does
> not use include/asm-generic/vmlinux-lds.h?
> 
> There are defined there as well as many other common things.

I would very much like to use the common defines in vmlinux-lds.h.

And historically it goes back to wanting to be able to directly
build ROM based kernels. There has been a couple of threads on
this over th years, this one http://lkml.org/lkml/2003/1/21/213
touches on it. I think there is more before this too, but I couldn't
find a link to it just now.

Sebastians patch in this thread goes to resolving this. I haven't
had a good look over it yet though.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
