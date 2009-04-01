Return-Path: <linux-kernel-owner+w=401wt.eu-S933181AbZDASD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbZDASD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933087AbZDASDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:03:06 -0400
Received: from mail.vyatta.com ([76.74.103.46]:57989 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084AbZDASDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:03:04 -0400
Date: Wed, 1 Apr 2009 11:02:45 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Dave Jones <davej@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
       tglx@linuxtronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [Bug 487894] New: sky2 0000:06:00.0: DMA-API: device driver
 frees DMA memory with different size
Message-ID: <20090401110245.4d1ddf72@nehalam>
In-Reply-To: <20090401172708.GA11941@redhat.com>
References: <20090401172708.GA11941@redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ummary: sky2 0000:06:00.0: DMA-API: device driver frees DMA memory with different size
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=487894
> 
>            Summary: sky2 0000:06:00.0: DMA-API: device driver frees DMA
>                     memory with different size
>            Product: Fedora
>            Version: rawhide
>           Platform: i686
>         OS/Version: Linux
>             Status: NEW
>           Severity: low
>           Priority: low
>          Component: kernel
>         AssignedTo: kernel-maint@redhat.com
>         ReportedBy: agraham@g-b.net
>          QAContact: extras-qa@fedoraproject.org
>                 CC: kernel-maint@redhat.com, quintela@redhat.com
>    Estimated Hours: 0.0
>     Classification: Fedora
> 
> 
> Description of problem:
> 
> After building and installing kernel-2.6.29-0.159.rc6.git3.fc11.src.rpm on a
> Fedora 10 machine (i7 Core) 
> 
> The kernel boots up OK, but displays this error message:
> 
> -----------[ cut here ]------------
> WARNING: at lib/dma-debug.c:470 check_unmap+0x1cd/0x42e() (Not tainted)
> Hardware name: System Product Name
> sky2 0000:06:00.0: DMA-API: device driver frees DMA memory with different size
> [device address=0x0000000033171042] [map size=1520 bytes] [unmap size=0 bytes]
> Modules linked in: aoe sky2 e1000e
> Pid: 0, comm: swapper Not tainted 2.6.29-0.159.rc6.git3.fc10.i686.PAE #1
> Call Trace:
>  [<c04383c5>] warn_slowpath+0x7c/0xbd
>  [<c04585ae>] ? trace_hardirqs_on_caller+0x10b/0x145
>  [<c0448c8b>] ? __kernel_text_address+0x39/0x43
>  [<c040c067>] ? print_context_stack+0x8d/0x9e
>  [<c0458079>] ? mark_lock+0x1e/0x349
>  [<c04572f9>] ? register_lock_class+0x17/0x290
>  [<c0558db9>] ? check_unmap+0x65/0x42e
>  [<c0558f21>] check_unmap+0x1cd/0x42e
>  [<c0552653>] ? random32+0x16/0x18
>  [<c05584c5>] ? should_fail+0x80/0x14b
>  [<c040df5b>] ? sched_clock+0x8/0xb
>  [<c040df5b>] ? sched_clock+0x8/0xb
>  [<c04adeb0>] ? check_valid_pointer+0x24/0x53
>  [<c04ae51d>] ? check_object+0x131/0x165
>  [<c0559358>] debug_dma_unmap_page+0x59/0x61
>  [<f80a25f9>] dma_unmap_single+0x4c/0x57 [sky2]
>  [<f80a263f>] sky2_rx_unmap_skb+0x3b/0xa5 [sky2]
>  [<f80a2052>] ? sky2_rx_alloc+0x61/0xdb [sky2]
>  [<f80a4e77>] sky2_poll+0x569/0x97a [sky2]
>  [<c06852a4>] ? net_rx_action+0x189/0x1ca
>  [<c06851bc>] net_rx_action+0xa1/0x1ca
>  [<c043d276>] __do_softirq+0x9d/0x157
>  [<c043d1d9>] ? __do_softirq+0x0/0x157
>  <IRQ>  [<c047b642>] ? handle_edge_irq+0x0/0xf2
>  [<c043cf1a>] ? irq_exit+0x49/0x77
>  [<c040b2b3>] ? do_IRQ+0xf5/0x10b
>  [<c0409dac>] ? common_interrupt+0x2c/0x34
>  [<c045007b>] ? __async_schedule+0x90/0x120
>  [<c040ee11>] ? mwait_idle+0x77/0xa7
>  [<c0408798>] ? cpu_idle+0x70/0x90
>  [<c07093a5>] ? start_secondary+0x1c9/0x1d1
> ---[ end trace bf70a1302e043c63 ]---
> 
> Version-Release number of selected component (if applicable):
> 2.6.29-0.159.rc6.git3.fc10.i686.PAE
> 
> How reproducible:
> 
> I boot the kernel via PXE, I've modified the initrd so load the Sky ethernet
> driver so that I can boot from an AOE server.
> 
> I've added the following to the init script (so I can boot via AOE)
> 
> echo "Loading sky2  module"
> modprobe -q sky2
> sleep 2
> #==============================
> busybox ifconfig eth0 up
> busybox ifconfig eth1 up
> sleep 4
> echo "Creatig AOE /dev entries"
> mknod /dev/etherd/stat       c 152 1
> mknod /dev/etherd/err        c 152 2
> mknod /dev/etherd/discover   c 152 3
> mknod /dev/etherd/interfaces c 152 4
> mknod /dev/etherd/revalidate c 152 5
> mknod /dev/etherd/flush      c 152 6
> echo "Loading aoe module"
> modprobe -q aoe aoe_iflist="eth0,eth1"
> echo "Scanning AOE network for disks"
> echo "1" > /dev/etherd/discover
> sleep 1
> mkblkdevs
> #=============================
> 
> Steps to Reproduce:
> 1. boot via PXE with modified initrd
> 2.
> 3.
> 
> Actual results:
> 
> sky2 0000:06:00.0: DMA-API: device driver frees DMA memory with different size
> [device address=0x0000000033171042] [map size=1520 bytes] [unmap size=0 bytes]
> 
> Expected results:
> 
> No message should appear.
> 
> I would imagine that the above unmap should release 1520 bytes rather than 0
> bytes.
> 
> Additional info:
> 
> The above works fine with all previous kernels, so I would expect it to work
> with the newer .28/.29 kernels too.


On Wed, 1 Apr 2009 13:27:08 -0400
Dave Jones <davej@redhat.com> wrote:
> I'm not sure _what_ to make of this one..
> 
> Null fragment ?  How can that happen?
> 
> 	Dave

The sky2 driver uses pci_unmap_len and pci_unmap_len_set which on 32 bit
platforms are meaningless so they are stubbed out. 
Basically, DMA-API checks are wrong/bogus to enforce on 32bit x86 as is.
How about?
========================================================
Unstub pci_unmap macros if doing DMA-API checks

If doing device driver DMA-API tests then need to keep track of address/length
even on 32-bit x86 where the information is not normally needed.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/arch/x86/include/asm/pci_32.h	2009-04-01 10:52:07.117504355 -0700
+++ b/arch/x86/include/asm/pci_32.h	2009-04-01 10:56:02.249066174 -0700
@@ -17,16 +17,25 @@ struct pci_dev;
  */
 #define PCI_DMA_BUS_IS_PHYS	(1)
 
+#ifdef CONFIG_DMA_API_DEBUG
+/* keep real values */
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME;
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		__u32 LEN_NAME;
+#define pci_unmap_addr(PTR, ADDR_NAME)		((PTR)->ADDR_NAME)
+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	(((PTR)->ADDR_NAME) = (VAL))
+#define pci_unmap_len(PTR, LEN_NAME)		((PTR)->LEN_NAME)
+#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	(((PTR)->LEN_NAME) = (VAL))
+#else
 /* pci_unmap_{page,single} is a nop so... */
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME[0];
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)	unsigned LEN_NAME[0];
-#define pci_unmap_addr(PTR, ADDR_NAME)	sizeof((PTR)->ADDR_NAME)
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		__u32 LEN_NAME[0];
+#define pci_unmap_addr(PTR, ADDR_NAME)		sizeof((PTR)->ADDR_NAME)
 #define pci_unmap_addr_set(PTR, ADDR_NAME, VAL) \
 	do { break; } while (pci_unmap_addr(PTR, ADDR_NAME))
 #define pci_unmap_len(PTR, LEN_NAME)		sizeof((PTR)->LEN_NAME)
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL) \
 	do { break; } while (pci_unmap_len(PTR, LEN_NAME))
-
+#endif
 
 #endif /* __KERNEL__ */
 


