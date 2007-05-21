Return-Path: <linux-kernel-owner+w=401wt.eu-S1763077AbXEURhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763077AbXEURhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbXEURhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:37:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:5551 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbXEURg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QokEUUovrg7qhHsD2REKLTmLGhzoU9ueM7gKQUXUNRt843OnVsiUlrywgXJGt/74pH2cuflYHLWaLfGup3n4IPsJJ0pntjv03HU5pGANE62Ko4bPCayUGBY8GSI8DWmme8gaE99yBg3vGRR1u//OTaK1evMAcnl/z8LmR0h+b/M=
Message-ID: <86802c440705211036r19be100pa2d2ed13780f6316@mail.gmail.com>
Date: Mon, 21 May 2007 10:36:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH]serial: make early_uart to use early_prarm instead of console_initcall
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Andi Kleen" <ak@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200705211053.34131.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705181900.17101.yinghai.lu@sun.com>
	 <20070520214657.fcf5e9ce.akpm@linux-foundation.org>
	 <86802c440705202356n3311b70bg92e1b9c500fc386f@mail.gmail.com>
	 <200705211053.34131.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > earlycon=uart,io,0x3f8,9600n8
> > earlycon=uart,io,0x3f8,9600n8 console=tty0
> > earlycon=uart,mmio,0xff5e0000,115200n8
>
> Why do we have to have a new "earlycon" argument?  Why can't we just
> parse "console=uart" early?

with console=uart, you need to call early_serial_console_init
explictly in your arch setup_arch to get early console.

with console_initcall(early_uart_console_init), the early_uart_console
will be called via console_init in start_kernel, init/main.c that is
not real early console.

YH
