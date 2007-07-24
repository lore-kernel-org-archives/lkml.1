Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbXGXRuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbXGXRuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbXGXRuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:50:02 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57512 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbXGXRuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:50:00 -0400
Message-ID: <46A63BC3.3050208@garzik.org>
Date: Tue, 24 Jul 2007 13:49:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: =?ISO-8859-15?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <200707240948.45916.bjorn.helgaas@hp.com>
In-Reply-To: <200707240948.45916.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Tuesday 24 July 2007 08:28:05 am Sébastien Dugué wrote:
>>  your commit 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26 broke the serial console
>> on my box. Adding 'legacy_serial.force=1' to my boot param as a workaround
>> solves the issue, but this may be hiding bugs in Linux PnP support or
>> in my firmware.
> 
> Thanks for your report.  We need to figure out why the 8250_pnp driver
> didn't find your serial console device.  Can you confirm that you also
> have CONFIG_ACPI and CONFIG_PNPACPI in your .config?
> 
> If you have those, and it still doesn't work, can you collect the DSDT
> dump, the output of "grep . /sys/bus/pnp/devices/*/*", and the dmesg
> from your "legacy_serial.force=1" boot?  Then we can tell which port
> the blind probe finds and whether it's described somewhere by ACPI.

hrm...

     x86, serial: convert legacy COM ports to platform devices

     Make x86 COM ports into platform devices and don't probe for them
     if we have PNP.

This seems like it will break decades-long-working stuff, in favor of 
breaking new ground in our favorite area, "trusting the BIOS."

It's just not worth it for serial ports, IMO.  Serial ports are 
something that just shouldn't break at this late stage in the game.  My 
new Intel platform boxes don't even have serial ports, so I question the 
value of messing with serial port probing even more... because... just 
wait a year, and your box won't have a serial port either!  :)

I certainly don't object to the use of platform devices (or isa_driver), 
but the probe change seems questionable.  That's sorta analagous to 
rewriting the floppy driver probe routine.  Sure you could do it... but 
why risk all that damage and go through debugging all over again?

It seems clear from this report that we cannot, should not, trust BIOS 
for something (a) so simple and (b) that has been working for over a decade.

	Jeff


