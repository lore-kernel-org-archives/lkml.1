Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbZGNJYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbZGNJYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZGNJYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:24:12 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:33563
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754115AbZGNJYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:24:10 -0400
X-SpamScore: -8
X-BigFish: VPS-8(z1039o34a4jz1432R98dN1805M873fizz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KMRM3Y-04-B7H-01
Date: Tue, 14 Jul 2009 11:23:55 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: reif@earthlink.net, mingo@elte.hu, davem@davemloft.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       x86@kernel.org, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and
 pci-dma-compat.h
Message-ID: <20090714092354.GL19087@amd.com>
References: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <4A5BD7B5.1010904@earthlink.net>
 <20090714103941B.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090714103941B.fujita.tomonori@lab.ntt.co.jp>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_Land?=
	=?iso-8859-1?Q?kreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 Jul 2009 09:23:55.0088 (UTC) FILETIME=[CF137500:01CA0464]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 10:40:16AM +0900, FUJITA Tomonori wrote:
> On Mon, 13 Jul 2009 20:56:21 -0400
> Robert Reif <reif@earthlink.net> wrote:
> 
> > FUJITA Tomonori wrote:
> > > This is the second version of the patchset to convert SPARC to
> > > asm-generic/dma-mapping-common.h and pci-dma-compat.h:
> > >
> > >   
> > I still get the same runtime warning with this patch set at boot time.
> > 
> > The bad address is within the kernel so it looks like
> > it's catching a real bug.
> > 
> > cat kallsyms | grep f0007000
> > f0007000 T trapbase_cpu3
> > 
> > WARNING: at lib/dma-debug.c:873 check_for_illegal_area+0xc8/0x100()
> > esp ffd7ba30: DMA-API: device driver maps memory from kernel text or 
> > rodata [addr=f0007000] [len=4096]
> > Modules linked in: ext3 jbd sd_mod sun_esp esp_scsi scsi_transport_spi 
> 
> Ok, I looked at check_for_illegal_area() in dma-debug.
> 
> What check_for_illegal_area() does looks bogus to me with some of I/O
> remapping hardware.

Can you be more specific about this one? check_for_illegal_area() should
not depend on any hardware because all it does is checking the machine
addresses to be mapped.

	Joerg

