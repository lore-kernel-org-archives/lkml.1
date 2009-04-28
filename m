Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbZD1Qz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbZD1Qz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZD1Qzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:55:46 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:33128 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756035AbZD1Qzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:55:45 -0400
Subject: Re: Default HZ value for X86
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090428003454.08d1660c@lxorguk.ukuu.org.uk>
References: <1240873630.14713.25.camel@alok-dev1>
	 <20090428003454.08d1660c@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 28 Apr 2009 09:55:45 -0700
Message-Id: <1240937745.3831.18.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-04-27 at 16:34 -0700, Alan Cox wrote:
> On Mon, 27 Apr 2009 16:07:10 -0700
> Alok Kataria <akataria@vmware.com> wrote:
> 
> > Hi, 
> > 
> > I was wondering why do we still have the default HZ value as 1000 for
> > the x86 kernels.
> > 
> > arch/x86/configs/i386_defconfig:CONFIG_HZ=1000
> > arch/x86/configs/x86_64_defconfig:CONFIG_HZ=1000
> > 
> > With the highres timer implementation it was planned to move away from
> > relying on high timer interrupt frequency for applications requiring
> > precise high resolution timers.
> 
> With the tickless kernel does this really matter any more ? 

Agreed that with tickless it won't be an issue anymore when the system
is idle, but when the system is loaded the interrupts will still fire at
HZ frequency. 
I ran a simple tight loop to check what kind of effect would the HZ
value have on system performance. This tight loop was run on a 2.6.29
kernel running under VMware looping till count of 6X10^9. 
The one with HZ = 1000 took about 4m 24s, (264sec) 
Total timer interrupts = 264405

And the one with HZ = 100 took about 4m 15s (255sec)
Total timer interrupts = 25593.

Please note that the system was booted in a single user mode and only
the minimal services were running to reduce any interference from any
other process. These numbers are averaged across 3 runs.

The cost of servicing an interrupt would be a little higher in the
virtualized environment, so I am not sure if it would have a similar
impact on a real hardware. 
So this mail is more to understand if there could be any real downsides
with reducing the Hz value, FWIU it shouldn't affect the correctness of
the system right ?

> We might as
> well keep a logical 1000 for convenience and accuracy.

What is the accuracy factor that you are mentioning here ? i guess you
mean the precision of the timeouts, but that shouldn't matter much
right ? 

Thanks,
Alok
> 
> Alan

