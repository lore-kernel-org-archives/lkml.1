Return-Path: <linux-kernel-owner+w=401wt.eu-S1764685AbXEUSDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764685AbXEUSDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbXEUSC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:02:56 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:41957 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701AbXEUSCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:02:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH]serial: make early_uart to use early_prarm instead of console_initcall
Date: Mon, 21 May 2007 12:02:59 -0600
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Andi Kleen" <ak@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <200705181900.17101.yinghai.lu@sun.com> <200705211053.34131.bjorn.helgaas@hp.com> <86802c440705211036r19be100pa2d2ed13780f6316@mail.gmail.com>
In-Reply-To: <86802c440705211036r19be100pa2d2ed13780f6316@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211202.59817.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 May 2007 11:36:58 am Yinghai Lu wrote:
> On 5/21/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > earlycon=uart,io,0x3f8,9600n8
> > > earlycon=uart,io,0x3f8,9600n8 console=tty0
> > > earlycon=uart,mmio,0xff5e0000,115200n8
> >
> > Why do we have to have a new "earlycon" argument?  Why can't we just
> > parse "console=uart" early?
> 
> with console=uart, you need to call early_serial_console_init
> explictly in your arch setup_arch to get early console.

Can't we just do:

  early_param("console", setup_early_console);

and have setup_early_console() ignore everything except "uart"?
 
> with console_initcall(early_uart_console_init), the early_uart_console
> will be called via console_init in start_kernel, init/main.c that is
> not real early console.

I agree that's too late.

Bjorn

