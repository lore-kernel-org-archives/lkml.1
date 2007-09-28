Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbXI1W3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbXI1W3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 18:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXI1W3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 18:29:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55549 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbXI1W3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 18:29:39 -0400
Message-ID: <46FD802D.2030804@zytor.com>
Date: Fri, 28 Sep 2007 15:29:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Santiago Garcia Mantinan <manty@manty.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: vga text console not working on 2.6.23-rc8
References: <20070928200352.GA2312@pul.manty.net>
In-Reply-To: <20070928200352.GA2312@pul.manty.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Santiago Garcia Mantinan wrote:
> Hi!
> 
> I have just compiled a 2.6.23-rc8 using the config from my 2.6.22 as a basis
> and I came out with a not working (almost black) vga text console.
> 
> This is what I'm getting on my logs:
> 
> Console: colour dummy device 80x25
> console [tty0] enabled
> 
> Instead of the old:
> 
> Console: colour VGA+ 80x25
> 
> The options related to the console on my config are these:
> 
> CONFIG_VT=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_VGA_CONSOLE=y
> CONFIG_VIDEO_SELECT=y
> CONFIG_DUMMY_CONSOLE=y
> 
> The machine is a AMD x64 X2 Athlon with a NForce 4 chipset, vga is a ATI
> radeon and I have also set:
> 
> CONFIG_DRM=m
> CONFIG_DRM_RADEON=m
> 
> I have tried with and without CONFIG_VIDEO_SELECT and
> CONFIG_VIDEO_OUTPUT_CONTROL with the same results. BTW: when X starts the
> display is Ok.
> 
> If you want me to do any tests or need more info just tell me.
> 

Please send me your .config as well as /etc/grub.conf and the output of
/proc/cmdline.

It would also be useful if you could do the following:

- remove __initdata from the boot_params line in
arch/i386/kernel/setup.c or x86_boot_params in arch/x86_64/kernel/setup.c.

- Compile the kernel with CONFIG_DEBUG_INFO=y

- With the new kernel running, do:

gdb vmlinux /proc/kcore
p/x &boot_params [for x86-64, p/x &x86_boot_params]
dump binary memory bootparams.bin <address> <address>+4096

	-hpa
