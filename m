Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbXCKLgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbXCKLgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 07:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933142AbXCKLgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 07:36:37 -0400
Received: from tag.witbe.net ([81.88.96.48]:35187 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932965AbXCKLgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 07:36:36 -0400
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Tejun Heo'" <htejun@gmail.com>
Cc: "'Jeff Garzik'" <jeff@garzik.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       <linux-ide@vger.kernel.org>, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
Date: Sun, 11 Mar 2007 12:35:46 +0100
Organization: AS2917.net
Message-ID: <014d01c763d1$699510c0$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <45F157C3.4090604@gmail.com>
Thread-Index: AcdiSVmtZoUEouauTm++gUFi5Z82AwBhELNg
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> It seems like IRQ is not getting through.  The first IRQ 
> driven command is failing for you.

Hmmmm.... 
> Extract is :
> ata7: PATA max UDMA/100 cmd 0x0000000000019c00 ctl 0x0000000000019882 bmdma
> 0x0000000000019400 irq 16
> ata8: PATA max UDMA/100 cmd 0x0000000000019800 ctl 0x0000000000019482 bmdma
> 0x0000000000019408 irq 16

IRQ 16 is IO-APIC-fasteoi for libata, and is not shared... but all the
others libata IRQ are IO-APIC-edge.

> * Does giving 'acpi=off' or 'irqpoll' make any difference?
> 
> * Can you connect a harddisk to the channel and see whether 
> that works?
Tried that.. Disk is identified as ATA-7: Mastor 6Y080L0, YAR41BW0, max
UDMA/13
and then timeout again...

Tried then with acpi=off, same result (identify is OK, but then timeout),
and irqpoll and then it was OK !!!!

Let's then go back to my DVD-RW and test irqpoll...
and ... Yes.... Got it !
It is identified, it can be mounted, and read as /dev/sr1 !

/proc/interrupts show a count of 0 for IRQ 16, so yes, it goes somewhere
else...

Doing some diffs on copy of /proc/interrupts while accessing the DVD
gives two possibilities : IRQ14 or IRQ18, but both are also counting
when not accessing the DVD...

Question : does running with irqpoll affects performance ?

Paul
 

