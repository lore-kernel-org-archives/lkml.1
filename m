Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbXLCB5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbXLCB5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 20:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbXLCB5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 20:57:43 -0500
Received: from mail.tmr.com ([64.65.253.246]:39205 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbXLCB5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 20:57:42 -0500
Message-ID: <4753664A.6060000@tmr.com>
Date: Sun, 02 Dec 2007 21:13:30 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: kmh@nerdshack.com
CC: linux-kernel@vger.kernel.org, lermen@elserv.ffm.fgan.de, lermen@fgan.de,
       davej@redhat.com, cebbert@redhat.com
Subject: Re: PROBLEM: loadlin incompatible with 2.6.23 kernels
References: <200712022336.SAA12095@granite.sover.net>
In-Reply-To: <200712022336.SAA12095@granite.sover.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenneth Howlett wrote:
> The loadlin boot loader fails to boot 2.6.23 kernels.
> 
> I used msdos 6.22 in real mode, without himem.sys or any other memory
> manager, without any tsrs; loadlin 1.6c; and kernel 2.6.23.1-42.fc8, which
> is the install kernel for the fedora core 8 distribution. The normal loadlin
> messages are displayed, the display is cleared and the cursor moves to the
> upper left corner, and then nothing else happens. No kernel boot messages
> are displayed. The computer does not respond to most keyboard actions, but
> the computer does reboot when I press control-alternate-delete.
> 
> My computer is a dell dimension 4100 with pentium III 733mhz and intel
> chipset, and ATI radeon all-in-wonder display controller.
> 
> The output of loadlin -d is:
> LOADLIN v1.6c (C) 1994..2002 Hans Lermen <lermen@fgan.de>
> 
> Your current LINUX kernel boot configuration is:
>   image file:       fed8.ker
>   kernel version    2.6.23.1-42.fc8 (kojibuilder@xenbuilder1.fedora.redhat.com) #1 SMP Tue Oct 30 13:05:10 EDT 2007
>   kernel size:     0x001E0300 (high loaded) setup size:  0x2C00, heap: 0x1200
>   VGA mode:         0xFFFF
>   command line (size 0x0013):
>     BOOT_IMAGE=fed8.ker
> 
> Your current DOS/CPU configuration is:
>   load buffer size: 0x00F60000 EXT , setup buffer size:  0x3E00
>   lowmem buffer:    0x00080000 (part of load buffer)
>   total memory:     0x040FFC00
>   CPU is in REAL mode
>   SetupIntercept: YES, legal intercept, setup header version 0206
>   stat1: cpu in real 386 mode, no need to backswitch
>   input params (size 0x0011):
>     fed8.ker -d o.txt
>   LOADLIN started from DOS-prompt
> 
> Option -t set, Linux not loaded
> 
> 
> I tried using loadlin -f, and the result was the same. I tried using loadlin
> -noheap, and the computer rebooted itself instead of crashing. I tried using
> freedos 1.0 instead of msdos 6.22, and instead of crashing, the computer
> displayed a message saying invalid opcode, and the dos prompt returned. I
> tried using the 586, 686, and debug kernels from packages on the fedora core
> 8 dvd, and the result was the same. I tried using the pae kernel from the
> package on the fedora core 8 dvd, and the computer crashed like before, but
> this time the computer did not respond to control-alternate-delete.
> 
> Loadlin works ok with older kernels. The kernel works ok with other boot
> loaders. I tested the integrity of my fedora core 8 dvd and it was ok.
> 
> I searched the web, and the only reference I found was
> <a href="http://kerneltrap.org/node/14842">http://kerneltrap.org/node/14842</a>.
> The first comment is from me. The person who wrote the original post
> seems to be compiling his own kernels; therefore this is probably a kernel
> problem, not a problem with the fedora core 8 distribution. The person who
> wrote the original post says that kernel 2.6.22.12 did not have this
> problem, therefore the problem probably appeared in the 2.6.23 kernels, and
> earlier kernels are probably ok.
> 
> I do not know if the problem is with the kernel or with loadlin. Probably
> some people will say it is the kernel's fault, and other people will say it
> is loadlin's fault.
> 
> I am not knowledgable about the kernel boot process, but I am guessing that
> the first thing the kernel does is uncompress itself, and the second thing
> the kernel does is set the vga or framebuffer mode. I am guessing that the
> clearing of the display is not done by loadlin, but is done as part of
> setting the vga or framebuffer mode. Therefore I guessed that the kernel
> successfully uncompressed itself, then got stuck setting the vga or
> framebuffer mode. So I tried changing the vga options.
> 
> With vga=normal, the result is the same. With vga=771 (vesa framebuffer,
> 800x600, 256 colors), the computer crashes like before, but the cursor is
> not visible in the upper left corner. With vga=ask, the computer displays a
> message saying press enter for list, press space to continue. If I press
> space, the computer crashes. If I press enter, the computer displays a list
> of video modes. If I select 0, the computer crashes without changing the
> display. If I select 1, the text becomes smaller and occupies a smaller part
> of the display, and the computer crashes. If I select 2, the display
> clears and the computer crashes. With all of these crashes, the computer can
> still be rebooted by pressing control alternate delete.
> 
> I conclude that the problem occurs after or at the end of setting the vga or
> framebuffer mode. The problem probably occurs before or at the beginning of
> probing for hardware, because no kernel boot messages are displayed after
> the vga=ask messages.
> 
> I do not know why this occurs with loadlin and not with other boot loaders.
> 
Lots of stuff has changed in recent versions, if you can try booting 
with the option "acpi=off" that might or might not be informative. 
Haven't used loadlin in years, and be aware that the Fedora kernel is 
not entirely compatible with the kernel.org releases, although that's 
rarely a problem.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
