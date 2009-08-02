Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbZHBK5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbZHBK5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 06:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZHBK5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 06:57:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56938 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751987AbZHBK5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 06:57:22 -0400
Date: Sun, 2 Aug 2009 11:58:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jack Byer <ojbyer@usa.net>
Cc: Robert Hancock <hancockrwd@gmail.com>, Andreas Mohr <andi@lisas.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Extremely slow IO with a PCMCIA CompactFlash adapter
Message-ID: <20090802115826.0174f292@lxorguk.ukuu.org.uk>
In-Reply-To: <cdb43e8a0908011544o69c2203dv39ce5a04840e0869@mail.gmail.com>
References: <h51hro$p6j$1@ger.gmane.org>
	<4A748A48.8020702@gmail.com>
	<cdb43e8a0908011544o69c2203dv39ce5a04840e0869@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> irq 3: nobody cared (try booting with the "irqpoll" option)
> Pid: 23488, comm: modprobe Not tainted 2.6.31-rc4 #2
> Call Trace:

Something is misrouting interrupts on your machine. COuld be an ACPI bug,
could be wrong tables in the BIOS etc.

> Now I rebooted with irqpoll and everything looks good in dmesg:

It will recover from the problem sort of

> Now my transfer rate has increased to 20 kilobyte / second read, about
> 4 times faster than before but still pretty slow.

You should see nearer 200K/sec (PIO 0) but if the device IRQ is being
lost due to misrouting then the device is being polled off the timer tick
and that will drastically reduce performance.

So its a firmware/acpi/irq sort of problem not an IDE one. Try running
with acpi=off and without irqpoll just as a test.

Alan
