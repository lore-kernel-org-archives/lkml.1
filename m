Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYBWJSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYBWJSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 04:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYBWJSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 04:18:09 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57000 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbYBWJSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 04:18:07 -0500
Date: Sat, 23 Feb 2008 10:18:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Q] x86 - boot/header.S
Message-ID: <20080223091817.GC12161@uranus.ravnborg.org>
References: <20080223082026.GA6747@cvg> <86802c440802230044sbfc909t656aadf5729b31c2@mail.gmail.com> <20080223090739.GB6747@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223090739.GB6747@cvg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 12:07:39PM +0300, Cyrill Gorcunov wrote:
> [Yinghai Lu - Sat, Feb 23, 2008 at 12:44:49AM -0800]
> | On Sat, Feb 23, 2008 at 12:20 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | > Hi Peter, Sam,
> | >
> | >  could you take a look on x86/boot/header.S:280 please?
> | >
> | >  # Zero the bss
> | >         movw    $__bss_start, %di
> | >         movw    $_end+3, %cx
> | >         xorl    %eax, %eax
> | >         subw    %di, %cx
> | >         shrw    $2, %cx
> | >         rep; stosl
> | >
> | >  I wonder why is $_end there instead of $__bss_stop?
> | >  Well, accroding to vmlinux_32.lsd both _end and __bss_stop
> | >  are the same BUT __bss_stop is more convenient methink.
> | >  Would it be usefull to change?
> | 
> | we should have head32.c like head64.c
> | and x86_32_start_kernel.
> | 
> | Eric's patch long time ago...
> | 
> | YH
> | 
> 
> Hi Yinghai,
> 
> thanks for reply BUT that is not the point (or maybe I miss something).
> 
> Look, we only have head64.c - there is no head32.c at all. Both
> vmlinux_32/64.lds defines _end exactly the same as __bss_stop. So in
> code which DO fillup bss section with zeros the prefered name is
> __bss_stop. The only thing I'm trying to say that it would be clean
> naming scheme and I think it would help for further review - instead
> of searching all over x86 files to find _end definition __bss_stop
> tell us WHAT we are zeroing from the code.

We should introduce head32.c and then we can use the exact same function
as 64 bit does:

/* Don't add a printk in there. printk relies on the PDA which is not initialized
   yet. */
static void __init clear_bss(void)
{
        memset(__bss_start, 0,
               (unsigned long) __bss_stop - (unsigned long) __bss_start);
}

This answers your Q.

I already resubmitted Eric's original patch to introduce head32.c as I also
liked the cleanup in two Makefiles.

	Sam
