Return-Path: <linux-kernel-owner+w=401wt.eu-S1161673AbXDXGo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161673AbXDXGo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161674AbXDXGo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:44:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161673AbXDXGo0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:44:26 -0400
Date: Mon, 23 Apr 2007 23:42:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerd Hoffmann <kraxel@suse.de>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Ralf Baechle <ralf@linux-mips.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch v2] Fixes and cleanups for earlyprintk aka boot console.
Message-Id: <20070423234240.29427438.akpm@linux-foundation.org>
In-Reply-To: <20070315154638.944768000@suse.de>
References: <20070315154638.944768000@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 16:46:39 +0100 Gerd Hoffmann <kraxel@suse.de> wrote:

> The console subsystem already has an idea of a boot console, using the
> CON_BOOT flag.  The implementation has some flaws though.  The major
> problem is that presence of a boot console makes register_console()
> ignore any other console devices (unless explicitly specified on the
> kernel command line).
> 
> This patch fixes the console selection code to *not* consider a boot
> console a full-featured one, so the first non-boot console registering
> will become the default console instead.  This way the unregister call
> for the boot console in the register_console() function actually
> triggers and the handover from the boot console to the real console
> device works smoothly.  Added a printk for the handover, so you know
> which console device the output goes to when the boot console stops
> printing messages.
> 
> The disable_early_printk() call is obsolete with that patch, explicitly
> disabling the early console isn't needed any more as it works
> automagically with that patch.
> 
> I've walked through the tree, dropped all disable_early_printk()
> instances found below arch/ and tagged the consoles with CON_BOOT if
> needed.  The code is tested on x86, sh (thanks to Paul) and mips
> (thanks to Ralf).
> 
> Changes to last version: Rediffed against -rc3, adapted to mips
> cleanups by Ralf, fixed "udbg-immortal" cmd line arg on powerpc.

I get this, across netconsole:

[17179569.184000] console handover: boot [earlyvga_f_0] -> real [tty0]

wanna take a look at why there's cruft in bootconsole->name please?

in grub.conf I have

        kernel /boot/bzImage-2.6.21-rc7-mm1 ro root=LABEL=/ rhgb vga=0x263 netconsole=4444@192.168.2.10/eth0,5145@192.168.2.33/00:0D:56:C6:C6:CC profile=1 earlyprintk=vga resume=8:5 time

and I'm using

http://userweb.kernel.org/~akpm/config-sony.txt

Thanks.
