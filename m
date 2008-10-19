Return-Path: <linux-kernel-owner+w=401wt.eu-S1751496AbYJSIC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbYJSIC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 04:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYJSICF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 04:02:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:58674 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbYJSICE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 04:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fMcLLZ60ivCOLD5L5URXc+mXWFJEITYBCkpmItinB5cK57dxuFl6DK6HOCTill/X4F
         eXmC2au0nJMc/zRF1C3LJLmdPYhhSatkBzJlnWafdpT6RDRrOC02tIdXwHPCAutv2Bha
         R+mumjcfWWUDCvlvfzClUCXPXP5kTEM4ZmowU=
Subject: Re: irq 19: nobody cared
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Chris Li <lkml@chrisli.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <70318cbf0810182334o4394f990h377b0a14215e1541@mail.gmail.com>
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
	 <20081019040557.GA6337@goodmis.org>
	 <70318cbf0810182334o4394f990h377b0a14215e1541@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 19 Oct 2008 01:02:01 -0700
Message-Id: <1224403321.13550.1.camel@unix>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-18 at 23:34 -0700, Chris Li wrote:
> On Sat, Oct 18, 2008 at 9:05 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Hi Chris,
> >
> > Do you still have this problem, without any "irqpoll" workarourd? If so,
> > can you boot with the "noapic" kernel command line parameter, and see if
> > that stops the warning?
> 
> Yes, I still have this annoying IRQ storm problem. With noapic, the IRQ number
> change to 11. It is still there.
> 
> Chris
> 
> ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 11
> PCI: setting IRQ 11 as level-triggered
> uhci_hcd 0000:00:1a.1: PCI INT B -> Link[LNKF] -> GSI 11 (level, low) -> IRQ 11
> uhci_hcd 0000:00:1a.1: setting latency timer to 64
> uhci_hcd 0000:00:1a.1: UHCI Host Controller
> uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
> uhci_hcd 0000:00:1a.1: irq 11, io base 0x0000fc00
> usb usb4: configuration #1 chosen from 1 choice
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 2 ports detected
> usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb4: Product: UHCI Host Controller
> usb usb4: Manufacturer: Linux 2.6.27-rc7-tip uhci_hcd
> usb usb4: SerialNumber: 0000:00:1a.1
> irq 11: nobody cared (try booting with the "irqpoll" option)
> Pid: 436, comm: modprobe Not tainted 2.6.27-rc7-tip #2
>  [<c0461e45>] __report_bad_irq+0x2e/0x6f
>  [<c0461f6d>] note_interrupt+0xe7/0x13e
>  [<c04625b5>] handle_level_irq+0x8f/0xc4
>  [<c0462526>] ? handle_level_irq+0x0/0xc4
>  [<c0405d7c>] do_IRQ+0xab/0xd1
>  [<c040472f>] common_interrupt+0x23/0x28
>  [<c04306ca>] ? __do_softirq+0x5b/0xe7
>  [<c043066f>] ? __do_softirq+0x0/0xe7
>  [<c0405e14>] do_softirq+0x72/0xb2
>  [<c0430459>] irq_exit+0x38/0x6d
>  [<c041506e>] smp_apic_timer_interrupt+0x71/0x7f
>  [<c0404848>] apic_timer_interrupt+0x28/0x30
>  [<c062d0bb>] ? _spin_unlock_irqrestore+0x13/0x1f
>  [<c05bdaf1>] pci_conf1_write+0xb1/0xbf
>  [<c05bf118>] raw_pci_write+0x4d/0x58
>  [<c052583b>] acpi_os_write_pci_configuration+0x64/0x77
>  [<c0530a91>] acpi_ex_pci_config_space_handler+0x4d/0x58
>  [<c0530a44>] ? acpi_ex_pci_config_space_handler+0x0/0x58
>  [<c052a103>] acpi_ev_address_space_dispatch+0x12f/0x16f
>  [<c052df0a>] acpi_ex_access_region+0x1b2/0x1c0
>  [<c052e02f>] acpi_ex_field_datum_io+0x117/0x1ae
>  [<c052e383>] acpi_ex_write_with_update_rule+0xd5/0xde
>  [<c052e63b>] acpi_ex_insert_into_field+0x2af/0x2cc
>  [<c052cc85>] acpi_ex_write_data_to_field+0x169/0x181
>  [<c0530d6a>] acpi_ex_store_object_to_node+0x82/0xb7
>  [<c0530f38>] acpi_ex_store+0xc9/0x221
>  [<c052d5ce>] ? acpi_ex_resolve_to_value+0xbc/0x21a
>  [<c052ef32>] acpi_ex_opcode_1A_1T_1R+0x3db/0x535
>  [<c052f690>] ? acpi_ex_resolve_operands+0x1cc/0x47c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

What does the whole dmesg look like might I ask?

-- 
Justin P. Mattock <justinmattock@gmail.com>

