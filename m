Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbZCOX2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbZCOX2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 19:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZCOX2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 19:28:25 -0400
Received: from gw.goop.org ([64.81.55.164]:37976 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZCOX2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 19:28:25 -0400
Message-ID: <49BD8F15.4020301@goop.org>
Date: Sun, 15 Mar 2009 16:28:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu>
In-Reply-To: <20090315212854.GA23960@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Ingo Molnar wrote:
>>     
>>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>
>>>   
>>>       
>>>> H. Peter Anvin wrote:
>>>>     
>>>>         
>>>>> Well, the semantics are different; the .bss section is zeroed while the
>>>>> brk isn't, and the brk symbols don't necessarily point to the data
>>>>> associated with those particular symbols, unlike (of course) the bss.
>>>>>
>>>>> It's not a big issue, obviously, it just seems cleaner to me that way.
>>>>>         
>>>>>           
>>>> OK, I just added a couple of changes to:
>>>>
>>>>    * make the brk reservation symbols have the form ".brk.NAME" to make
>>>>      them inaccessible from C, and to make them look obviously
>>>>      different from normal symbols (more like sections, since it is
>>>>      their size that's more important than their address)
>>>>    * Put all the brk stuff in a .brk section
>>>>    * Mention alignment in the comment for the slop space
>>>>
>>>>    J
>>>>
>>>> The following changes since commit 1e08816af0bc345995c3f26ce4eaba1171ffb531:
>>>>  Ingo Molnar (1):
>>>>        Merge branch 'linus'
>>>>
>>>> are available in the git repository at:
>>>>
>>>>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push/x86/brk
>>>>     
>>>>         
>>> the previous kit in tip:x86/setup-memory is causing crashes. One of 
>>> them is:
>>>
>>> init_memory_mapping: 0000000000000000-00000000377fe000                  
>>>              0000000000 - 00377fe000 page 4k                            
>>>                         Kernel panic - not syncing: Cannot find space 
>>> for the kernel page tables            Pid: 0, comm: swapper Not tainted 
>>> 2.6.29-rc8-tip-02516-g83219b0-dirty #35476        Call Trace:           
>>>                                                                
>>> [<c0128b7b>] panic+0x4b/0x100                                           
>>>             [<c074a989>] init_memory_mapping+0x429/0x430                
>>>                         [<c0cde790>] setup_arch+0x430/0x890             
>>>                                     [<c0148f4e>] ? 
>>> lockdep_init_map+0x2e/0x150                                          
>>> [<c036f392>] ? __spin_lock_init+0x32/0x60                               
>>>             [<c01298d0>] ? printk+0x20/0x30                             
>>>                         [<c0cdc966>] start_kernel+0xc6/0x330            
>>>                                     [<c0cdc321>] 
>>> i386_start_kernel+0x41/0x50               
>>>
>>> full crashlog below, config attached.
>>>   
>>>       
>> What branch is this?  I'm trying to build with your config 
>> with current tip/master w/ tip/x86/setup-memory merged into 
>> it, but "make ARCH=i386 oldconfig" is asking me about 
>> CONFIG_SMP, which makes me think the config file is 
>> incomplete.
>>     
>
> just accept the defaults in 'make oldconfig' and you'll get the 
> right config.
>   

Got some build failures due to warnings treated as errors.  And the 
resulting kernel booted fine under qemu with 1Gbyte of memory.  I'll try 
on real hardware a bit later, but it doesn't seem like something that 
should be affected by qemu vs native, unless it has something to do with 
the specific e820 map.

    J
