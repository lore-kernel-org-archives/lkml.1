Return-Path: <linux-kernel-owner+w=401wt.eu-S1764126AbXHDMXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764126AbXHDMXN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 08:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbXHDMW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 08:22:59 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:35487 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751269AbXHDMW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 08:22:58 -0400
Message-ID: <46B46C38.5050206@vmware.com>
Date: Sat, 04 Aug 2007 05:08:24 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Iouri Kharon <bc-info@styx.cabel.net>, syslinux@zytor.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sahil Rihan <srihan@vmware.com>
Subject: Re: Vmware crashes if compress/misc.c scrolls?
References: <4679BBCB.2000202@zytor.com> <46B40504.70208@vmware.com> <200708041124.35526.ak@suse.de>
In-Reply-To: <200708041124.35526.ak@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> In the boot decompressor for the kernel in the image Iouri provided, I
>>     
>
> 32bit or 64bit image?
>
>   
>> As you can plainly see, the call to memcpy (which is redefined in
>> boot/compressed/misc.c) is made using stack calling convention.
>> Unfortunately, the compiler generated the memcpy function itself using
>> regparm(3) convention.  I am guessing this happened because a leftover
>>     
>
> I can't find any here grepping .i files and includes. None of the memcpy
> prototypes in include have a __fastcall
>
> Are you sure this still happens in mainline?
>
> When I look at my scroll it also looks correct:
>
>       c0:       0f af f8                imul   %eax,%edi
>       c3:       01 c0                   add    %eax,%eax
>       c5:       89 c2                   mov    %eax,%edx
>       c7:       01 f2                   add    %esi,%edx
>       c9:       89 45 f0                mov    %eax,0xfffffff0(%ebp)
>       cc:       89 f0                   mov    %esi,%eax
>       ce:       89 f9                   mov    %edi,%ecx
>       d0:       e8 7b ff ff ff          call   50 <memcpy>
>
>
>   
>> Does anyone recall compiler problems (I noticed this VM was booting a
>> 64-bit kernel, 
>>     
>
> Ok 64bit, that was 32bit above. 
>
> Since some time the decompressor is 64bit and 64bit always uses 
> regparms. 64bit Scroll is ok too:
>
>      92:       0f af eb                imul   %ebx,%ebp
>       95:       01 db                   add    %ebx,%ebx
>       97:       48 63 f3                movslq %ebx,%rsi
>       9a:       4c 01 ee                add    %r13,%rsi
>       9d:       89 ea                   mov    %ebp,%edx
>       9f:       e8 9c ff ff ff          callq  40 <memcpy>
>
>
>   
>> but the decompressor was 32-bit code, 
>>     
>
> That must be a old kernel.
>
> Can you people please verify this all still happens with a mainline or
> 2.6.22 kernel? 
>   

It doesn't.

>   
>> so perhaps at some  
>> time the 64-bit makefile or toolchain for Linux had some kind of
>> compiler bug).
>>     
>
> I'm not aware of any such bugs.
>
>   

Me neither, nor do any of my current 32-bit or 64-bit kernels have this 
problem.  I was just wondering if it got fixed deliberately, or if some 
old gcc bug out there could still cause such problems with specific 
toolchains.

I'll look up what version the kernel was; Iouri, can you provide us with 
the binutils / gcc versions used to build your kernel?

Zach
