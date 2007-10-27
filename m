Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbXJ0GGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbXJ0GGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 02:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXJ0GGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 02:06:09 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38756 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbXJ0GGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 02:06:08 -0400
Message-ID: <4722D516.8020902@linux.vnet.ibm.com>
Date: Sat, 27 Oct 2007 11:35:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Jeff Dike <jdike@addtoit.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86 patch] Fix UML signal.h build errors
References: <20071025130022.8720.77346.sendpatchset@balbir-laptop> <20071025150541.GB5968@c2.user-mode-linux.org> <4720B6E8.4090003@linux.vnet.ibm.com> <20071027031309.GI8181@ftp.linux.org.uk>
In-Reply-To: <20071027031309.GI8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Thu, Oct 25, 2007 at 09:01:52PM +0530, Balbir Singh wrote:
> 
>> Thats nice, I wonder why I missed them searching on lkml in my gmail box
>> :(
>>
>> Is __arch_um__ the right thing to do or BITS_PER_LONG == 32? I prefer
>> BITS_PER_LONG == 32 over #if defined(__i386__) || defined(__arch__um__).
>> I guess its a matter of personal preference.
> 
> Huh?
> 
> a) we really shouldn't mess with compiler defines (i.e. we should not
> undef __i386__ or __x86_64__)
> 

I agree

> b) I'd rather have __arch_um__ mentioned explicitly in 3 places where
> we do care about difference between i386 and uml/i386 than have certain
> to be forgotten rules for places like include/asm-x86
> 
> c) if you look at those places, you'll see
> 	* drivers/char/mem.c::uncached_access().  Really per-architecture
> and I wonder if it might be include/asm-* fodder...
> 	* kernel/signal.c debugging printks.  Should die or be sanitized, IMO.
> 	* raid6 algorithms.  Hell knows - immediate reason why we don't do
> those on uml is the lack of kernel_fpu_begin()/kernel_fpu_end() (and
> boot_cpu_has(), but that's easier to add).  Do we care to implement that
> stuff?
> 

I suspect that list might grow and anybody writing i386 or x86_64 code
will need to double check if the code will work under __arch_um__.
Probably worth documenting somewhere.

> That's _all_.  Nothing else has to care.
> 

:-)

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
