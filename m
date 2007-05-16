Return-Path: <linux-kernel-owner+w=401wt.eu-S933949AbXEPSOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbXEPSOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761213AbXEPSOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:14:21 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:56411 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760831AbXEPSOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:14:20 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patch] early printk and boot console fixups.
Date: Wed, 16 May 2007 12:14:16 -0600
User-Agent: KMail/1.9.6
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Gerd Hoffmann <kraxel@suse.de>,
       Andi Kleen <ak@suse.de>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <45D5C473.4010608@suse.de> <200705160959.12433.bjorn.helgaas@hp.com> <Pine.LNX.4.64N.0705161803110.29569@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0705161803110.29569@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705161214.16426.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 11:09:14 am Maciej W. Rozycki wrote:
> On Wed, 16 May 2007, Bjorn Helgaas wrote:
> 
> > > for early_uart_console, I have some ideas:
> > > 1. merged that into early_serial_console in
> > > arch/x86_64/kernel/early_printk.c, and
> > > move early_printk.c to kernel/, --- make it understand
> > >      earlyprintk=uart,io,0x3f8,9600n8
> > >      earlyprintk=uart,mmio,0xff5e0000,115200n8
> > > in addition to vga, ttyS, serial
> > 
> > I would rather try to merge 8250_early and early_printk.
> > "console=uart,io,0x3f8" is already pretty similar to
> > "earlyprintk=serial", and it would be nice to have only one.
> > 
> > "console=uart" does have the disadvantage that you have to know the
> > port address.  But it has the advantage that it doesn't depend on
> > compiled-in legacy serial port names.  If you need early console
> > output, you're probably a developer and can come up with the address.
> 
>  Given the generic name of "uart" I am assuming this will work with any 
> UART driver making use of the serial_core.c core -- am I correct?

I knew somebody would ask that eventually :-)

Unfortunately, the answer is "no."  "console=uart" only works with
8250-compatible devices.
