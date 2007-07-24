Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbXGXP6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbXGXP6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbXGXP6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:58:37 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:52694 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbXGXP6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:58:37 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: =?iso-8859-15?q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Tue, 24 Jul 2007 09:48:45 -0600
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
In-Reply-To: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707240948.45916.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2007 08:28:05 am Sébastien Dugué wrote:
>  your commit 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26 broke the serial console
> on my box. Adding 'legacy_serial.force=1' to my boot param as a workaround
> solves the issue, but this may be hiding bugs in Linux PnP support or
> in my firmware.

Thanks for your report.  We need to figure out why the 8250_pnp driver
didn't find your serial console device.  Can you confirm that you also
have CONFIG_ACPI and CONFIG_PNPACPI in your .config?

If you have those, and it still doesn't work, can you collect the DSDT
dump, the output of "grep . /sys/bus/pnp/devices/*/*", and the dmesg
from your "legacy_serial.force=1" boot?  Then we can tell which port
the blind probe finds and whether it's described somewhere by ACPI.

Thanks,
  Bjorn

>   The box is a dual HT Xeon running a vanilla 2.6.22 x86_64 kernel
> 
>   here is my .config:
> 
> CONFIG_PNP=y
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> CONFIG_SERIAL_8250_DETECT_IRQ=y
> 
>   lspci output attached.
>  
>   Any ideas to help me debug this?
> 
>   If you need more info (like DSDT dump), just ask.
> 
>   Thanks,
> 
>   Sébastien.
> 
> 
> 


