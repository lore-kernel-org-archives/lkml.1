Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYILTzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYILTzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 15:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbYILTzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 15:55:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:43820 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbYILTzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 15:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VwKo/SPZTUK8SBku2x2x/K7REUzBpbGvKZkLLHGFcvRgIC1e8fF3GVI46uolmak2Vf
         h8bhAvC0DH87YE01QZvj6RY9okxIpBsiJDwfgWl9CYTgCR36Z7j2TGVEKXH9w0jJ7HU4
         DBNGmgRN6fs/ZZ8HLIwaHYSUhwz+MPYwE11TE=
Message-ID: <86802c440809121255k1af2881dwb00ebb6f4a58057b@mail.gmail.com>
Date: Fri, 12 Sep 2008 12:55:42 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: io-apic - do not use KERN_DEBUG marker too much
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <20080908153806.GB7278@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080908153806.GB7278@lenovo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 8:38 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> Do not use KERN_DEBUG several times on the same line being printed.
> Introduced by mine previous patch, sorry.
>
> Reported-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>
> Index: linux-2.6.git/arch/x86/kernel/io_apic.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/io_apic.c        2008-09-08 19:32:34.000000000 +0400
> +++ linux-2.6.git/arch/x86/kernel/io_apic.c     2008-09-08 19:34:10.000000000 +0400
> @@ -1526,11 +1526,16 @@ static void __init setup_IO_APIC_irqs(vo
>
>                        idx = find_irq_entry(apic, pin, mp_INT);
>                        if (idx == -1) {
> -                               apic_printk(APIC_VERBOSE,
> -                                       KERN_DEBUG " %d-%d",
> -                                       mp_ioapics[apic].mp_apicid, pin);
> -                               if (!notcon)
> +                               if (!notcon) {
>                                        notcon = 1;
> +                                       apic_printk(APIC_VERBOSE,
> +                                               KERN_DEBUG " %d-%d",
> +                                               mp_ioapics[apic].mp_apicid,
> +                                               pin);
> +                               } else
> +                                       apic_printk(APIC_VERBOSE, " %d-%d",
> +                                               mp_ioapics[apic].mp_apicid,
> +                                               pin);
>                                continue;
>                        }
>
> @@ -1546,14 +1551,14 @@ static void __init setup_IO_APIC_irqs(vo
>                }
>                if (notcon) {
>                        apic_printk(APIC_VERBOSE,
> -                               KERN_DEBUG " (apicid-pin) not connected\n");
> +                               " (apicid-pin) not connected\n");
>                        notcon = 0;
>                }
>        }
>
>        if (notcon)
>                apic_printk(APIC_VERBOSE,
> -                       KERN_DEBUG " (apicid-pin) not connected\n");
> +                       " (apicid-pin) not connected\n");
>  }
>
>  /*
>

still some wrong

init IO_APIC IRQs
 8-0<7> 0 add_pin_to_irq: irq 1 --> apic 0 pin 1
IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
 0 add_pin_to_irq: irq 0 --> apic 0 pin 2
IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
 0 add_pin_to_irq: irq 3 --> apic 0 pin 3
IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
 0 add_pin_to_irq: irq 4 --> apic 0 pin 4
IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
 0 add_pin_to_irq: irq 5 --> apic 0 pin 5
IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
 0 add_pin_to_irq: irq 6 --> apic 0 pin 6
IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
 0 add_pin_to_irq: irq 7 --> apic 0 pin 7
IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
 0 add_pin_to_irq: irq 8 --> apic 0 pin 8
IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
 0 add_pin_to_irq: irq 9 --> apic 0 pin 9
IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
 0 add_pin_to_irq: irq 10 --> apic 0 pin 10
IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
 0 add_pin_to_irq: irq 11 --> apic 0 pin 11
IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
 0 add_pin_to_irq: irq 12 --> apic 0 pin 12
IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
 0 add_pin_to_irq: irq 13 --> apic 0 pin 13
IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
 0 add_pin_to_irq: irq 14 --> apic 0 pin 14
IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
 0 add_pin_to_irq: irq 15 --> apic 0 pin 15
IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 8-16 8-17 8-18 8-19 8-20 8-21 8-22 8-23 (apicid-pin) not connected
 9-0 9-1 9-2 9-3 9-4 9-5 9-6 9-7 9-8 9-9 9-10 9-11 9-12 9-13 9-14 9-15
9-16 9-17 9-18 9-19 9-20 9-21 9-22 9-23 (apicid-pin) not connected


YH
