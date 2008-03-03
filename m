Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbYCCLIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbYCCLIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 06:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbYCCLIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 06:08:05 -0500
Received: from sif.is.scarlet.be ([193.74.71.28]:36222 "EHLO sif.is.scarlet.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbYCCLID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:08:03 -0500
Date: Mon,  3 Mar 2008 12:04:00 +0100
Message-Id: <JX5IQO$1ADFF18D173371DE06D03C11EFEA34BA@scarlet.be>
Subject: Re: [PATCH -mm 0/3] fix iommu segment boundary problems (parisc)
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: "rubisher" <rubisher@scarlet.be>
To: "kyle" <kyle@mcmartin.ca>
Cc: "fujita\.tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-parisc" <linux-parisc@vger.kernel.org>, "tomof" <tomof@acm.org>,
       "kyle" <kyle@parisc-linux.org>, "matthew" <matthew@wil.cx>,
       "grundler" <grundler@parisc-linux.org>,
       "akpm" <akpm@linux-foundation.org>, "rubisher" <rubisher@scarlet.be>
X-XaM3-API-Version: 4.1 (B54)
X-type: 0
X-SenderIP: 57.67.177.33
X-DCC-scarlet.be-Metrics: sif; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Mar 02, 2008 at 03:10:25PM +0900, FUJITA Tomonori wrote:
> > This patchset is another sequel to my patchset to fix iommu segment
> > boundary problems, IOMMUs allocate memory areas without considering a
> > low level driver's segment boundary limits:
> > 
> > http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg11919.html
> > 
> 
> This looks fine. Are you able to test this? If not, we can set you up
> with an account on a machine with remote console and all that jazz, if
> you'd like to.
> 
> cheers, Kyle
> --
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Sorry for bad news but using a kernel known to work fine on my b2k (kyle's
parisc-2.6.git date 2008_02_21) against which I applied those patches, this
new kernel 32bit up failled to boot with this panic message:

Linux Tulip driver version 1.1.15 (Feb 27, 2007)
------------[ cut here ]------------
Kernel BUG at 1029520c [verbose debug info unavailable]

     YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00000000000001001111111100001110 Not tainted
r00-03  0004ff0e 1054c010 1029e774 80000000
r04-07  1fc2b020 00000100 00000000 00000001
r08-11  1fc1d454 1fc2c000 00000000 80000000
r12-15  00000001 00000001 1fc10858 0001a000
r16-19  00000011 104a23d0 00000000 ffffffff
r20-23  00001000 00000000 1fdb6a00 00000000
r24-27  00000000 00000001 00000100 10507010
r28-31  00000100 00100000 1fc205c0 00000000
sr00-03  00000000 00000000 00000000 00000000
sr04-07  00000000 00000000 00000000 00000000
IASQ: 00000000 00000000 IAOQ: 1029520c 10295210
 IIR: 03ffe01f    ISR: 1024003f  IOR: 0802056c
 CPU:        0   CR30: 1fc20000 CR31: 11111111
 ORIG_R28: 0000000f
 IAOQ[0]: iommu_is_span_boundary+0x28/0x30
 IAOQ[1]: iommu_is_span_boundary+0x2c/0x30
 RP(r2): sba_alloc_range+0x23c/0x4f8
Backtrace:
 [<10107938>] show_regs+0x2c8/0x450
 [<10107c64>] die_if_kernel+0x98/0x1b0
 [<101083a0>] handle_interruption+0x624/0x6b4
 [<1010b078>] intr_check_sig+0x0/0x34
 [<1015d07c>] rmqueue_bulk+0x44/0x9c
 [<1015e778>] __alloc_pages+0xc4/0x388
 [<1015ea74>] __get_free_pages+0x38/0x74
 [<1029ed64>] sba_alloc_consistent+0x60/0xd4
 [<105852f0>] tulip_init_one+0x2ac/0xd10
 [<1029acb0>] pci_device_probe+0x70/0xa8
 [<102dad50>] driver_probe_device+0xa4/0x1bc
 [<102db01c>] __driver_attach+0x60/0xf4
 [<102da1dc>] bus_for_each_dev+0x58/0xa0
 [<102da978>] bus_add_driver+0xd4/0x1e0
 [<102db34c>] driver_register+0x48/0x108
 [<10565880>] kernel_init+0x120/0x33c

Backtrace:
 [<10107c6c>] die_if_kernel+0xa0/0x1b0
 [<101083a0>] handle_interruption+0x624/0x6b4
 [<1010b078>] intr_check_sig+0x0/0x34
 [<1015d07c>] rmqueue_bulk+0x44/0x9c
 [<1015e778>] __alloc_pages+0xc4/0x388
 [<1015ea74>] __get_free_pages+0x38/0x74
 [<1029ed64>] sba_alloc_consistent+0x60/0xd4
 [<105852f0>] tulip_init_one+0x2ac/0xd10
 [<1029acb0>] pci_device_probe+0x70/0xa8
 [<102dad50>] driver_probe_device+0xa4/0x1bc
 [<102db01c>] __driver_attach+0x60/0xf4
 [<102da1dc>] bus_for_each_dev+0x58/0xa0
 [<102da978>] bus_add_driver+0xd4/0x1e0
 [<102db34c>] driver_register+0x48/0x108
 [<10565880>] kernel_init+0x120/0x33c
 [<1010ac5c>] ret_from_kernel_thread+0x1c/0x24

Kernel panic - not syncing: Attempted to kill init!

(I haven't a lot a spare time right now, but I will do my best to help as much
as I can).

r.
---
Scarlet One, ADSL 6 Mbps + Telephone, from EUR 29,95...
http://www.scarlet.be/

