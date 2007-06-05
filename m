Return-Path: <linux-kernel-owner+w=401wt.eu-S933909AbXFEXYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909AbXFEXYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763433AbXFEXYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:24:12 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:57725 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762844AbXFEXYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:24:11 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Tue, 5 Jun 2007 17:23:56 -0600
User-Agent: KMail/1.9.6
Cc: "Samuel Ortiz" <samuel@sortiz.org>, arvidjaar@mail.ru,
       linux-kernel@vger.kernel.org,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <7VXmfiOJ.1181030230.9946640.samuel@sortiz.org> <A6D19A13FE030A409EC4362C172E091F016F51B1@eseldmw101.eemea.ericsson.se>
In-Reply-To: <A6D19A13FE030A409EC4362C172E091F016F51B1@eseldmw101.eemea.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706051723.56436.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 June 2007 05:57:30 am Linus Walleij (LD/EAB) wrote:
> You don't need to alter the defaults for the Toshiba ALi, the 
> preconfigure will respect the settings from the commandline,
> e.g. modprobe smsc-ircc2 ircc_fir=0x100,ircc_sir=0x02e8.
> 
> BUT this value just won't work: we don't know how to tell the ALi 1533
> to use any other ports than 0x130,0x178,0x03f8,0x02f8 or 0x02e8.

Something's wrong with this strategy.  The BIOS is telling us that an
SMCf010 device is present, active, and responds at io ports 0x100-0x107
and 0x2e8-0x2ef.  The fact that it happens to be on the other side of
an ISA or LPC bridge should be immaterial to the OS driver.

If an ACPI BIOS says the device is active, I don't think the OS should
have to preconfigure anything to make it work.  I don't know whether
this is just a broken BIOS on this machine, or whether we don't know
how to use it correctly yet.  The fact that we *do* have to preconfigure
so much stuff in smsc-ircc2.c makes me think that Linux is missing
something important in the way we deal with ISA and LPC bridges.

Andrey, can you collect your ACPI DSDT and "lspnp -vv" [1] output?
Maybe there will be a clue there.

[1] ftp://ftp.kernel.org/pub/linux/kernel/people/helgaas/pnputils-0.1.tar.bz2
