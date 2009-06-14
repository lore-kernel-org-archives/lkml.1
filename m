Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbZFNGkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbZFNGkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 02:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZFNGkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 02:40:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52612 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbZFNGkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 02:40:45 -0400
Message-ID: <4A349B67.1070603@zytor.com>
Date: Sat, 13 Jun 2009 23:40:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
References: <20090613230842.GA18347@gallifrey>
In-Reply-To: <20090613230842.GA18347@gallifrey>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dr. David Alan Gilbert wrote:
> Hi,
>   I've got an old Pentium 90 machine that's been running a 2.4.x
> kernel for a long time, seems to work OK on a 2.6.18 kernel
> but doesn't seem to like anything newer.
> 
> 2.6.30 no keyboard - but otherwise OK
> 2.6.28 no keyboard - but otherwise OK
> 2.6.26 reboots just after parsing ELF (maybe one more line)
> 2.6.25 reboots almost immediately
> 2.6.18 works OK
> 
> The 2.6.18 and 26 are Debian kernels (etch and lenny), the
> rest are vanilla from git.
> 
> So it looks like something got fixed between 26 and 28 that
> stops the early reboot.
> 
> Attached is the .config from the 2.6.30 and a dmesg from that boot.
> /proc/interrupts shows 8 interrupts on interrupt 1 from the i8042
> but it doesn't go up if I type.  I've tried a couple of different
> keyboards, so I don't think it's just a dislike for the keyboard.
> 
> I can see a /sys entry for the i8042 - I just don't get any input.
> 
> It has an ISA VGA card (Trident 1M) (I needed the PCI slots
> for another net card!).
> 
> I compiled it on a 64bit Ubuntu machine.
> 
> [    0.000000] Linux version 2.6.302.6.30gort1 (dg@davros) (gcc version 4.4.0 (Ubuntu 4.4.0-5ubuntu1) ) #2 Sat Jun 13 18:18:17 BST 2009

It would be good to try an unmodified 2.6.30 kernel here...

> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Centaur CentaurHauls
> [    0.000000]   Transmeta GenuineTMx86
> [    0.000000]   Transmeta TransmetaCPU
> [    0.000000]   UMC UMC UMC UMC
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-88: 0000000000000000 - 000000000009f000 (usable)
> [    0.000000]  BIOS-88: 0000000000100000 - 0000000004000000 (usable)

Is 64 MB correct for this machine?

> [    3.147416] PNP: No PS/2 controller found. Probing ports directly.
> [    3.174456] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    3.174961] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    3.186312] mice: PS/2 mouse device common for all mice

It does, correctly, identify the keyboard and mode port, so it's
somewhat odd that it doesn't get used...

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

