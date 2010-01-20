Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154Ab0ATQgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab0ATQgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 11:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834Ab0ATQgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 11:36:17 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48397 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab0ATQgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 11:36:17 -0500
Date: Wed, 20 Jan 2010 16:35:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: Peter Zijlstra <peterz@infradead.org>, jpihet@mvista.com,
       p.osciak@samsung.com, Jamie Iles <jamie.iles@picochip.com>,
       will.deacon@arm.com,
       =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com, mingo@elte.hu,
       Tomasz Fujak <t.fujak@samsung.com>,
       linux-arm-kernel@lists.infradead.org, m.szyprowski@samsung.com
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event
	description in sysfs
Message-ID: <20100120163525.GE27507@n2100.arm.linux.org.uk>
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com> <1263978999.4283.823.camel@laptop> <op.u6tslipz7p4s8u@pikus> <20100120133145.GE4089@wear.picochip.com> <1263994779.4283.1057.camel@laptop> <20100120135553.GA22897@n2100.arm.linux.org.uk> <1263996080.4283.1064.camel@laptop> <20100120144140.GB22897@n2100.arm.linux.org.uk> <20100120162647.GB7348@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120162647.GB7348@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 04:26:47PM +0000, Jamie Lokier wrote:
> In practice, the list of capabilities works well on x86 in /proc/cpuinfo:
> 
>     flags : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon bts pni monitor vmx est tm2 xtpr pdcm
> 
> They are based on the feature bits from the CPU's cpuid instruction,
> but the kernel does things like apply errata quirks to remove bits
> that don't work on a particular implementation and show the lowest common
> denominator when there are multiple CPUs.

You're assuming that there's a fixed set of feature bits on ARM.  There
aren't.

What you have is a main ID register up until ARMv6, which has about
four different encodings.  On some CPUs, this is the only ID register
offered, and within that subset, some different CPUs (eg, implemented
by different manufacturers, or indeed the same manufacturer) have the
same ID register value, despite being rather different.

>From ARMv6k and later, we have a different ID scheme, where we have
about 10 32-bit registers giving detailed information about various
aspects of the CPU - including five 32-bit registers for details about
the instruction set.

We know that some of the meanings of these registers has changed their
meaning - and I don't think there's a way to identify which meaning
should be applied to the registers (it seems to require reading lots
of different documents to sort out what CPUs implement which method.)

Frankly, it's a mess, and when you look at implementations, it turns out
to be unreliable.

> On ARM, it would be great to have a simple set of features in
> /proc/cpuinfo indicating which instruction sets are available (and
> reliable).

I think you've living in a dream world there.
