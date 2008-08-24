Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYHXRWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYHXRWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 13:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYHXRWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 13:22:37 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:18189 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbYHXRWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 13:22:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EqzCzW3t+eO5Lr99UQXDB925Nd4z9JbWs2meLd84C1Qw9sLZmLp0HWM/qjEnk9erZf
         tos/F0Pxmmt5yE0PAYfu8fm5A9aC30hFztnSLReYAW/CC4TWqE6fsDOMa+wHwfna+I94
         M04bEbP3tBBtOLpDgg1jWM6c3gyJB+Lv0wYVI=
Message-ID: <19f34abd0808241022j1ab6f3e6qd72b9acba5df4892@mail.gmail.com>
Date: Sun, 24 Aug 2008 19:22:35 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123 send_IPI_mask_bitmask+0xc3/0xe0()
Cc: "Dave Jones" <davej@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <48B19799.6090703@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com>
	 <20080820013930.GN9807@one.firstfloor.org>
	 <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com>
	 <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org>
	 <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com>
	 <48B19799.6090703@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 7:17 PM, H. Peter Anvin <hpa@kernel.org> wrote:
> Vegard Nossum wrote:
>>
>> Hm.
>>
>> Kernel fails to detect cpu1 at all.
>>
>> I am currently unsure of whether it's your patch or not. But it's the
>> same config that I've been booting for ages (and I copy it over for
>> each new kernel version I check out).
>>
>> Processor #0 (Bootup-CPU)
>> I/O APIC #2 Version 32 at 0xFEC00000.
>> Enabling APIC mode:  Flat.  Using 1 I/O APICs
>> Processors: 1
>> SMP: Allowing 1 CPUs, 0 hotplug CPUs
>> mapped APIC to ffffb000 (fee00000)
>> mapped IOAPIC to ffffa000 (fec00000)
>> Allocating PCI resources starting at 50000000 (gap: 40000000:bee00000)
>> PERCPU: Allocating 1221764 bytes of per cpu data
>> NR_CPUS: 7, nr_cpu_ids: 1, nr_node_ids 1
>>
>> I really don't get it. Is this something that can be caused by your
>> patch _at all_ ?
>>
>
> Could you try this patch?  It should (hopefully) tell us if there is any
> such invocations and what the call trace looks like.

I'm sorry, I _just_ reverted your patch and tested the bare kernel...
but it still only detects cpu0 :-(

Apart from that, it's also incredibly slow and I get some
"end_request: I/O error, dev fd0, sector 0" messages. Start-up (init 3
on a F7) takes closer to 10 minutes. Will now take a closer look at my
config.

Oh. I _just_ noticed a completely different change -- I added acpi=off
to my boot line *blush*

Will now remove it and retry your original patch.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
