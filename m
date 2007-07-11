Return-Path: <linux-kernel-owner+w=401wt.eu-S1765226AbXGKQGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765226AbXGKQGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbXGKQGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:06:39 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:38812 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311AbXGKQGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:06:38 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] serial: do not add port that is not initialized
Date: Wed, 11 Jul 2007 10:05:53 -0600
User-Agent: KMail/1.9.6
Cc: Yinghai Lu <Yinghai.Lu@sun.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200707101703.36173.yinghai.lu@sun.com> <20070711071742.GA12952@flint.arm.linux.org.uk>
In-Reply-To: <20070711071742.GA12952@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111005.53836.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2007 01:17:42 am Russell King wrote:
> On Tue, Jul 10, 2007 at 05:03:35PM -0700, Yinghai Lu wrote:
> > [PATCH] serial: do not add port that is not initialized
> > 
> > if the port is not initialized with correct iobase, and membase, we don't
> > need to add that port.
> > for x86, when pnpacpi is enabled, we will not get extra ttyS1/ttyS2/ttyS3 in
> > /sys/devices/platform/serial8250/tty
> > 
> > Sign-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> What if someone wants to run setserial on /dev/ttyS1 to set it's base
> address, irq and other parameters?  People still do this.

I agree that people still use setserial that way, and we shouldn't
make this change because it would break things.

But I also agree with Yinghai that these extra phantom devices are
just weird.  It would be a lot nicer if there were a way to say,
"please, Mr. Serial Driver, create me a new ttyS device with these
parameters."

But no, I'm not volunteering to do that.

Bjorn
