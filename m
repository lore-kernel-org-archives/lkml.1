Return-Path: <linux-kernel-owner+w=401wt.eu-S1765316AbXFSTvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765316AbXFSTvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760904AbXFSTvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:51:23 -0400
Received: from smtp2.Stanford.EDU ([171.67.20.25]:37685 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896AbXFSTvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:51:22 -0400
X-Greylist: delayed 1483 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 15:51:22 EDT
Subject: Re: 2.6.21.5-rt15: BUG: scheduling with irqs disabled
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: nando@ccrma.Stanford.EDU, carrlane@ccrma.Stanford.EDU,
       linux-kernel@vger.kernel.org
In-Reply-To: <1182212425.21064.47.camel@cmn3.stanford.edu>
References: <1182212425.21064.47.camel@cmn3.stanford.edu>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 12:26:37 -0700
Message-Id: <1182281197.25101.35.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-18 at 17:20 -0700, Fernando Lopez-Lezcano wrote:
> Hi Ingo, I'm seeing this on 2.6.21.5-rt14 and 2.6.21.5-rt15, this
> problem did not happen in 2.6.21.3-rt9 (last I checked on this
> hardware). The computer is an athlon x2 and eth0 is "alias eth0 skge",
> the BUGs trigger on network activity (but not a constant stream of
> them)...

Seems to have been fixed in 2.6.21.5-rt17! (briefly booted into one
machine with the new build and so far no BUGs reported). 

Thanks!!!
-- Fernando


> BUG: scheduling with irqs disabled: IRQ-20/0x00000000/1246
> caller is wait_for_completion+0x65/0x9b
>  [<c0105f44>] dump_trace+0x64/0x105
>  [<c0105ffd>] show_trace_log_lvl+0x18/0x2c
>  [<c010660a>] show_trace+0xf/0x11
>  [<c010668b>] dump_stack+0x12/0x14
>  [<c032ba36>] schedule+0x86/0xfa
>  [<c032bb0f>] wait_for_completion+0x65/0x9b
>  [<c0125f24>] set_cpus_allowed+0x71/0x8f
>  [<c012f867>] do_softirq_from_hardirq+0xbd/0xda
>  [<c015a336>] do_irqd+0x1ff/0x24d
>  [<c013be5c>] kthread+0xb0/0xd8
>  [<c0105b7b>] kernel_thread_helper+0x7/0x10
>  =======================
> [root@cmn34 ~]# cat /proc/interrupts
>            CPU0       CPU1
>   0:        251          1   IO-APIC-edge      timer
>   1:          0          2   IO-APIC-edge      i8042
>   6:          0          6   IO-APIC-edge      floppy
>   7:          1          0   IO-APIC-edge      parport0
>   8:          0          1   IO-APIC-edge      rtc
>   9:          0          0   IO-APIC-fasteoi   acpi
>  12:          0          4   IO-APIC-edge      i8042
>  14:          0       3724   IO-APIC-edge      ide0
>  16:       7591       5688   IO-APIC-fasteoi   ohci_hcd:usb1, libata
>  17:          1        238   IO-APIC-fasteoi   ohci_hcd:usb2, NVidia
> CK8S
>  18:          0          3   IO-APIC-fasteoi   ehci_hcd:usb3
>  19:          0          0   IO-APIC-fasteoi   libata
>  20:          0       3028   IO-APIC-fasteoi   eth0
>  21:          0          2   IO-APIC-fasteoi   ohci1394, ICE1712
>  22:      17253       5916   IO-APIC-fasteoi   radeon@pci:0000:01:00.0
> NMI:          0          0
> LOC:      32953      36858
> ERR:          1
> MIS:          0


