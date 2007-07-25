Return-Path: <linux-kernel-owner+w=401wt.eu-S934503AbXGYReW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934503AbXGYReW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762219AbXGYReO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:34:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40832 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760748AbXGYReN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:34:13 -0400
Date: Wed, 25 Jul 2007 18:38:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jeff Garzik <jeff@garzik.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       =?UTF-8?B?U8ODwqliYXN0aWVuIER1Z3U=?= =?UTF-8?B?w4PCqQ==?= 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
Message-ID: <20070725183823.46df17a7@the-village.bc.nu>
In-Reply-To: <200707251006.42948.bjorn.helgaas@hp.com>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	<p73ir88sax1.fsf@bingen.suse.de>
	<20070725164808.41404dc7@the-village.bc.nu>
	<200707251006.42948.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The IR driver would be the clear owner of the entire device.  Of course,
> this still only works if we get rid of the 8250 blind probe for 0x3e8
> or figure out some API for the IR driver to tell the 8250 driver to get
> its mitts off.

As far as I can see all we need is something of the form


	serial8250_claim_uart(unsigned long ioaddr, int type)  

(type as we don't have iomap on most platforms yet)

	returning

		-EBUSY		"serial port is open"
		-ENOENT		"never heard of it"
		0		"ok"

and
	serial8250_unclaim_uart(unsigned long ioaddr, int type)

