Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbZCBBDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbZCBBDg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 20:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZCBBD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 20:03:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:42488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbZCBBD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 20:03:26 -0500
Message-ID: <49AB3031.4020500@kernel.org>
Date: Sun, 01 Mar 2009 17:02:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: brk patches..
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>	 <1235785882-17580-4-git-send-email-jeremy@goop.org>	 <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com>	 <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu>	 <49A8EA1A.50802@kernel.org> <49A8ED3D.1060704@kernel.org>	 <49A8F319.3030802@goop.org> <86802c440902281240i11423a95l98e330768ac6ca18@mail.gmail.com> <49AB1FE6.8030300@goop.org>
In-Reply-To: <49AB1FE6.8030300@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Yinghai Lu wrote:
>>> But its no different from what i386 does now to allocate its initial
>>> pagetables.  How does this not break now?
>>>
>>>     
>>
>> it will try to use initial page table af first, and it is not big
>> enough, it will according to e820 and other reserved_early areas to
>> find good positions.
>>   
> 
> head_32.S has no such logic.  It just starts building the kernel
> mappings directly after _end, starting at pg0, and uses as much space as
> it needs.  For a !PSE CPU with a large kernel, that can be quite a lot
> of space.  Only later, when its creating the linear memory mappings,
> does it search around in the e820 tables (which it now has access to)
> for space.

yes, we should have some way to only make initial_pgtable only cover to _end
and put that initial_pagbe before _end.

> 
> The whole point of the brk segment was to have a way of allocating some
> memory very early, before e820 is even available.  If you really think
> this is dangerous, then we can easily extend the bss in the linker
> script to include the brk memory, and release any leftover when we do
> the normal bootmem freeup.  That would also give us a well-defined upper
> limit on how much brk memory can be allocated; its a bit undefined at
> the moment, as it depends on how much slop there is after the kernel
> mapping.

hope later boot loader could check vmlinux size in bzImage (according uncompressed size)
and find good position in RAM for bzImage.

we should find good position for brk with find_e820_area().

YH
