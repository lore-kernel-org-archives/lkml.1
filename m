Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbZB1Ga2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbZB1Ga2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 01:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZB1GaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 01:30:15 -0500
Received: from gw.goop.org ([64.81.55.164]:56537 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbZB1GaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 01:30:14 -0500
Message-ID: <49A8D9F2.703@goop.org>
Date: Fri, 27 Feb 2009 22:30:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Simple brk allocator for very early allocations
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <20090227212313.a6b4b43c.akpm@linux-foundation.org>
In-Reply-To: <20090227212313.a6b4b43c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 27 Feb 2009 17:51:17 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> This series adds a very simple brk-like allocator for very early
>> allocations.  By default it extends the bss segment, starting at _end.
>>
>> This is used to allocate x86-32's initial head_32.S pagetable, removing
>> init_pg_table_start/end and pg0, replacing them with brk allocations.
>>     
>
> Changelog fails to provide a reason for this?
>   

Well, the whole thing is just a generalization of what the 32-bit 
pagetable builder does anyway, to make it more useful.  With the brk 
allocator in place, there's no reason for head_32.S to do it again.

>> dmi_alloc() is also changed to use extend_brk.
>>     
>
> Seems a large patchset just to clean up DMI a bit ;)
>   

A few patches could be folded together.  But its pretty small really...

> I assume that xen needs this?  domU or dom0

I can make use of it in Xen to remove a bunch of static arrays.  I'm 
pretty sure there's quite a few places around the kernel which could 
make use of this facility.  My kernel has 900k of bss; how much of that 
is stuff that 1) could be allocated, and 2) not actually being used at 
runtime?  A lot of things which are compile-time sized, hash tables, log 
buffers, etc, could be runtime sized instead.

    J
