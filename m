Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbXKXXJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbXKXXJu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 18:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbXKXXJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 18:09:42 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:50435 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbXKXXJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 18:09:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oppiUSvw8fTWiuHWcNzkjKPWoyMdkimZPVkTC8yOnZURcmFi1dHUQl/6g7IdMiTuSsW0tATfMBNlmMww3+DWXhzXau888MUl9B82atF3F09dYvK4vOc5bHIysyj5nGCaq0QAZZDahanMjbUB0FRgFeGKuUqDHthDc34sqevYyhE=
Message-ID: <86802c440711241509g6e80b49by67d40bb7d364580e@mail.gmail.com>
Date: Sat, 24 Nov 2007 15:09:40 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrey Borzenkov" <arvidjaar@mail.ru>
Subject: Re: 2.6.24: Serial disabled in BIOS but serial modules still loaded (probably PnP related)
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <200711242336.43712.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711242336.43712.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 24, 2007 12:36 PM, Andrey Borzenkov <arvidjaar@mail.ru> wrote:
> I have no COM port on notebook (without port replicator which I do not have)
> so COM is disabled in BIOS. No ttyS* is detected during boot (and no device
> created) but I just noticed that serial modules are still loaded. Well, this
> partially defeats the purpose of disabling COM port - the intention was to
> free resources by *not* loading unneeded modules ...
>
> This may have something to do with (ACPI) PnP which apparently believes COM is alive.
> Notebook is Toshiba Portege 4000.
>
> {pts/0}% lsmod | grep 82
> 8250_pnp                9792  0
> 8250                   24660  1 8250_pnp
> serial_core            22872  1 8250
>
> {pts/0}% lspnp -v
> 00:00 PNP0c01 System board
>     state = active
>         mem 0x0-0x9ffff
>         mem 0xe0000-0xeffff
>         mem 0xf0000-0xfffff
>         mem 0x100000-0x1ef5ffff
>
> 00:01 PNP0a03 PCI bus
>     state = active
>         io 0xcf8-0xcff
>
> 00:02 PNP0200 AT DMA controller
>     state = active
>         io 0x0-0xf
>         io 0x81-0x83
>         io 0x87-0x87
>         io 0x89-0x8b
>         io 0x8f-0x8f
>         io 0xc0-0xdf
>         dma 4
>
> 00:03 PNP0800 AT speaker
>     state = active
>         io 0x61-0x61
>
> 00:04 PNP0c04 Math coprocessor
>     state = active
>         io 0xf0-0xff
>         irq 13
>
> 00:05 PNP0303 IBM enhanced keyboard (101/102-key, PS/2 mouse support)
>     state = active
>         io 0x60-0x60
>         io 0x64-0x64
>         irq 1
>
> 00:06 PNP0f13 PS/2 port for PS/2-style mice
>     state = active
>         irq 12
>
> 00:07 PNP0b00 AT real-time clock
>     state = active
>         io 0x70-0x71
>         irq 8
>
> 00:08 PNP0c02 Motherboard resources
>     state = active
>         io 0x2e-0x2f
>         io 0x62-0x62
>         io 0x66-0x66
>         io 0x80-0x80
>         io 0x84-0x86
>         io 0x88-0x88
>         io 0x8c-0x8e
>         io 0x92-0x92
>
> 00:09 PNP0501 16550A-compatible serial port
>     state = active
>         io 0x3f8-0x3ff
>         irq 5
>
> 00:0a SMCf010 SMC Fast Infrared Port
>     state = disabled
>
> 00:0b PNP0401 ECP printer port
>     state = disabled
>
> ..
> [  126.035809] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
...
> [  126.107096] serial 00:09: activated
...

Can you cat /sys/firmware/acpi/DSDT and use iasl to decode it?
it seems that your BIOS has problem about com setup.

YH
