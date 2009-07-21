Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbZGUQF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbZGUQF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZGUQF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:05:58 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:15131 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZGUQF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:05:57 -0400
X-SpamScore: -9
X-BigFish: VPS-9(z1039o34a4jz1432R98dN179dN873fizz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KN53DF-04-0YW-01
Date: Tue, 21 Jul 2009 18:05:38 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Miller <davem@davemloft.net>
CC: fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net, mingo@elte.hu,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       x86@kernel.org, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and
 pci-dma-compat.h
Message-ID: <20090721160538.GL25756@amd.com>
References: <4A5BD7B5.1010904@earthlink.net>
 <20090714103941B.fujita.tomonori@lab.ntt.co.jp>
 <20090714092354.GL19087@amd.com>
 <20090714.131224.205307048.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090714.131224.205307048.davem@davemloft.net>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_Land?=
	=?iso-8859-1?Q?kreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Jul 2009 16:05:38.0525 (UTC) FILETIME=[16BC50D0:01CA0A1D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 01:12:24PM -0700, David Miller wrote:
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Tue, 14 Jul 2009 11:23:55 +0200
> 
> > On Tue, Jul 14, 2009 at 10:40:16AM +0900, FUJITA Tomonori wrote:
> >> On Mon, 13 Jul 2009 20:56:21 -0400
> >> Robert Reif <reif@earthlink.net> wrote:
> >> 
> >> > The bad address is within the kernel so it looks like
> >> > it's catching a real bug.
> >> > 
> >> > cat kallsyms | grep f0007000
> >> > f0007000 T trapbase_cpu3
> >> > 
> >> > WARNING: at lib/dma-debug.c:873 check_for_illegal_area+0xc8/0x100()
> >> > esp ffd7ba30: DMA-API: device driver maps memory from kernel text or 
> >> > rodata [addr=f0007000] [len=4096]
> >> > Modules linked in: ext3 jbd sd_mod sun_esp esp_scsi scsi_transport_spi 
> >> 
> >> Ok, I looked at check_for_illegal_area() in dma-debug.
> >> 
> >> What check_for_illegal_area() does looks bogus to me with some of I/O
> >> remapping hardware.
> > 
> > Can you be more specific about this one? check_for_illegal_area() should
> > not depend on any hardware because all it does is checking the machine
> > addresses to be mapped.
> 
> The check can't work properly on sparc32.
> 
> Sparc32 always maps the kernel to a fixed physical location, and it
> therefore can execute in the identity mapping area of physical memory
> like where all the free pages and kmalloc areas live virtually.
> 
> So if we free up some pages within the kernel image (because the
> memory is unused, for exmple that's what's happening here with the
> extra trap table pages on Robert's machine) we have pages in the free
> page pool that are located right inside of the kernel text, data, etc.
> 
> We'll thus need a way to turn off these checks somehow.  You could
> also augment this check by seeing if there is a backing page, and if
> so, whether it is PageReserved or not.  That's just one idea.

Hmm these checks sound specific and hard to maintain. I think its best
to give architectures the option whether to enable this check or not.

	Joerg


