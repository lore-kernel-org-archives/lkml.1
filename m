Return-Path: <linux-kernel-owner+w=401wt.eu-S965542AbXBGOxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965542AbXBGOxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965613AbXBGOxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:53:39 -0500
Received: from www.osadl.org ([213.239.205.134]:37309 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965542AbXBGOxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:53:38 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Thomas Gleixner <tglx@linutronix.de>
To: dwalker@mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1170810761.3455.147.camel@dwalker1>
References: <20070206205231.GA25430@elte.hu>
	 <1170795378.3455.31.camel@dwalker1> <20070206210959.GC25430@elte.hu>
	 <1170796999.3455.43.camel@dwalker1> <20070206214131.GA1176@elte.hu>
	 <1170798879.3455.58.camel@dwalker1> <20070206220855.GB5109@elte.hu>
	 <1170801742.3455.87.camel@dwalker1> <20070206225650.GA14853@elte.hu>
	 <1170803070.3455.93.camel@dwalker1>  <20070206231421.GA18654@elte.hu>
	 <1170804177.3455.109.camel@dwalker1>  <1170804989.3785.58.camel@chaos>
	 <1170810761.3455.147.camel@dwalker1>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 15:53:50 +0100
Message-Id: <1170860030.3657.9.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 17:12 -0800, Daniel Walker wrote:
> On Wed, 2007-02-07 at 00:36 +0100, Thomas Gleixner wrote:
> 
> > There are no other clock event devices in a PC system at the moment
> > and /proc/interrupt does not care, whether the interrupt was setup for a
> > clock event device or something else. It displays the name which is
> > given in the irqaction struct and does not care what it means. I did not
> > change the name in the IRQ#0 setup, so it still displays "timer" (which
> > can either be PIT or HPET), but this is something the interrupt layer
> > does not know and does not care about.
> 
> So your saying the "timer" entry in /proc/interrupts can be either the
> HPET timer, the PIT timer? Mine says "IO-APIC-edge" which does that map
> to? It's going though the io-apic but it's still the pit ?

IO-APIC: Input/Output Advanced Programmable Interrupt Controller. This
device does not generate interrupts by itself. Devices, which generate
interrupts are connected to it.

23:         82          0   IO-APIC-fasteoi   ohci1394, HDA Intel

This is IRQ#23 coming in via IO-APIC (fasteoi type). The interrupt is
shared by two devices, which identified themself as "ohci1394" and "HDA
Intel" via request_irq(). The interrupt originates from one of those
devices. So it _IS_ going through the IO-APIC, but generated either by
the Firewire device or the Audio device.

  0:     186222          0   IO-APIC-edge      timer

This is IRQ#0 coming in via IO-APIC (edge type). The interrupt is not
shared. The device identified itself as "timer" via setup_irq(). The
interrupt originates from this device. The interrupt is either caused by
PIT or HPET via a hardware switch mechanism, which is activated when you
use HPET. There is no way to share IRQ#0 here. It's either or as defined
by hardware magic.

	tglx



