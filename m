Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZBJIuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZBJIuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 03:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZBJIug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 03:50:36 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:38081 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZBJIuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 03:50:35 -0500
Subject: Re: LS21 + HPET = boot hang (since 2.6.24-rc1)
From: John Stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Clark Williams <williams@redhat.com>
In-Reply-To: <1233974209.7141.7.camel@localhost.localdomain>
References: <1233974209.7141.7.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 00:33:51 -0800
Message-Id: <1234254831.6323.10.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 18:36 -0800, john stultz wrote:
> Hey Thomas, 
> 	Just a heads up, Clark noted that on LS21s if the HPET is enabled in
> the BIOS, recent kernels hang at boot.
> 
> I booted the current -git up after enabling HPET and sure enough:
> 
> ENABLING IO-APIC IRQs
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> ...trying to set up timer (IRQ0) through the 8259A ...
> ..... (found apic 0 pin 2) ...
> ....... failed.
> ...trying to set up timer as Virtual Wire IRQ...
> ..... failed.
> ...trying to set up timer as ExtINT IRQ...
> ..... failed :(.
> Kernel panic - not syncing: IO-APIC + timer doesn't work!  Boot with
> apic=debug and send a report.  Then try booting with the 'noapic'
> option.
> 
> 
> Full boot log attached. Disabling the HPET in the BIOS boots up fine.
> 
> I then did some rough bisection to see when this showed up and
> apparently it hit sometime between 2.6.23 and 2.6.24-rc1.
> 
> I'll do some further bisection on it next week, but if you have any
> quick ideas let me know. 

Hey Thomas,

So I bisected this down to:
commit b8ce33590687888ebb900d09557b8807c4539022
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Oct 12 23:04:07 2007 +0200

    x86_64: convert to clock events

    Finally switch to the clockevents code. Share code with i386 for
    hpet and PIT.

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Chris Wright <chrisw@sous-sol.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>



I'll try to actually look at the change and see what might be the issue
tomorrow. Again, this effects LS21's w/ HPET enabled in the BIOS, but
doesn't seem to effect other HPET systems I tested. Soif you have any
suggestions for getting helpful debug data, let me know.

thanks
-john


