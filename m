Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYJYIpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYJYIpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 04:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYJYIpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 04:45:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:43401 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYJYIp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 04:45:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=JKTErJwUhNUVl2JnPxMZ8o54gDMpWCaqFtU5gu0B3LD4mM49IycGxEDHoN7HUhAB8N
         M9UvZFsCOJ8uG9n1kZsL/XxPIbJyiGk5UzBmmMC0wSa9JVcMFzAnpKuDq2jJRVtndIOL
         +vqQZ+IBGJixQ1ZaHkI86gAvkLt/cOwYkt3QU=
Message-ID: <86802c440810250145qa09a9ay919203055f8e85f0@mail.gmail.com>
Date: Sat, 25 Oct 2008 01:45:25 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: mathieu.taillefumier@free.fr
Subject: Re: [Bug] pci allocation resources problems on x86_64
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1224879041.49022bc1562bb@imp.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49019FE4.50001@free.fr> <4901A4C2.5020805@free.fr>
	 <200810241131.55129.jbarnes@virtuousgeek.org>
	 <1224879041.49022bc1562bb@imp.free.fr>
X-Google-Sender-Auth: 7f5716c9f561166e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 1:10 PM,  <mathieu.taillefumier@free.fr> wrote:
> Hi,
>
>> Ultimately we need to do better at grabbing space for PCI allocations on x86.
>> I was hoping we'd have some patches in 2.6.28 that would help here, but they
>> weren't ready in time.  Can you file a kernel.org bug for this problem with
>> the files attached?  I'll try to find time to put together some
>> improvements...
>
> yes sure. I will do that this weekend. I already grab some more information
> about this problem by reading docs. The problem seems related to iommu setup
> since it is not activated when the mem < 3G but activated when the mem>3G. I do
> not understand however how the kernel can report more that 4g of memory when
> there are only 4g installed (So I think that the bios is buggy too). I also
> remarked that the size of the /proc/mem file is not what it is intended to be.
> Another supprizing thing is these lines of the dmesg-not-working file
>
> pci 0000:0a:00.0: BAR 0: got res [0x140000000-0x1400007ff] bus [0x140000000-0x14
> 00007ff] flags 0x20200
> pci 0000:0a:00.0: BAR 0: moved to bus [0x140000000-0x1400007ff] flags 0x20200
>
> it seems that the drivers setup some resources that way behind the available
> memory.

looks like that kernel do the right thing...

pci 0000:00:1f.3: BAR 0: got res [0xc2000000-0xc20000ff] bus
[0xc2000000-0xc20000ff] flags 0x20200
pci 0000:00:1f.3: BAR 0: moved to bus [0xc2000000-0xc20000ff] flags 0x20200
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
pci 0000:00:1c.0:   MEM window: 0xf6000000-0xf7ffffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000f0000000-0x000000f1ffffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:06
pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
pci 0000:00:1c.1:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000f2000000-0x000000f3ffffff
pci 0000:07:00.0: BAR 6: got res [0xf4000000-0xf401ffff] bus
[0xf4000000-0xf401ffff] flags 0x27200
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:07
pci 0000:00:1c.2:   IO window: 0x4000-0x4fff
pci 0000:00:1c.2:   MEM window: 0xfa000000-0xfbffffff
pci 0000:00:1c.2:   PREFETCH window: 0x000000f4000000-0x000000f5ffffff
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:08
pci 0000:00:1c.3:   IO window: 0x5000-0x5fff
pci 0000:00:1c.3:   MEM window: 0xc8000000-0xc9ffffff
pci 0000:00:1c.3:   PREFETCH window: 0x000000cc000000-0x000000cdffffff
pci 0000:09:04.0: CardBus bridge, secondary bus 0000:0a
pci 0000:09:04.0:   IO window: 0x006000-0x0060ff
pci 0000:09:04.0:   IO window: 0x006400-0x0064ff
pci 0000:09:04.0:   PREFETCH window: 0xc4000000-0xc7ffffff
pci 0000:09:04.0:   MEM window: 0x140000000-0x143ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:09
pci 0000:00:1e.0:   IO window: 0x6000-0x6fff
pci 0000:00:1e.0:   MEM window: 0xfc200000-0xfc2fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000c4000000-0x000000c7ffffff
...

bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 02 index 0 io port: [2000, 2fff]
bus: 02 index 1 mmio: [f6000000, f7ffffff]
bus: 02 index 2 mmio: [f0000000, f1ffffff]
bus: 02 index 3 mmio: [0, 0]
bus: 06 index 0 io port: [3000, 3fff]
bus: 06 index 1 mmio: [f8000000, f9ffffff]
bus: 06 index 2 mmio: [f2000000, f3ffffff]
bus: 06 index 3 mmio: [0, 0]
bus: 07 index 0 io port: [4000, 4fff]
bus: 07 index 1 mmio: [fa000000, fbffffff]
bus: 07 index 2 mmio: [f4000000, f5ffffff]
bus: 07 index 3 mmio: [0, 0]
bus: 08 index 0 io port: [5000, 5fff]
bus: 08 index 1 mmio: [c8000000, c9ffffff]
bus: 08 index 2 mmio: [cc000000, cdffffff]
bus: 08 index 3 mmio: [0, 0]
bus: 09 index 0 io port: [6000, 6fff]
bus: 09 index 1 mmio: [fc200000, fc2fffff]
bus: 09 index 2 mmio: [c4000000, c7ffffff]
bus: 09 index 3 io port: [0, ffff]
bus: 09 index 4 mmio: [0, ffffffffffffffff]
bus: 0a index 0 io port: [6000, 60ff]
bus: 0a index 1 io port: [6400, 64ff]
bus: 0a index 2 mmio: [c4000000, c7ffffff]
bus: 0a index 3 mmio: [140000000, 143ffffff]

because card bus need 0x4000000

resource before that already allocated to 0xce000000

and it can not use 0xd000000, because
pci 0000:00:02.0: found [8086/2a02] class 000300 header type 00
PCI: 0000:00:02.0 reg 10 64bit mmio: [fc000000, fc0fffff]
PCI: 0000:00:02.0 reg 18 32bit mmio: [d0000000, dfffffff]
PCI: 0000:00:02.0 reg 20 io port: [1800, 1807]

so it has to start from 0x140000000 after the RAM...

and that range it can not use that...

only solution could be

Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)

about pci_mem_start from 0xc1000000 instead of 0xc200000

__init void e820_setup_gap(void)
{
        unsigned long gapstart, gapsize, round;
        int found;

        gapstart = 0x10000000;
        gapsize = 0x400000;
        found  = e820_search_gap(&gapstart, &gapsize, 0, MAX_GAP_END);

#ifdef CONFIG_X86_64
        if (!found) {
                gapstart = (max_pfn << PAGE_SHIFT) + 1024*1024;
                printk(KERN_ERR "PCI: Warning: Cannot find a gap in the 32bit "
                       "address range\n"
                       KERN_ERR "PCI: Unassigned devices with 32bit resource "
                       "registers may break!\n");
        }
#endif

        /*
         * See how much we want to round up: start off with
         * rounding to the next 1MB area.
         */
        round = 0x100000;
        while ((gapsize >> 4) > round)
                round += round;
        /* Fun with two's complement */
        pci_mem_start = (gapstart + round) & -round;

        printk(KERN_INFO
               "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
               pci_mem_start, gapstart, gapsize);
}


please check if you can change memhole size in BIOS... if not, we can
have more patch for it....make pci_mem_start more compact...

YH
