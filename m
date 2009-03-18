Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbZCRL4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbZCRL4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbZCRL42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:56:28 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:6754 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755410AbZCRL42 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:56:28 -0400
X-BigFish: VPS-37(zz1432R98dR1805M936fKc1dRzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KGPAHQ-04-3FX-01
Date: Wed, 18 Mar 2009 12:56:15 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] dma-debug: add additional checks
Message-ID: <20090318115615.GS6159@amd.com>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com> <20090317120112.GP6159@amd.com> <20090318093847.GC5879@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090318093847.GC5879@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 18 Mar 2009 11:56:15.0949 (UTC) FILETIME=[8AB5A7D0:01C9A7C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 10:38:47AM +0100, Ingo Molnar wrote:
> e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
> e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
> ADDRCONF(NETDEV_UP): eth0: link is not ready
> e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
> 0000:00:19.0: eth0: 10/100 speed: disabling TSO
> ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> ------------[ cut here ]------------
> WARNING: at lib/dma-debug.c:461 check_unmap+0xd4/0x3dd() (Not tainted)
> Hardware name: 2241B48
> e1000e 0000:00:19.0: DMA-API: device driver tries to free DMA memory 
> it has not allocated [device address=0x0000000052ff084a] [size=90 bytes]
>  [<ffffffff811a6fb0>] check_unmap+0xd4/0x3dd
>  [<ffffffff811a7406>] debug_dma_unmap_page+0x50/0x52
>  [<ffffffffa00f4523>] pci_unmap_page+0x4e/0x57 [e1000e]
>  [<ffffffffa00f455a>] e1000_put_txbuf+0x2e/0x4f [e1000e]
>  [<ffffffffa00f4681>] e1000_clean_tx_irq+0xc8/0x2c2 [e1000e]
>  [<ffffffffa00f809b>] ? e1000_clean+0x6b/0x246 [e1000e]
>  [<ffffffffa00f80a7>] e1000_clean+0x77/0x246 [e1000e]
>  [<ffffffff812f89dd>] net_rx_action+0xb6/0x1ee
>  [<ffffffff812f8acc>] ? net_rx_action+0x1a5/0x1ee
>  [<ffffffff81051353>] __do_softirq+0x94/0x179
>  [<ffffffff810127ac>] call_softirq+0x1c/0x30
>  [<ffffffff8101393e>] do_softirq+0x52/0xb9
>  [<ffffffff81050f76>] irq_exit+0x53/0x90
>  [<ffffffff81013c57>] do_IRQ+0x12c/0x151
>  [<ffffffff81011e93>] ret_from_intr+0x0/0x2e
>  <EOI>  [<ffffffff811fe088>] ? acpi_idle_enter_bm+0x287/0x2de
>  [<ffffffff8106fbf9>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff811fe090>] ? acpi_idle_enter_bm+0x28f/0x2de
>  [<ffffffff811fe088>] ? acpi_idle_enter_bm+0x287/0x2de
>  [<ffffffff81399916>] ? __atomic_notifier_call_chain+0x0/0x86
>  [<ffffffff812d62ad>] ? cpuidle_idle_call+0x8d/0xc4
>  [<ffffffff810102c7>] ? cpu_idle+0x68/0xb3
>  [<ffffffff81381817>] ? rest_init+0x6b/0x6d
> ---[ end trace b8ae2341b2e9bbc2 ]---
> 
> i have some vague memories of this being discussed somewhere - it 
> got fixed in the driver, right? If yes, do you have an URL to that 
> fix? (if it's not upstream yet i will pick it up into 
> tip:out-of-tree to not have already-fixed warnings)

We had this issue in the ixgbe driver and it was fixed there. As far as
I know for e1000e this is a new issue.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

