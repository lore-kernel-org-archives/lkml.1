Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbZDFSbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbZDFSbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZDFSbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:31:41 -0400
Received: from h155.mvista.com ([63.81.120.155]:16142 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751358AbZDFSbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:31:40 -0400
Message-ID: <49DA4AB0.10505@ru.mvista.com>
Date: Mon, 06 Apr 2009 22:32:16 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: 2.6.29.1 BUG: unable to handle kernel NULL pointer dereference
 at (null)
References: <49DA45C8.8070303@nets.rwth-aachen.de>
In-Reply-To: <49DA45C8.8070303@nets.rwth-aachen.de>
Content-Type: multipart/mixed;
 boundary="------------090105080105080103020809"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090105080105080103020809
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Arnd Hannemann wrote:

> perhaps cs5536 is broken?

    Yes, it is.

> This is with one CF card present on ALIX 2c2:

> [    2.857215] Uniform Multi-Platform E-IDE driver
> [    2.871238] cs5536 0000:00:0f.2: IDE controller (0x1022:0x209a rev 0x01)
> [    2.891486] cs5536 0000:00:0f.2: not 100% native mode: will probe
> irqs later
> [    2.912718] BUG: unable to handle kernel NULL pointer dereference at
> (null)
> [    2.933857] IP: [<(null)>] (null)
> [    2.944014] *pde = 00000000
> [    2.952788] Oops: 0000 [#1]
> [    2.956215] last sysfs file:
> [    2.956215] Modules linked in:
> [    2.956215]
> [    2.956215] Pid: 1, comm: swapper Not tainted (2.6.29.1-ah #1)
> [    2.956215] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
> [    2.956215] EIP is at 0x0
> [    2.956215] EAX: ce925400 EBX: ce925400 ECX: ce925400 EDX: c0372ebc
> [    2.956215] ESI: c0372dec EDI: cf4aa858 EBP: cf416d14 ESP: cf416d04
> [    2.956215]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    2.956215] Process swapper (pid: 1, ti=cf416000 task=cf41fb40
> task.ti=cf416)
> [    2.956215] Stack:
> [    2.956215]  c027815f ce925400 c0372dec 0000ff00 cf416d2c c0278722
> cf4aa800 0
> [    2.956215]  c0372dec ce92543c cf416d6c c0276a9e cf416d7c cf416e7c
> c0372dec 0
> [    2.956215]  ce925400 00000000 c03e0c48 cf4aa8c0 01000005 c0372dec
> 00000000 0
> [    2.956215] Call Trace:
> [    2.956215]  [<c027815f>] ? ide_pci_check_simplex+0x4e/0x83
> [    2.956215]  [<c0278722>] ? ide_hwif_setup_dma+0x63/0xcd
> [    2.956215]  [<c0276a9e>] ? ide_host_register+0x169/0x52f
> [    2.956215]  [<c027884a>] ? ide_pci_init_one+0xbe/0xd5
> [    2.956215]  [<c01133a2>] ? update_curr+0x60/0x93
> [    2.956215]  [<c02395bf>] ? idr_get_empty_slot+0x132/0x1f5
> [    2.956215]  [<c02962a4>] ? raw_pci_read+0x4c/0x57
> [    2.956215]  [<c0296392>] ? pci_read+0x1d/0x23
> [    2.956215]  [<c0242a7d>] ? pci_bus_read_config_dword+0x2c/0x44
> [    2.956215]  [<c027a219>] ? cs5536_init_one+0x4f/0x54
> [    2.956215]  [<c024648d>] ? local_pci_probe+0xe/0x10
> [    2.956215]  [<c0246599>] ? pci_device_probe+0x4b/0x69
> [    2.956215]  [<c0269a05>] ? driver_probe_device+0x9b/0x112
> [    2.956215]  [<c0269ac8>] ? __driver_attach+0x4c/0x6b
> [    2.956215]  [<c0269101>] ? bus_for_each_dev+0x36/0x57
> [    2.956215]  [<c02698af>] ? driver_attach+0x14/0x16
> [    2.956215]  [<c0269a7c>] ? __driver_attach+0x0/0x6b
> [    2.956215]  [<c026958b>] ? bus_add_driver+0x97/0x1a7
> [    2.956215]  [<c0269c63>] ? driver_register+0x71/0xcd
> [    2.956215]  [<c024674d>] ? __pci_register_driver+0x2e/0x5d
> [    2.956215]  [<c0452069>] ? cs5536_init+0x14/0x16
> [    2.956215]  [<c0101049>] ? _stext+0x49/0x10b
> [    2.956215]  [<c0452055>] ? cs5536_init+0x0/0x16
> [    2.956215]  [<c0182200>] ? proc_create_data+0x8a/0x8d
> [    2.956215]  [<c013a16c>] ? register_irq_proc+0x6a/0x83
> [    2.956215]  [<c043e6d0>] ? kernel_init+0x6d/0xbb
> [    2.956215]  [<c043e663>] ? kernel_init+0x0/0xbb
> [    2.956215]  [<c010319f>] ? kernel_thread_helper+0x7/0x10
> [    2.956215] Code:  Bad EIP value.
> [    2.956215] EIP: [<00000000>] 0x0 SS:ESP 0068:cf416d04
> [    3.638455] ---[ end trace f6947cc280ce4929 ]---
> [    3.652402] Kernel panic - not syncing: Attempted to kill init!

    The dma_sff_read_status() method isn't defined in the driver for some 
reason. Try the attached patch please.

> Best regards,
> Arnd

MBR, Sergei

--------------090105080105080103020809
Content-Type: text/x-patch;
 name="cs5536-define-dma_sff_read_status.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cs5536-define-dma_sff_read_status.patch"

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

 drivers/ide/cs5536.c |    1 +
 1 files changed, 1 insertion(+)

Index: linux-2.6/drivers/ide/cs5536.c
===================================================================
--- linux-2.6.orig/drivers/ide/cs5536.c
+++ linux-2.6/drivers/ide/cs5536.c
@@ -236,6 +236,7 @@ static const struct ide_dma_ops cs5536_d
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_port_info cs5536_info = {

--------------090105080105080103020809--
