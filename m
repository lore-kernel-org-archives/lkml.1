Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbXCQWpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbXCQWpd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 18:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbXCQWpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 18:45:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:4891 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbXCQWpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 18:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nUanre3QA7YdUk8QGiaq2p3w5qY5wIKQFn4EbMjtuGjbilf7IaPNkPGoRiAYy21RfXpM07qXTSbvnvV2OxaeoNOpeb62VgDZsx7/wFrPmNpCcLqp+UUpsd/c1Si0G972HzhIFpcCiYEurDhJsBrCHqjpGBkhNAvw35yhFcCy+lY=
From: Maxim <maximlevitsky@gmail.com>
To: Len Brown <lenb@kernel.org>
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so far
Date: Sun, 18 Mar 2007 00:45:18 +0200
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@infradead.org>
References: <200703161230.03712.maximlevitsky@gmail.com> <1174088686.13341.347.camel@localhost.localdomain> <200703162132.53906.lenb@kernel.org>
In-Reply-To: <200703162132.53906.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703180045.18490.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007 03:32:53 Len Brown wrote:
> On Friday 16 March 2007 19:44, Thomas Gleixner wrote:
> > Maxim,
> > 
> > On Fri, 2007-03-16 at 12:30 +0200, Maxim Levitsky wrote:
> > > 3) Sometimes I get this (once in three boots or so)
> > > 
> > > [   36.217405] ENABLING IO-APIC IRQs
> > > [   36.217587] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> > > [   36.433917] APIC timer disabled due to verification failure.
> > > 
> > > And NO_HZ is disabled due to that (I get 1000/s timer's interrupts)
> > > I haven't investigated that yet.
> > > It looks like another new test that my hardware fails to perform... 
> > 
> > Yes, this is probably caused by SMM code trying to emulate a PS/2
> > keyboard from a (maybe connected or not) USB keyboard. Unfortunately we
> > have no way to disable this BIOS misfeature in the early boot process. 
> > Arjan, Len ?????
> 
> Nope.  By definition, SMM is invisible to the OS -- we don't even
> get a bit that said it occurred (though we'd like one -- it would
> be really helpful to diagnose issues like this one)
> 
> So go into BIOS SETUP and see if there is a USB Legacy Emulation
> feature that you can disable.  Sometimes there is not, but disabling
> onboard USB altogether may help at least prove the issue is in that area.
> 
> > I built in this test to rule out bogus LAPIC timer calibration values
> > which are sometimes off by factor 2-10.
> > 
> > But I also built in a calibration against the PM-Timer, which turned out
> > to be quite reliable and I think the additional verification step is
> > only necessary for sytems without PM-Timer.
> > 
> > That was a bit over cautious from my side. I send a patch to avoid this
> > when PM-Timer is available in a separate mail.
> 
> PM-Timer was invented to work-around the issue that the TSC became unreliable
> in the face of power management on laptops.  In particular, to be able
> to time duration of OS idle where TSC stopped.
> 
> While it is not fine grain, and it is not low-latency, is should
> be very reliable.  My understanding is that it is implemented as
> a simple divider right off the system 14MHz clock -- the signal
> which most motherboard clocks are PLL multiplied up from --
> including the 100MHz front-side bus which drives the LAPIC timer.
> 
> But that said, I don't understand why calibrating the LAPIC timer
> using the PM-timer is going to be more reliable -- exactly how
> and why did the previous calibration scheme fail?
> Maybe I could follow the new logic in apic.c if I saw the "apic=debug"
> output for this box.
> 
> cheers,
> -Len
> 
> 
> 

Hi,

	Yes, usb emulation is enabled, but I need it. I will test without usb emulation, but since it shows only sometimes, 
	I don't know yet whenever usb legacy affects it.

	Regards, 
		Maxim Levitsky
