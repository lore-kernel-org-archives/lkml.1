Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbXFZQcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbXFZQcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbXFZQcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:32:25 -0400
Received: from animx.eu.org ([216.98.75.249]:59301 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870AbXFZQcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:32:24 -0400
Date: Tue, 26 Jun 2007 12:25:16 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Hannu Savolainen <hannu@opensound.com>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org,
       Tomasz K??oczko <kloczek@rudy.mif.pg.gda.pl>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070626162515.GA19677@animx.eu.org>
Mail-Followup-To: Adrian Bunk <bunk@stusta.de>,
	Hannu Savolainen <hannu@opensound.com>,
	Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
	Tomasz K??oczko <kloczek@rudy.mif.pg.gda.pl>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <s5h4pkwi9u0.wl%tiwai@suse.de> <4680310D.6060206@opensound.com> <20070625231750.GF1094@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625231750.GF1094@stusta.de>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Jun 26, 2007 at 12:18:05AM +0300, Hannu Savolainen wrote:
> >...
> > What we would like to push is that the old "deprecated" OSS/Free are 
> > removed from the kernel. OSS/Free is based on about years old OSS API 
> > version which was too limited for many applications. Having OSS/Free in the 
> > kernel doesn't serve any purpose.
> 
> I am slowly removing all parts of the in-kernel OSS with ALSA drivers 
> for the same hardware.

I have a motherboard with an intel chipset and onboard audio.  I have a
problem with alsa.  There's no pcm* files in /proc/asound/card0.

I tried quake on it which didn't work.  I remembered the problem with oss
use on alsa and tried to do the echo "..." as stated in the kernel docs only
to find out the path doesn't exist.  Here's what I see:

[wakko@gohan:/proc/asound/card0] ls -l
total 0
dr-xr-xr-x  2 root root 0 Jun 26 12:26 codec97#0/
-r--r--r--  1 root root 0 Jun 26 12:26 id
-r--r--r--  1 root root 0 Jun 26 12:26 intel8x0
-rw-r--r--  1 root root 0 Jun 26 12:26 oss_mixer
[wakko@gohan:/proc/asound/card0] lspci -vns 1f.5
0000:00:1f.5 0401: 8086:24c5 (rev 02)
        Subsystem: 414c:4730
        Flags: bus master, medium devsel, latency 0, IRQ 5
        I/O ports at e000 [size=256]
        I/O ports at e400 [size=64]
        Memory at e0581000 (32-bit, non-prefetchable) [size=512]
        Memory at e0582000 (32-bit, non-prefetchable) [size=256]
        Capabilities: <available only to root>

[wakko@gohan:/proc/asound/card0] dmesg|tail -4
[  313.942182] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 5
(level, low) -> IRQ 5
[  313.942229] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[  314.293944] intel8x0_measure_ac97_clock: measured 52586 usecs
[  314.294097] intel8x0: clocking to 48000
[wakko@gohan:/proc/asound/card0] uname -a
Linux gohan 2.6.21 #1 PREEMPT Sat Jun 23 23:36:48 EDT 2007 i686 GNU/Linux
[wakko@gohan:/proc/asound/card0] 

This is a BCM IN845GV board.

What is interesting is the same driver (kernel 2.6.20) and the same pciid
(except for subsystem) works fine on another machine.
[wakko@vegeta:/proc/asound/card0] ls -l
total 0
dr-xr-xr-x 2 root root 0 Jun 26 12:29 codec97#0/
-r--r--r-- 1 root root 0 Jun 26 12:29 id
-r--r--r-- 1 root root 0 Jun 26 12:29 intel8x0
-rw-r--r-- 1 root root 0 Jun 26 12:29 oss_mixer
dr-xr-xr-x 3 root root 0 Jun 26 12:29 pcm0c/
dr-xr-xr-x 3 root root 0 Jun 26 12:29 pcm0p/
dr-xr-xr-x 3 root root 0 Jun 26 12:29 pcm1c/
dr-xr-xr-x 3 root root 0 Jun 26 12:29 pcm2c/
dr-xr-xr-x 3 root root 0 Jun 26 12:29 pcm3c/
dr-xr-xr-x 3 root root 0 Jun 26 12:29 pcm4p/
[wakko@vegeta:/proc/asound/card0] lspci -vns 1f.5
00:1f.5 0401: 8086:24c5 (rev 02)
        Subsystem: 15d9:4080
        Flags: bus master, medium devsel, latency 0, IRQ 24
        I/O ports at 2000 [size=256]
        I/O ports at 2400 [size=64]
        Memory at b0000c00 (32-bit, non-prefetchable) [size=512]
        Memory at b0000800 (32-bit, non-prefetchable) [size=256]
        Capabilities: <access denied>

[wakko@vegeta:/proc/asound/card0] 

Dmsg for this driver:
[  110.504446] ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 24
[  110.504636] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[  110.818894] intel8x0_measure_ac97_clock: measured 52791 usecs
[  110.818949] intel8x0: clocking to 48000

This is a Supermicro X5DA8 board (This one works fine!).

I don't know what to do with the BCM board other than just use OSS drivers
which work just fine on this board.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
