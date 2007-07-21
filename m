Return-Path: <linux-kernel-owner+w=401wt.eu-S1762553AbXGUCxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762553AbXGUCxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 22:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbXGUCxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 22:53:06 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:28483 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846AbXGUCxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 22:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t16FDiVueDgCMfPoSGtytUsZnHn5C9ixCwd2zXbMDXenXJxFiXmbenMfoj0MfcGpJP32aWEDxiEUPwYAKdYhaf7kUlz2jjQqKIDr8kT6IAuuSzq6rJ1ErCf7yVKd5Gw3uDBRJWS9M0e7udZrsdMGvXj6Hc5RHGEoXBCj+vVbnRU=
Message-ID: <5d6222a80707201953s11b2c5ceh427a5e345726a6b1@mail.gmail.com>
Date: Fri, 20 Jul 2007 23:53:00 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Mark Tiefenbruck" <mark@fluxbox.org>
Subject: Re: PROBLEM: Dell Inspiron 1501 fails to boot in 2.6.21+
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <c96265a60707201937t39f9b69ep48e76ed61ce1044e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c96265a60707201937t39f9b69ep48e76ed61ce1044e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Mark Tiefenbruck <mark@fluxbox.org> wrote:
> I'd appreciate any help on getting this report sent to the appropriate
> list and, of course, getting this fixed. I don't know what's useful,
> so you're getting everything. This will be a very long e-mail.
>
> My new laptop won't boot with kernel versions 2.6.21 or 2.6.22 . No
> oops. No panic. It just stops printing messages. Maybe it would
> eventually continue if I wait long enough, but it's unacceptable
> either way. I include below the contents of dmesg for a working kernel
> up to the point where it halts. I'm also including what it usually
> does for a few lines after that point.
>
> I did git-bisect on the 2.6.21.y tree. I'm including the result of
> that as well. It mentions HPET, so I should mention my computer also
> fails to boot when I enable HPET in my BIOS. I don't have the details
> of this currently; I can reproduce it again if needed.
>
> I've also included my kernel configuration and ver_linux output.
> You'll notice that my gcc version is 4.2.0, but this also happens with
> 4.1.2. I'm including /proc/cpuinfo and lspci -vvv. I'm including
> /proc/ioports and /proc/iomem. I don't have a /proc/scsi.
>
>   Thanks,
>      Mark
>
>
> Here's the commit that causes the problem:
>
>
>
> e9e2cdb412412326c4827fc78ba27f410d837e6e is first bad commit
> commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Feb 16 01:28:04 2007 -0800
>
>     [PATCH] clockevents: i386 drivers
>
>     Add clockevent drivers for i386: lapic (local) and PIT/HPET
> (global).  Update
>     the timer IRQ to call into the PIT/HPET driver's event handler and the
>     lapic-timer IRQ to call into the lapic clockevent driver.  The
> assignement of
>     timer functionality is delegated to the core framework code and replaces the
>     compile and runtime evalution in do_timer_interrupt_hook()
>
>     Use the clockevents broadcast support and implement the lapic_broadcast
>     function for ACPI.
>
>     No changes to existing functionality.
>
>     [ kdump fix from Vivek Goyal <vgoyal@in.ibm.com> ]
>     [ fixes based on review feedback from Arjan van de Ven
> <arjan@infradead.org> ]
>     Cleanups-from: Adrian Bunk <bunk@stusta.de>
>     Build-fixes-from: Andrew Morton <akpm@osdl.org>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Cc: john stultz <johnstul@us.ibm.com>
>     Cc: Roman Zippel <zippel@linux-m68k.org>
>     Cc: Andi Kleen <ak@suse.de>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
As a wild guess, I'd bet that the rcu queues are failing to get called
(probably some problem with the timer interrupt in the APs?), thus
preventing the system to get into a quiescent state.

It does seem timer related to me. Maybe one of the timer gurus have
any other word on this?

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
