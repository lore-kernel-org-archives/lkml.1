Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZCOFer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZCOFer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 01:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZCOFej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 01:34:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:39659 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZCOFej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 01:34:39 -0400
Message-ID: <49BC933F.3090507@kernel.org>
Date: Sat, 14 Mar 2009 22:33:51 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC5BCF.1070602@zytor.com> <49BC878D.5090402@kernel.org> <49BC8955.5070009@zytor.com>
In-Reply-To: <49BC8955.5070009@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>> H. Peter Anvin wrote:
>>> On this subject, what is the point of the 64 K "slop space", and if it
>>> is necessary, why not just put it as a RESERVE_BRK() somewhere (*with* a
>>>  significant comment as to its necessity) instead of putting it as a
>>> hack in the linker script?
>>>
>>
>> 32bit already have that
>>
>> +INIT_MAP_SIZE = (PAGE_TABLE_SIZE + ALLOCATOR_SLOP) * PAGE_SIZE_asm
>> +RESERVE_BRK(pagetables, INIT_MAP_SIZE)
>>
>> in head_32.S
>>
>> so need to update vmlinux_32.lds.S
>>
> 
> What about 64 bits?  Also, do we really need the "allocator slop", or
> can we push that into the user location, which is where it really
> belongs?  What does use this?

64 bit does not has this problem.
32 bit we already removed bootmem there, that is not needed. 

ALLOCATOR_SLOP is needed...

+ *     (KERNEL_IMAGE_SIZE/4096) / 1024 pages (worst case, non PAE)
+ *     (KERNEL_IMAGE_SIZE/4096) / 512 + 4 pages (worst case for PAE)


YH
