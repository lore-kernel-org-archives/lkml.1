Return-Path: <linux-kernel-owner+w=401wt.eu-S934533AbXGKWip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934533AbXGKWip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933187AbXGKWiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:38:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:44095 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932947AbXGKWiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:38:20 -0400
Message-ID: <46955BB1.20200@windriver.com>
Date: Wed, 11 Jul 2007 17:37:37 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Pass -g to assembler under CONFIG_DEBUG_INFO
References: <20070711213012.4D4694D0555@magilla.localdomain>
In-Reply-To: <20070711213012.4D4694D0555@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2007 22:37:38.0613 (UTC) FILETIME=[15B42E50:01C7C40C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> Jason's kgdb tree does
>>
>> AFLAGS		+= -gdwarf2
>>
>> (for all architectures!)  Which is better?
>>     
>
> It makes no difference on any platform I care about.  -g says "turn on the
> default flavor for the target", while -gdwarf2 turns on DWARF flavor even
> if the default is different.  Every target I know anything in particular
> about has DWARF as the default flavor anyway.
>   

The -gdwarf2 had a specific reason. 

I had not looked at the recent gcc 4.1.x + binutils, but in the gcc 
3.x.x compilers when you pass just -g the assembler emitted stabs debug 
data on most archs.  This not only made the debug object files bigger, 
but also the stabs sections were not always parsed correctly in various 
versions of gdb.  I found the dwarf2 sections to be smaller and more 
reliable to allow source level assembly stepping as well as debug frame 
info through the assembly linked functions (ie better back traces).

If it is the case that the gcc 4.1.x + binutils all emit dwarf2 as the 
default you can use just -g.

I'll also take a moment to mention that in the kgdb branch, I also 
modified the top level make file so that you can un-optimize kernel 
modules compiled outside the kernel tree.  I find this this is useful if 
you want to step through significant chunks of code in your kernel 
module IE:

make ARCH=i386 -C KERN_SRC_LOCATION M=/my_mod COMPTIMIZE=-O0

Jason.
