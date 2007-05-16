Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbXEPQ4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbXEPQ4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXEPQ4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:56:30 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:45532 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXEPQ43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:56:29 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [patch] early printk and boot console fixups.
Date: Wed, 16 May 2007 10:56:26 -0600
User-Agent: KMail/1.9.6
Cc: "Gerd Hoffmann" <kraxel@redhat.com>, "Andi Kleen" <ak@suse.de>,
       akpm@linux-foundation.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <45D5C473.4010608@suse.de> <200705160959.12433.bjorn.helgaas@hp.com> <86802c440705160929t5cbec9d2me2b83db34a9c572f@mail.gmail.com>
In-Reply-To: <86802c440705160929t5cbec9d2me2b83db34a9c572f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705161056.26386.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 10:29:11 am Yinghai Lu wrote:
> On 5/16/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Tuesday 15 May 2007 10:17:50 pm Yinghai Lu wrote:
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
> >
> > I think it would be nice to have a "console=vga".  That could use
> > the current "earlyprintk=vga" implementation, and automatically
> > hand off to tty0.
> >
> > Then we could remove "earlyprintk=" and always use "console=uart"
> > or "console=vga".
> 
> earlyprintk= is needed for seeting bootconsole, or setting CON_BOOT,
> and it is could be loaded earlier with early_param than console_init.

8250_early.c does basically the same thing as the serial part of
early_printk.c, so we should be able to make it work just as early.
I don't remember why I didn't use early_param() for 8250_early;
I probably should have.  On ia64, it doesn't matter because we call
early_serial_console_init() explicitly at about the time of
parse_early_param().

8250_early and early_printk are so similar, I just don't see the
need for both.

Bjorn
