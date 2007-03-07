Return-Path: <linux-kernel-owner+w=401wt.eu-S2992514AbXCGTqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992514AbXCGTqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:46:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992517AbXCGTqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:46:02 -0500
Received: from www.osadl.org ([213.239.205.134]:39103 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992514AbXCGTqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:46:01 -0500
Subject: Re: Linux-2.6.21-rc3 : Dynticks and High resolution Timer hanging
	the system
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stephane Casset <sept@logidee.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070307191252.GA6767@gromalin.logidee.com>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	 <45EEB66C.9090901@googlemail.com>
	 <Pine.LNX.4.64.0703070827490.5963@woody.linux-foundation.org>
	 <20070307171230.GA21593@elte.hu>
	 <20070307191252.GA6767@gromalin.logidee.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 20:52:10 +0100
Message-Id: <1173297130.24738.714.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 20:12 +0100, Stephane Casset wrote:
> I also tried compiling the kernel without Tickless and without  High
> resolution timer, this kernel is working ok and is one of the first
> kernel to suspend and resume from RAM. Congratulations ! ;p
>
> I tried to compile te kernel with only Tickless System or  High
> Resolution timer, both hang on boot.

There should be no difference between compile time and runtime
disabling.

> The hang is just after :
> ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
> ICH5: chipset revision 2
> ICH5: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0x2040-0x2047, BIOS settings: hda:DMA, hdb:pio
>     ide1: BM-DMA at 0x2048-0x204f, BIOS settings: hdc:DMA, hdd:pio
> 
> And I have the message :
> Switched to NOHZ mode on CPU #1
> or
> Switched to high resolution mode on CPU #1
> Depending on the option enabled/disabled 
> 
> What can I do to help find the bug ?

Can you capture a boot log with highres and/or dynticks enabled ? 

Enable CONFIG_SERIAL_8250_CONSOLE and add "console=ttyS0,115200" to the
commandline. Capture the output with minicom on a second box.

Also please enable CONFIG_MAGIC_SYSRQ and try to send a SysRq-T and a
SysRq-Q to the machine via keyboard or the serial line.

Thanks

	tglx


