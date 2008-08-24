Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbYHXJVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbYHXJVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYHXJUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:20:54 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:5873 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbYHXJUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:20:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OELSatxFnJLZQdCfNPOdgm2sSlTsm/xfgXF5rOZ+JLk9ElH/Pi/c2UnSVNHaT/ICrF
         FRgm9elGhMG8Jk9RZ2dHX9ES2qbusMaIMniHh4PAfeMuK8BkOFR0cT0T3oQcC3avOYPP
         xWTdP/eOlTyhbUOs0rMZEIAl580EdhEVLYxeM=
Message-ID: <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com>
Date: Sun, 24 Aug 2008 11:20:52 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123 send_IPI_mask_bitmask+0xc3/0xe0()
Cc: "Dave Jones" <davej@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <48AE20B8.9000204@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com>
	 <20080820013930.GN9807@one.firstfloor.org>
	 <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com>
	 <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 4:13 AM, H. Peter Anvin <hpa@kernel.org> wrote:
> It seems to be that doing it in smp_call_function_single() would be more
> correct as it's already protected by get_cpu()..put_cpu() and a cpu_online()
> test in there should not be expensive in comparison to the whole rest of the
> code.
>
> You may want to see if this patch fixes the problem; it does *NOT* have the
> correct error behaviour (some of the intervening layers don't propagate
> errors), but it should make the fault go away.

Hm.

Kernel fails to detect cpu1 at all.

I am currently unsure of whether it's your patch or not. But it's the
same config that I've been booting for ages (and I copy it over for
each new kernel version I check out).

Processor #0 (Bootup-CPU)
I/O APIC #2 Version 32 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 1
SMP: Allowing 1 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Allocating PCI resources starting at 50000000 (gap: 40000000:bee00000)
PERCPU: Allocating 1221764 bytes of per cpu data
NR_CPUS: 7, nr_cpu_ids: 1, nr_node_ids 1

I really don't get it. Is this something that can be caused by your
patch _at all_ ?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
