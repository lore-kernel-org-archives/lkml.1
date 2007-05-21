Return-Path: <linux-kernel-owner+w=401wt.eu-S1764125AbXEUWmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764125AbXEUWmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbXEUWmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:42:06 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:60773 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710AbXEUWmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:42:04 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH]serial: make early_uart to use early_param instead of console_initcall
Date: Mon, 21 May 2007 16:42:05 -0600
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Andi Kleen" <ak@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <86802c440705211336h76a3f41ag4847860ea6837485@mail.gmail.com>
In-Reply-To: <86802c440705211336h76a3f41ag4847860ea6837485@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211642.05620.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 May 2007 02:36:16 pm Yinghai Lu wrote:
> On 5/21/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > with console=uart, you need to call early_serial_console_init
> > > explictly in your arch setup_arch to get early console.
> >
> > Can't we just do:
> >
> >   early_param("console", setup_early_console);
> 
> please check following patch. it will take
> console=early8250,io,0x3f8,9600n8

How about just plain "console=8250,io,..."?

> You may need to remove early_serial_console_init in your ia64
> setup_arch, and some dummy function for set_fixmap_nocache, and
> __fix_to_virt in your asm-ia64/fixmap.h

I don't want to add asm-ia64/fixmap.h with dummy definitions
just for this.

Can we add this:

  asm-ia64/io.h:   #define bt_ioremap ioremap
  asm-x86_64/io.h: #define bt_ioremap early_ioremap

and use bt_ioremap instead?

> new command line will be
> 
>       earlycon=early8250,io,0x3f8,9600n8
>       earlycon=early8250,mmio,0xff5e0000,115200n8
>  or
>       console=early8250,io,0x3f8,9600n8
>       console=early8250,mmio,0xff5e0000,115200n8

If you can make "console=early8250" work, we don't need
"earlycon=early8250", do we?

Your patch adds trailing whitespace and a few cases of"<space><tab>".
I use this in my .vimrc to catch these:

  highlight WhitespaceEOL ctermbg=red guibg=red
  match WhitespaceEOL /\s\+$\| \+\ze\t/
