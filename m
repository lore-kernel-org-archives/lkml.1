Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbXEaQps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbXEaQps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbXEaQpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:45:41 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:51777 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912AbXEaQpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:45:41 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 4/5] serial: convert early_uart to earlycon for 8250
Date: Thu, 31 May 2007 10:45:35 -0600
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <200705291844.00308.yinghai.lu@sun.com> <200705310917.19205.bjorn.helgaas@hp.com> <86802c440705310932x3c85d9eao109fcf6445bd5938@mail.gmail.com>
In-Reply-To: <86802c440705310932x3c85d9eao109fcf6445bd5938@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705311045.36411.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 May 2007 10:32:42 am Yinghai Lu wrote:
> On 5/31/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Wednesday 30 May 2007 10:48:59 pm Andrew Morton wrote:
> > > You could require that the architecture implement some specific function
> > > for mapping the early-uart.
> >
> > We could, but we already have bt_ioremap, dmi_ioremap, and early_ioremap.
> > Do we really want to proliferate more flavors of "early ioremap"?  I'd
> > rather consolidate the ones we already have.
> >
> not really.

I'm sorry, I don't understand the point you're making.

Andrew's proposal was that we could add early_uart_ioremap to the list of
bt_ioremap and dmi_ioremap.

I'm suggesting that maybe we should make bt_ioremap smart enough that
we could use it for early uart mapping.  And maybe we could get rid
of dmi_ioremap, and make DMI use bt_ioremap as well (this would require
some shims for x86_64 and ia64).

> dhcp-umpk12-63-201:/home/yhlu/xx/xx/kernel/linux-2.6/include # grep
> bt_ioremap * -r
> asm-i386/dmi.h:#define dmi_ioremap bt_ioremap
> asm-i386/io.h: * bt_ioremap() and bt_iounmap() are for temporary early boot-time
> asm-i386/io.h:extern void *bt_ioremap(unsigned long offset, unsigned long size);
> asm-i386/io.h:#define dmi_ioremap bt_ioremap
> 
> dhcp-umpk12-63-201:/home/yhlu/xx/xx/kernel/linux-2.6/include # grep
> early_ioremap * -r
> asm-x86_64/dmi.h:#define dmi_ioremap early_ioremap
> asm-x86_64/io.h:extern void *early_ioremap(unsigned long addr,
> unsigned long size);
> 
> dhcp-umpk12-63-201:/home/yhlu/xx/xx/kernel/linux-2.6/include # grep
> dmi_ioremap * -r
> asm-i386/dmi.h:#define dmi_ioremap bt_ioremap
> asm-i386/io.h:#define dmi_ioremap bt_ioremap
> asm-ia64/io.h:#define dmi_ioremap ioremap
> asm-x86_64/dmi.h:extern void *dmi_ioremap(unsigned long addr, unsigned
> long size);
> asm-x86_64/dmi.h:#define dmi_ioremap early_ioremap
