Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbXLJMI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbXLJMI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 07:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXLJMIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 07:08:52 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43233 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752325AbXLJMIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 07:08:51 -0500
Date: Mon, 10 Dec 2007 12:02:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071210120236.30258206@the-village.bc.nu>
In-Reply-To: <20071209232208.GA1726@elf.ucw.cz>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<20071209125458.GB4381@ucw.cz>
	<20071209165908.GA15910@one.firstfloor.org>
	<20071209212513.GC24284@elf.ucw.cz>
	<20071209222928.3f7b63a4@the-village.bc.nu>
	<20071209232208.GA1726@elf.ucw.cz>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Really? 
> 
> udelay() seems to use
> ... cpu_data(raw_smp_processor_id()).loops_per_jiffy .. 

Ok that should be a good safety
> 
> ..so it seems that bug trap is already there... because
> raw_smp_processor_id() will probably just oops...

And I double checked my docs - they say 8 cycles - 1uS

Incidentally some of the drivers seem buggy for SMP. The bus locking
nature of the inb_p probably hid this but they don't all seem to have
sufficient locking to ensure that we don't get back to back cycles
without delays

Alan
