Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbYCaFzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbYCaFzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 01:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbYCaFzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 01:55:17 -0400
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:58610 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbYCaFzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 01:55:15 -0400
Message-ID: <47F07CBE.5000900@freemail.hu>
Date: Mon, 31 Mar 2008 07:55:10 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       trenn@suse.de, linux-acpi <linux-acpi@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] [2.6.25-rc5] Warn user about a BIOS bug in recent
 asus boards
References: <1205280392.8194.46.camel@linux-2bdv.site>	 <200803120010.41373.lenb@kernel.org>	 <200803120140.14243.lenb@kernel.org>	 <1205300688.2240.47.camel@acpi-hp-zz.sh.intel.com>	 <1205305945.2240.56.camel@acpi-hp-zz.sh.intel.com>	 <1205391787.2240.71.camel@acpi-hp-zz.sh.intel.com>	 <47D99970.4010906@freemail.hu> <86802c440803291743i596678cem4f8ff727f208d2d3@mail.gmail.com>
In-Reply-To: <86802c440803291743i596678cem4f8ff727f208d2d3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 2008/3/13 Németh Márton <nm127@freemail.hu>:
>>  [    0.715787] ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 16 (level, low) -> IRQ 16
> ...
>>  [   25.037202] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> ...
>>  [   86.320860] irq 16: nobody cared (try booting with the "irqpoll" option)
>>  [   86.320860] Pid: 0, comm: swapper Not tainted 2.6.25-rc5 #1
>>  [   86.320860]  [<c01578f7>] __report_bad_irq+0x27/0x90
>>  [   86.320860]  [<c0157b96>] note_interrupt+0x236/0x270
>>  [   86.320860]  [<c0156fa3>] ? handle_IRQ_event+0x53/0x60
>>  [   86.320860]  [<c015823a>] handle_fasteoi_irq+0x7a/0xd0
>>  [   86.320860]  [<c0106174>] do_IRQ+0x44/0xa0
>>  [   86.320860]  [<c0104c66>] common_interrupt+0x2e/0x34
>>  [   86.320860]  [<c0119039>] ? finish_task_switch+0x59/0xc0
>>  [   86.320860]  [<c0118fe0>] ? finish_task_switch+0x0/0xc0
>>  [   86.320860]  [<c03080d6>] schedule+0x2b6/0x470
>>  [   86.320860]  [<f892fdae>] ? acpi_processor_idle+0x0/0x436 [processor]
>>  [   86.320860]  [<c0102b65>] cpu_idle+0xb5/0xd0
>>  [   86.320860]  [<c030343c>] rest_init+0x5c/0x60
>>  [   86.320860]  =======================
>>  [   86.320860] handlers:
>>  [   86.320860] [<f8915830>] (yenta_interrupt+0x0/0xe0 [yenta_socket])
>>  [   86.320860] [<f8afd3f0>] (via_driver_irq_handler+0x0/0x1c0 [via])
>>  [   86.320860] Disabling IRQ #16
> 
> wonder if other device is using IRQ #16 too.
> 
> can you boot with pci=routeirq to check that?

Yes, in my system the yenta module uses the IRQ #16 also:

Yenta: ISA IRQ mask 0x0aa8, PCI irq 16

However, the "nobody cared" message is triggered by the "via" X11 driver.
There is a workaround to get rid of it: I switched to "openChrome" X11
driver ( http://www.openchrome.org/ ).

See also http://lkml.org/lkml/2008/3/16/10 and
http://bugzilla.kernel.org/show_bug.cgi?id=6790 .

Regards,

	Márton Németh
