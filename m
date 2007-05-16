Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbXEPQ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbXEPQ3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXEPQ3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:29:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:13233 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXEPQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:29:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=epZFVrWcmHYOomnetRy4BU/mRymR36Puqm1Qoq3b6UncT0KkWKtsinEZ7aJQoA0cFzdyGFcn8qN3jKz4abPAJJ2HbL9MB6XRIcvIxoO/zQ5oaGwqLctCw1ijBIhDvtAig5niVsRrJfLHkLnieLeWZs/IA2vs1iAeojJZwl2KqKU=
Message-ID: <86802c440705160929t5cbec9d2me2b83db34a9c572f@mail.gmail.com>
Date: Wed, 16 May 2007 09:29:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [patch] early printk and boot console fixups.
Cc: "Gerd Hoffmann" <kraxel@redhat.com>, "Andi Kleen" <ak@suse.de>,
       akpm@linux-foundation.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200705160959.12433.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D5C473.4010608@suse.de>
	 <86802c440705152117o34325f1dw4a0cdf95241b3b42@mail.gmail.com>
	 <200705160959.12433.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Tuesday 15 May 2007 10:17:50 pm Yinghai Lu wrote:
> > for early_uart_console, I have some ideas:
> > 1. merged that into early_serial_console in
> > arch/x86_64/kernel/early_printk.c, and
> > move early_printk.c to kernel/, --- make it understand
> >      earlyprintk=uart,io,0x3f8,9600n8
> >      earlyprintk=uart,mmio,0xff5e0000,115200n8
> > in addition to vga, ttyS, serial
>
> I would rather try to merge 8250_early and early_printk.
> "console=uart,io,0x3f8" is already pretty similar to
> "earlyprintk=serial", and it would be nice to have only one.
>
> "console=uart" does have the disadvantage that you have to know the
> port address.  But it has the advantage that it doesn't depend on
> compiled-in legacy serial port names.  If you need early console
> output, you're probably a developer and can come up with the address.
>
> I think it would be nice to have a "console=vga".  That could use
> the current "earlyprintk=vga" implementation, and automatically
> hand off to tty0.
>
> Then we could remove "earlyprintk=" and always use "console=uart"
> or "console=vga".

earlyprintk= is needed for seeting bootconsole, or setting CON_BOOT,
and it is could be loaded earlier with early_param than console_init.

in the console_init (via register_console), the console is handed over
from bootconsole to normal console.

also console_init could be moved to quite late than current, and till
some subsystem is initialized like pci and usb.

YH
