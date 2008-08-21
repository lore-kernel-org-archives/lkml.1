Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbYHUVej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbYHUVej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYHUVea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:34:30 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26459 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbYHUVe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:34:29 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Jaswinder Singh" <jaswinderlinux@gmail.com>
Subject: Re: [Bug #11272] BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
Date: Thu, 21 Aug 2008 15:34:16 -0600
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>, linux-serial@vger.kernel.org
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.F6.BDjnIB@albercik> <3f9a31f40808092354s3d057effm6ed1d2f506fb4637@mail.gmail.com>
In-Reply-To: <3f9a31f40808092354s3d057effm6ed1d2f506fb4637@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211534.16465.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 August 2008 12:54:14 am Jaswinder Singh wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11272
> > Subject         : BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
> > Submitter       : Jaswinder Singh <jaswinderlinux@gmail.com>
> > Date            : 2008-08-05 15:12 (5 days old)
> > References      : http://marc.info/?l=linux-kernel&m=121794900319776&w=4
> 
> This problem still exists on 2.6.27-rc2
> 
> When I connect  development boads to /dev/ttyS1 and /dev/ttyS2:
> bootloader still prints Junk (Garbage Characters) but when Linux
> starts then it becomes readable and normal.
> 
> So I thought problem is in bootloader so I connected different kind of
> develepment boards and all shows junk characters during boot-loading.
> 
> But when I connect  development boads to /dev/ttyS0 : bootloader
> messages are readable and normal with same settings.

This sounds like a problem with the port configuration, e.g.,
baud rate, data bits, etc.

I'm a little confused about what's connected to what.

I assume you have the consoles of various development boards ("targets")
connected to a NetMos card in the host, and you're running conserver
or something on the host.  And the target bootloader output is garbled,
but after the target boots Linux, the output from the target becomes
normal?

If that's the case, nothing should be changing on the host side that
could account for the change from garbled to normal.

I notice you're running at 115200.  Does the same thing happen if
you run at 9600 baud?  I'm wondering if the bootloader programs the
UART with a divisor that results in a baud rate that's enough different
to cause garbling, and when Linux boots, it reprograms the UART with
something that matches the NetMos more closely.  The builtin ttyS0
and the NetMos ports probably use different clocks, which could
explain why it works on one but not the other.

There were no changes in parport_serial between 2.6.26 and 2.6.27-rc2.
Please confirm whether this is a regression from 2.6.26 or not.

Bjorn
