Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbZFNL1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbZFNL1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbZFNL1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:27:38 -0400
Received: from mx.treblig.org ([80.68.94.177]:47701 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbZFNL1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:27:37 -0400
Date: Sun, 14 Jun 2009 13:27:34 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
Message-ID: <20090614122734.GA1499@gallifrey>
References: <20090613230842.GA18347@gallifrey> <4A349B67.1070603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A349B67.1070603@zytor.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.29.2-bytemark-kvm-tickless-2009-05-05 (i686)
X-Uptime: 13:19:57 up 19 days,  5:41,  2 users,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Dr. David Alan Gilbert wrote:
> > Hi,
> >   I've got an old Pentium 90 machine that's been running a 2.4.x
> > kernel for a long time, seems to work OK on a 2.6.18 kernel
> > but doesn't seem to like anything newer.
> > 
> > 2.6.30 no keyboard - but otherwise OK
> > 2.6.28 no keyboard - but otherwise OK
> > 2.6.26 reboots just after parsing ELF (maybe one more line)
> > 2.6.25 reboots almost immediately
> > 2.6.18 works OK
> > 
> > The 2.6.18 and 26 are Debian kernels (etch and lenny), the
> > rest are vanilla from git.
> > 
> > So it looks like something got fixed between 26 and 28 that
> > stops the early reboot.
> > 
> > Attached is the .config from the 2.6.30 and a dmesg from that boot.
> > /proc/interrupts shows 8 interrupts on interrupt 1 from the i8042
> > but it doesn't go up if I type.  I've tried a couple of different
> > keyboards, so I don't think it's just a dislike for the keyboard.
> > 
> > I can see a /sys entry for the i8042 - I just don't get any input.
> > 
> > It has an ISA VGA card (Trident 1M) (I needed the PCI slots
> > for another net card!).
> > 
> > I compiled it on a 64bit Ubuntu machine.
> > 
> > [    0.000000] Linux version 2.6.302.6.30gort1 (dg@davros) (gcc version 4.4.0 (Ubuntu 4.4.0-5ubuntu1) ) #2 Sat Jun 13 18:18:17 BST 2009
> 
> It would be good to try an unmodified 2.6.30 kernel here...

It is unmodified - I just set the local version during the config (and forgot
I should have put a - in).

> > [    0.000000] KERNEL supported cpus:
> > [    0.000000]   Intel GenuineIntel
> > [    0.000000]   AMD AuthenticAMD
> > [    0.000000]   NSC Geode by NSC
> > [    0.000000]   Cyrix CyrixInstead
> > [    0.000000]   Centaur CentaurHauls
> > [    0.000000]   Transmeta GenuineTMx86
> > [    0.000000]   Transmeta TransmetaCPU
> > [    0.000000]   UMC UMC UMC UMC
> > [    0.000000] BIOS-provided physical RAM map:
> > [    0.000000]  BIOS-88: 0000000000000000 - 000000000009f000 (usable)
> > [    0.000000]  BIOS-88: 0000000000100000 - 0000000004000000 (usable)
> 
> Is 64 MB correct for this machine?

Yes.

> 
> > [    3.147416] PNP: No PS/2 controller found. Probing ports directly.
> > [    3.174456] serio: i8042 KBD port at 0x60,0x64 irq 1
> > [    3.174961] serio: i8042 AUX port at 0x60,0x64 irq 12
> > [    3.186312] mice: PS/2 mouse device common for all mice
> 
> It does, correctly, identify the keyboard and mode port, so it's
> somewhat odd that it doesn't get used...

Indeed. The only other observation in the older kernel that works
it detects the AUX port first.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
