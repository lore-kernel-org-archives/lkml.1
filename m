Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbZCSUmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbZCSUmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760793AbZCSUla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:41:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59344 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760993AbZCSUl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:41:29 -0400
From: Gabor Kovacs <kgabor@bolyai.elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Lava dual parallel PCI card IRQ problem
Date: Thu, 19 Mar 2009 16:41:22 -0400
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200903130051.18119.kgabor@bolyai.elte.hu> <200903171852.20408.kgabor@bolyai.elte.hu> <20090318113559.2771b3c7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090318113559.2771b3c7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903191641.22590.kgabor@bolyai.elte.hu>
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Your patch looks good. IRQ detection works on my dual parallel port.

[ 3131.988489] pnp: the driver 'parport_pc' has been registered
[ 3131.988510] parport_pc 00:04: current resources: before 
pnp_assign_resources
[ 3131.988513] parport_pc 00:04:   irq 7 flags 0x401
[ 3131.988516] parport_pc 00:04:   io  0x378-0x37f flags 0x101
[ 3131.988521] parport_pc 00:04: assigning independent options
[ 3131.988524] parport_pc 00:04: assigning dependent option 1
[ 3131.988527] parport_pc 00:04:   io 0 already set to 0x378-0x37f flags 0x101
[ 3131.988530] parport_pc 00:04:   irq 0 already set to 7 flags 0x401
[ 3131.988532] parport_pc 00:04: current resources: after pnp_assign_resources
[ 3131.988535] parport_pc 00:04:   irq 7 flags 0x401
[ 3131.988538] parport_pc 00:04:   io  0x378-0x37f flags 0x101
[ 3131.988542] parport_pc 00:04: current resources: pnp_start_dev
[ 3131.988546] parport_pc 00:04:   irq 7 flags 0x401
[ 3131.988549] parport_pc 00:04:   io  0x378-0x37f flags 0x101
[ 3131.988553] parport_pc 00:04: set resources
[ 3131.989987] parport_pc 00:04: encode 3 resources
[ 3131.989990] parport_pc 00:04:   encode io 0x378-0x37f decode 0x1
[ 3131.989993] parport_pc 00:04:   encode irq 7 edge high exclusive (2-byte 
descriptor)
[ 3131.989996] parport_pc 00:04:   encode dma -1 type 0x0 transfer 0x0 master 
0
[ 3131.990898] parport_pc 00:04: activated
[ 3131.990898] parport_pc 00:04: reported by Plug and Play ACPI
[ 3131.990898] parport0: PC-style at 0x378, irq 7 [PCSPP]
[ 3132.093522] parport_pc 00:04: driver attached
[ 3132.094824] PCI parallel port detected: 1407:8002, I/O at 0xb880(0x0), IRQ 
17
[ 3132.094824] parport1: PC-style at 0xb880 [PCSPP,TRISTATE,EPP]
[ 3132.185524] PCI parallel port detected: 1407:8003, I/O at 0xb800(0x0), IRQ 
17
[ 3132.185547] parport2: PC-style at 0xb800 [PCSPP,TRISTATE,EPP]

======

01:07.0 Parallel controller: Lava Computer mfg Inc Lava Dual Parallel port A 
(rev 03) (prog-if 01 [BiDir])
        Subsystem: Lava Computer mfg Inc Lava Dual Parallel port A                                        
        Flags: medium devsel, IRQ 17                                                                      
        I/O ports at b880 [size=8]                                                                        
        Kernel driver in use: parport_pc                                                                  
        Kernel modules: parport_pc                                                                        

01:07.1 Parallel controller: Lava Computer mfg Inc Lava Dual Parallel port B 
(rev 03) (prog-if 01 [BiDir])
        Subsystem: Lava Computer mfg Inc Lava Dual Parallel port B                                        
        Flags: medium devsel, IRQ 17                                                                      
        I/O ports at b800 [size=8]                                                                        
        Kernel driver in use: parport_pc                                                                  
        Kernel modules: parport_pc                                                                        

......

06:00.0 Ethernet controller: VIA Technologies, Inc. VT6120/VT6121/VT6122 
Gigabit Ethernet Adapter (rev 82)
        Subsystem: VIA Technologies, Inc. Device 0110
        Flags: bus master, fast devsel, latency 0, IRQ 17
        I/O ports at e800 [size=256]
        Memory at febffc00 (64-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 3
        Capabilities: [90] Express Endpoint, MSI 00
        Capabilities: [c0] Message Signalled Interrupts: Mask+ 64bit+ 
Queue=0/0 Enable-
        Kernel driver in use: via-velocity
        Kernel modules: via-velocity

===

I also tried commenting out "irq = PARPORT_IRQ_NONE;" Interrupts are working, 
of course, driver is not yet aware of irq sharing. Each time I have some 
network traffic, I get an interrupt on parport, too. I guess the two ports on 
Lava card cannot be distinguished either.

Looking forward to the next part.

-- Gabor

On Wednesday 18 March 2009 07:35:59 Alan Cox wrote:
> First cut to try
>
> parport: Use the PCI IRQ if offered
>
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
>
> parport: Use the PCI IRQ if offered
>
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
>
>

