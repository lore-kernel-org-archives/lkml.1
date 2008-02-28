Return-Path: <linux-kernel-owner+w=401wt.eu-S1763061AbYB1Tcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763061AbYB1Tcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761284AbYB1TcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:32:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43095 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760702AbYB1TcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:32:10 -0500
Message-ID: <47C70C01.4020605@zytor.com>
Date: Thu, 28 Feb 2008 11:31:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
References: <20080227221033.GR17932@hjernemadsen.org> <20080228091639.GB1133@elte.hu> <20080228092846.GC17932@hjernemadsen.org> <20080228094000.GA2987@elte.hu> <20080228150444.GG17932@hjernemadsen.org> <47C6F4F9.90700@zytor.com> <20080228192404.GH17932@hjernemadsen.org>
In-Reply-To: <20080228192404.GH17932@hjernemadsen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Klaus S. Madsen wrote:
>>
>> Typically, when the kernel reflects an error in VM86 mode it will update 
>> the structure in memory (in your case, the vm86plus_struct) to reflect 
>> the context.  Would it be possible for you to read it out?
> Hmm. As far as I can tell, its actually using the vm86old system call?
> That's at least what the comment in libx86 states.
> 
> However the contents of struct vm86_struct after the segfault is:
> 
> (gdb) print context.vm
> $2 = {regs = {ebx = 0, ecx = 0, edx = 0, esi = 0, edi = 0, ebp = 0, 
>     eax = 20227, __null_ds = 0, __null_es = 0, __null_fs = -1071579136, 
>     __null_gs = 0, orig_eax = -1, eip = 6326, cs = 49152, __csh = 0, 
>     eflags = 209410, esp = 4090, ss = 256, __ssh = 0, es = 0, __esh = 0, 
>     ds = 64, __dsh = 0, fs = 0, __fsh = 0, gs = 0, __gsh = 0}, flags = 0, 
>   screen_bitmap = 0, cpu_type = 0, int_revectored = {__map = {0, 0, 0,0, 0, 
>       0, 0, 2147483648}}, int21_revectored = {__map = {0, 0, 0, 0, 0, 0, 0, 
>       0}}}
> 
> My version of glibc does not seem to have vm86old declared, so I haven't
> tried to remove the assembly code.
> 
> Should I try to change it to use vm86, instead of vm86old?
> 

Yes, that would probably be a good idea.  To some degree, I guess it 
really has nothing to do with the more fundamental issue, but it's 
somewhat odd.

I'll pick apart the state above looking for fishiness as soon as I get 
back from lunch.

	-hpa
