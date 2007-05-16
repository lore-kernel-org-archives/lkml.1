Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbXEPP7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbXEPP7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbXEPP7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:59:16 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:50178 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbXEPP7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:59:15 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [patch] early printk and boot console fixups.
Date: Wed, 16 May 2007 09:59:12 -0600
User-Agent: KMail/1.9.6
Cc: "Gerd Hoffmann" <kraxel@suse.de>, "Andi Kleen" <ak@suse.de>,
       akpm@linux-foundation.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <45D5C473.4010608@suse.de> <86802c440705152117o34325f1dw4a0cdf95241b3b42@mail.gmail.com>
In-Reply-To: <86802c440705152117o34325f1dw4a0cdf95241b3b42@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705160959.12433.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2007 10:17:50 pm Yinghai Lu wrote:
> for early_uart_console, I have some ideas:
> 1. merged that into early_serial_console in
> arch/x86_64/kernel/early_printk.c, and
> move early_printk.c to kernel/, --- make it understand
>      earlyprintk=uart,io,0x3f8,9600n8
>      earlyprintk=uart,mmio,0xff5e0000,115200n8
> in addition to vga, ttyS, serial

I would rather try to merge 8250_early and early_printk.
"console=uart,io,0x3f8" is already pretty similar to
"earlyprintk=serial", and it would be nice to have only one.

"console=uart" does have the disadvantage that you have to know the
port address.  But it has the advantage that it doesn't depend on
compiled-in legacy serial port names.  If you need early console
output, you're probably a developer and can come up with the address.

I think it would be nice to have a "console=vga".  That could use
the current "earlyprintk=vga" implementation, and automatically
hand off to tty0.

Then we could remove "earlyprintk=" and always use "console=uart"
or "console=vga".

Bjorn


