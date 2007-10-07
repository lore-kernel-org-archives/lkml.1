Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbXJGPJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbXJGPJZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 11:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbXJGPJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 11:09:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59062 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753006AbXJGPJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 11:09:16 -0400
Date: Sun, 7 Oct 2007 16:12:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Oleg Verych <olecom@flower.upol.cz>, Ingo Molnar <mingo@elte.hu>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: NAK nettiquete (was Re: "Re: [PATCH 0/2] Colored kernel output
 (run2)"
Message-ID: <20071007161222.1b758f2f@the-village.bc.nu>
In-Reply-To: <2614.1191766530@turing-police.cc.vt.edu>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr>
	<20071006195105.GE22435@flower.upol.cz>
	<20071006194820.GA30579@elte.hu>
	<20071006210349.GG22435@flower.upol.cz>
	<20071007060706.GA18768@elte.hu>
	<20071007111035.GO22435@flower.upol.cz>
	<2614.1191766530@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The few times I've tried to NAK something outright, I've always tried to attach
> plenty of technical explanation 

Fair comment to my "silly" response

The problems I see are

- We run on a lot more than VGA PC consoles
- We have serial consoles (which may or may not be VT132/ANSI compliant)
- The printk paths are run at IRQ time ASAP to get messages to console,
that could mean we split existing colour escape code processing and the
like.
- People redirect the console feed other places via ioctl. Some of them
parse "<%d>" as the start

But most importantly:

- If you want to do "pretty" boot up you do it in X or frame buffer
(which is going to get easier and easier with the X shift to kernel side
video support)
- If you want to do a coloured display after boot then this is a matter
for your logging tools

As with translation the kernel is the wrong place to do this work.

What I would much rather people thought about was

- Marker modes for translation (so you know which bits of a message are
formatted up)
- More consistency on the use of "name: blah" to make it easier to parse
- Turning more messages from kernel logs to events when it makes sense
(eg "Disk Full", "Media Error", "CPU on fire")

So if you want to do a pretty boot, then solve the big picture, the
framebuffer initrd graphical boot, the boot display, the combining of
artwork and messages in user space from initrd run code.

'leet kernel messages in flashing red are not really the problem that
needs solving to do this.

Alan
