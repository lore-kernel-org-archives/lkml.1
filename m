Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbYDXQHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbYDXQHC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:07:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYDXQGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:06:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50795 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754013AbYDXQGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:06:52 -0400
Date: Thu, 24 Apr 2008 16:37:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [git patch] free_irq() fixes
Message-ID: <20080424163735.29ef21db@the-village.bc.nu>
In-Reply-To: <alpine.LFD.1.10.0804240847230.2779@woody.linux-foundation.org>
References: <20080422221733.GA16260@havoc.gtf.org>
	<alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org>
	<480E6DE5.6010103@garzik.org>
	<alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>
	<480E796E.4070001@garzik.org>
	<alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>
	<20080423000529.GG28933@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>
	<480F3ECC.1090809@keyaccess.nl>
	<480FEC1B.6040102@garzik.org>
	<alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org>
	<m1od7zkd2s.fsf@frodo.ebiederm.org>
	<481066C1.1030805@garzik.org>
	<alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org>
	<4810A9E6.1080201@garzik.org>
	<alpine.LFD.1.10.0804240847230.2779@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But then you'd have to have some way to "printk" the information, which is 
> a very common requirement (and the printk still needs to be a number, 
> because you want to match up 'dmesg' output with the '/proc/interrupts' 
> file etc).
> 
> That, in turn, would effectively force a whole new function, and then 
> you'd have things like
> 
> 	printk(.. irq %d .., irq_number(irqcookie) ..)
> 
> which while not ugly isn't really all that clean either. And I guarantee 
> that people would misuse that "irq_number(cookie)" exactly in the same 
> ways they'd misuse "irq" (ie not very much).

Sparc32 had this and it was very ugly. However if you don't pass in the
IRQ then people will store the irq value privately and things like
request_irq can deal with numeric interrupts and the like as before while
new interfaces for MSI can deal in MSI objects whatever they end up like.

Kill off the *use* of the int irq passed into functions as Jeff has
basically done and you can later replace it with a structure that contains
useful info, some private some not. For now all it has to do is happen to
be a masked int as you suggest.

Alan
