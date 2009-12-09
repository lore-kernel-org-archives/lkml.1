Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZLISuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZLISuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbZLISuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:50:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112AbZLISuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:50:08 -0500
Message-ID: <4B1FF139.2090108@zytor.com>
Date: Wed, 09 Dec 2009 10:49:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
References: <20091203210913.GA24351@elte.hu> <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain> <20091209073632.GD8187@elte.hu> <4B1FED0D.7060003@goop.org>
In-Reply-To: <4B1FED0D.7060003@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2009 10:31 AM, Jeremy Fitzhardinge wrote:
> 
> How does this look?
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git fix-iopl
> 
> From: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
> Date: Wed, 9 Dec 2009 10:26:59 -0800
> Subject: [PATCH] x86: Make sys_iopl use passed-in pt_regs
> 
> Rather than using task_pt_regs, use the pt_regs * passed into the syscall.
> The ABI differences are handled in small 32/64-bit specific functions,
> and everything else is handled in the common do_iopl().
> 
> Signed-off-by: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
> 
> diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
> index 5336ce2..70497f0 100644
> --- a/arch/x86/include/asm/syscalls.h
> +++ b/arch/x86/include/asm/syscalls.h
> @@ -33,11 +33,11 @@ long sys_rt_sigreturn(struct pt_regs *);
>   asmlinkage int sys_set_thread_area(struct user_desc __user *);
>   asmlinkage int sys_get_thread_area(struct user_desc __user *);
> 
> -/* kernel/ioport.c */
> -asmlinkage long sys_iopl(unsigned int);
> -
>   /* X86_32 only */
>   #ifdef CONFIG_X86_32
> +/* kernel/ioport.c */
> +asmlinkage long sys_iopl(struct pt_regs *);
> +
>   /* kernel/process_32.c */

This is the main ugliness that led me to pass up on this in the first
place.  What it really comes down to is that on 32 bits we need the
analogue with what 64 bits have with different stubs for different
number of arguments.

	-hpa
