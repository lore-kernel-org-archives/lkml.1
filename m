Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbYFHCNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbYFHCNh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 22:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbYFHCN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 22:13:29 -0400
Received: from wsip-70-184-212-2.om.om.cox.net ([70.184.212.2]:45128 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYFHCN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 22:13:28 -0400
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: bcm33xx port
Content-Disposition: inline
From: Luke -Jr <luke@dashjr.org>
Organization: -Jr Family
Date: Sat, 7 Jun 2008 21:13:24 -0500
PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
Jabber-ID: luke@dashjr.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806072113.26433.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 June 2008, you wrote:
> On Sat, 2008-06-07 at 20:19 -0500, Luke -Jr wrote:
> > I am working on a port for the bcm33xx platform, which includes a MIPS
> > CPU: http://wiki.openwrt.org/BroadcomBCM33xxPort
> >
> > However, I seem to be hitting problems with memory allocation, as
> > load_elf_binary is segfaulting inside padzero/__bzero.
>
> Seems to have issues way before that ;-)

No doubt, but those don't appear to be getting in my way yet ;)

> > This is my first attempt at real Linux kernel development, so if anyone
> > could throw me pointers on how I would approach debugging and fixing this
> > problem, I'd really appreciate it. (boot log with early printk is
> > attached)
>
> I'm not too up on MIPS but there're a few things in the log which stand
> out to me:
>
> Determined physical RAM map:
>  memory: 00fa0000 @ 00000000 (usable)
> User-defined physical RAM map:
>  memory: 007a1200 @ 00000000 (usable)
>
> Can you confirm these sizes and locations for RAM?  Does anything change
> if you don't force the size constraint?

According to http://research.msrg.utoronto.ca/ece344/2007s/os161/mips.html ,
MIPS has a pretty odd memory layout, and I'm honestly not sure how Linux 
usually handles it. I don't feel competent to try and summarize the details 
on that page here.

> CPU frequency 32.00 MHz
>
> Really?  Is your bootloader setting the CPU up correctly before handing
> control to Linux?

The CPU is 200 MHz, I believe. The bootloader is just a part of VxWorks, not 
really meant to boot anything else.

> irq 8: nobody cared (try booting with the "irqpoll" option)
>
> What's on IRQ8, should anyone care at this early stage?  Did the
> bootloader enable this (should it)?

No idea, sorry.

> Reserved instruction in kernel code[#1]:
>
> You're compiling with an appropriate -march switch?

I believe so... It appears to be a "reserved instruction" only because of the 
memory area it tries to access. The instruction in question is "store word", 
nothing complex.

Thanks,

Luke
