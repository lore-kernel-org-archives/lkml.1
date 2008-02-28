Return-Path: <linux-kernel-owner+w=401wt.eu-S1762251AbYB1Tys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762251AbYB1Tys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763878AbYB1Tt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:49:26 -0500
Received: from xspect.dk ([212.97.129.87]:38049 "EHLO xspect.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763062AbYB1TtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:49:22 -0500
Date: Thu, 28 Feb 2008 20:49:20 +0100
From: "Klaus S. Madsen" <ksm@hjernemadsen.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080228194920.GJ17932@hjernemadsen.org>
References: <20080227221033.GR17932@hjernemadsen.org> <20080228091639.GB1133@elte.hu> <20080228092846.GC17932@hjernemadsen.org> <20080228094000.GA2987@elte.hu> <20080228150444.GG17932@hjernemadsen.org> <47C6F4F9.90700@zytor.com> <20080228192404.GH17932@hjernemadsen.org> <47C70C01.4020605@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C70C01.4020605@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 11:31:13 -0800, H. Peter Anvin wrote:
> Klaus S. Madsen wrote:
> >>
> >>Typically, when the kernel reflects an error in VM86 mode it will update 
> >>the structure in memory (in your case, the vm86plus_struct) to reflect 
> >>the context.  Would it be possible for you to read it out?
> >Hmm. As far as I can tell, its actually using the vm86old system call?
> >That's at least what the comment in libx86 states.
> >
> >However the contents of struct vm86_struct after the segfault is:
> >
> >(gdb) print context.vm
> >$2 = {regs = {ebx = 0, ecx = 0, edx = 0, esi = 0, edi = 0, ebp = 0, 
> >    eax = 20227, __null_ds = 0, __null_es = 0, __null_fs = -1071579136, 
> >    __null_gs = 0, orig_eax = -1, eip = 6326, cs = 49152, __csh = 0, 
> >    eflags = 209410, esp = 4090, ss = 256, __ssh = 0, es = 0, __esh = 0, 
> >    ds = 64, __dsh = 0, fs = 0, __fsh = 0, gs = 0, __gsh = 0}, flags = 0, 
> >  screen_bitmap = 0, cpu_type = 0, int_revectored = {__map = {0, 0, 0,0, 
> >  0, 0, 0, 2147483648}}, int21_revectored = {__map = {0, 0, 0, 0, 0, 
> >      0, 0, 0}}}
> >
> >My version of glibc does not seem to have vm86old declared, so I haven't
> >tried to remove the assembly code.
> >
> >Should I try to change it to use vm86, instead of vm86old?
> >
> 
> Yes, that would probably be a good idea.  To some degree, I guess it 
> really has nothing to do with the more fundamental issue, but it's 
> somewhat odd.
Ok. I tried changing the code from the assembly to do:

vm86(VM86_ENTER, vm)

instead. vm the vm86plus_struct structure fill in exactly the same way
as vm86_struct.

The output from GDB after the segfault is exactly the same as
previously, and all the fields in vm86plus_info_struct is zero.

> I'll pick apart the state above looking for fishiness as soon as I get 
> back from lunch.
Great, thanks.

-- 
Kind regards
	Klaus S. Madsen
