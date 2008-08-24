Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYHXRp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYHXRp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 13:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYHXRpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 13:45:50 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:28836 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYHXRpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 13:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eVHHfHvxX5WgMmNzhBSOzGhQoLIRVxkWsrV1LjYwLaBaMQjsObJTR/h0oB0+UKen4w
         w49YC1qcE7nMG8e8H2Oi7Zp9HSgAflOc+2NhjxFwyKO19g+0oSSx+KZ++i1B8tDmnVzf
         1YJH3wH+Q8CNIGgTL+MjycTxvJVDekwIhvO/8=
Message-ID: <19f34abd0808241045r37eb8661h3cc688b6f0513777@mail.gmail.com>
Date: Sun, 24 Aug 2008 19:45:48 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123 send_IPI_mask_bitmask+0xc3/0xe0()
Cc: "Dave Jones" <davej@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <19f34abd0808241022j1ab6f3e6qd72b9acba5df4892@mail.gmail.com>
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
	 <19f34abd0808241022j1ab6f3e6qd72b9acba5df4892@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 7:22 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>> Kernel fails to detect cpu1 at all.
> I'm sorry, I _just_ reverted your patch and tested the bare kernel...
> but it still only detects cpu0 :-(
>
> Apart from that, it's also incredibly slow and I get some
> "end_request: I/O error, dev fd0, sector 0" messages. Start-up (init 3
> on a F7) takes closer to 10 minutes. Will now take a closer look at my
> config.
>
> Oh. I _just_ noticed a completely different change -- I added acpi=off
> to my boot line *blush*

Removing acpi=off helps with the CPU detection problem. The kernel is
still really slow, though. From /proc/cpuinfo:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping        : 5
cpu MHz         : 375.000
cache size      : 2048 KB

Why is MHz on 375!? I tried cpufreq-selector, but nothing changed. Maybe

calling  acpi_cpufreq_init+0x0/0x90
initcall acpi_cpufreq_init+0x0/0x90 returned -19 after 0 msecs

There's also this:

SMP: Allowing 2 CPUs, 0 hotplug CPUs

(but CPU hotplug still work, is the line above about something
different, like physical hotplug?)

Apart from that, with your patch applied, hotplug seems to work OK (no
warnings).

Okay, now I used cpufreq-selector to change to "ondemand" governor,
and MHz goes back to 3000. Weird. Why would "performance" governor put
my machine to a constant 375?

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
