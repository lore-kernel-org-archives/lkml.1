Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbXGISaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbXGISaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbXGISaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:30:25 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:42863 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbXGISaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:30:24 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Luca <kronos.it@gmail.com>
Subject: Re: [PATCH] Enable legacy support for serial ports when SERIAL_8250_PNP is disabled
Date: Mon, 9 Jul 2007 12:30:01 -0600
User-Agent: KMail/1.9.6
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070707233300.GA3267@dreamland.darkstar.lan> <200707090946.33101.bjorn.helgaas@hp.com> <68676e00707091030xe7a299je9f4e053ef2a2e98@mail.gmail.com>
In-Reply-To: <68676e00707091030xe7a299je9f4e053ef2a2e98@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707091230.01556.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2007 11:30:59 am Luca wrote:
> On 7/9/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Saturday 07 July 2007 05:33:00 pm Luca Tettamanti wrote:
> > > your patch:
> > >
> > > commit 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26
> > > Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > > Date:   Tue May 8 00:36:07 2007 -0700
> > >
> > >     x86, serial: convert legacy COM ports to platform devices
> > >
> > > disables probing using legacy code in favour of ACPI/PNP to avoid double
> > > discovery.
> > >
> > > However if SERIAL_8250_PNP is not enabled the user is left without
> > > serial ports (been there, done that - my kernel config suddenly wasn't
> > > working anymore). So:
> >
> > Yes, that's true.  Kconfig should automatically turn on SERIAL_8250_PNP
> > if PNP and SERIAL_8250 are selected, but it does give you a choice if
> > you have EMBEDDED set.  So I guess you must have this:
> >
> >   CONFIG_EMBEDDED=y
> >   CONFIG_PNP=y
> >   CONFIG_SERIAL_8250=y
> >   CONFIG_SERIAL_8250_PNP=n
> >
> > Why do you want PNP support, but not 8250_PNP support?
> 
> That's a good question :-) IIRC the serial PNP code used to mess up
> the mode of the port on my laptop, making it useless for debugging the
> boot. Bug was fixed long ago, but I didn't re-enabled that option.

It wouldn't surprise me if serial PNP can be tripped up by the
incomplete Linux PNP code or by buggy firmware.  If you find any
issues like that, I'll fix them.

> > If you turn off
> > PNP completely, you will have "pnp_platform_devices == 0", and the
> > existing code will do what you need.
> 
> Well for me it's a non-issue, I'm able to "work-around" it in many
> ways. My point is that a configuration that used to work and is still
> valid suddenly doesn't work anymore.

You're right about that, and it is a legitimate issue.  But given the
fact that (PNP && !SERIAL_8250_PNP) should be relatively unusual, my
opinion is that it's not worth extra ifdefs in legacy_serial.c.

If you have to use any workarounds like "legacy_serial.force", I think
that's a bug, and I'll fix it.

Bjorn
