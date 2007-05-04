Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbXEDQ47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbXEDQ47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbXEDQ47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:56:59 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:46141 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbXEDQ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=nQ22w9hBBz8edBtMiQ7XUqe08jKLjqrkaKbu4cFQo4l9QYkDcU7lcHQjIPW7N4vZ85uhPWQD8W5kj4yXpPmYROlR5bgqJsnJehXHV+RBdwrG2u8YMIcfoqHF3m9YcMIiIqfG9OR83h5fOycoDbFkfPgYSGCi93ndF7l9TqGfQug=
Message-ID: <5486cca80705040956g47f634ddp80d67038e8e3305a@mail.gmail.com>
Date: Fri, 4 May 2007 18:56:53 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <5486cca80705040904v786f13dh5614174fcc51c202@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_52488_18375891.1178297813915"
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <200705041049.20989.oliver@neukum.org>
	 <5486cca80705040229g53933671m658bd028cadca155@mail.gmail.com>
	 <5486cca80705040233y70915a27yf7cbbc08a617e3ba@mail.gmail.com>
	 <463B46F4.6090906@microgate.com> <463B4988.9090005@microgate.com>
	 <1178290160.3913.2.camel@amdx2.microgate.com>
	 <5486cca80705040904v786f13dh5614174fcc51c202@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_52488_18375891.1178297813915
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 5/4/07, Antonino Ingargiola <tritemio@gmail.com> wrote:
> On 5/4/07, Paul Fulghum <paulkf@microgate.com> wrote:
> > Here is a patch against 2.6.21 which flushes the tty flip buffer
> > on ioctl(TCFLSH) for input.
> >
> > --- a/drivers/char/tty_io.c     2007-04-25 22:08:32.000000000 -0500
> > +++ b/drivers/char/tty_io.c     2007-05-04 09:30:01.000000000 -0500
> <snip>
>
> Thanks! I've applied the patch and I'm building the kernel. I'll
> report the result.

The system blocks during booting. I can unblock it with SysReq+K but
then I'm unable to log into X.

The boot messages  seems ok (full gzipped boot log attached):

Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
kernel: serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
kernel: 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
kernel: 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

and when I pres the emergency keys:

kernel: EXT3-fs: mounted filesystem with ordered data mode.
kernel: eth0: link up, 10Mbps, half-duplex, lpa 0x0000
kernel: NET: Registered protocol family 10
kernel: SysRq : SAK
kernel: SAK: killed process 1511 (vt-is-UTF8): process_session(p)==tty->session
kernel: SAK: killed process 1508 (unicode_start):
process_session(p)==tty->session
kernel: SAK: killed process 1409 (sh): process_session(p)==tty->session
kernel: SAK: killed process 301 (rc): process_session(p)==tty->session
kernel: SAK: killed process 298 (init): process_session(p)==tty->session
kernel: SAK: killed process 298 (init): process_session(p)==tty->session
kernel: SAK: killed process 301 (rc): process_session(p)==tty->session
kernel: SAK: killed process 1409 (sh): process_session(p)==tty->session
kernel: SAK: killed process 1508 (unicode_start):
process_session(p)==tty->session
kernel: SAK: killed process 1511 (vt-is-UTF8): process_session(p)==tty->session
kernel: ACPI: Processor [CPU0] (supports 2 throttling states)
kernel: [drm] Initialized drm 1.1.0 20060810
kernel: [drm] Initialized radeon 1.25.0 20060524 on minor 0
kernel: input: Power Button (FF) as /class/input/input4
kernel: ACPI: Power Button (FF) [PWRF]
kernel: input: Power Button (CM) as /class/input/input5

I'll try if I can make some serial test nevertheless from the console.


Regards,

  ~ Antonio

------=_Part_52488_18375891.1178297813915
Content-Type: application/x-gzip; name=boot.log.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f1aw2h7d
Content-Disposition: attachment; filename="boot.log.gz"

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

------=_Part_52488_18375891.1178297813915--
