Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbYALPRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbYALPRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 10:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYALPQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 10:16:52 -0500
Received: from bossdog.realss.com ([211.157.108.128]:44356 "EHLO
	bossdog.realss.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYALPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 10:16:51 -0500
Subject: Re: Huawei EC321 CDMA PCCARD support broken
From: =?UTF-8?Q?=E5=BC=A0=E9=9F=A1=E6=AD=A6?= <zhangweiwu@realss.com>
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: linux-kernel@vger.kernel.org, hugh@blemings.org
In-Reply-To: <20080108062739.GO22955@kiste.smurf.noris.de>
References: <1199753931.6093.7.camel@Cruella>
	 <20080108062739.GO22955@kiste.smurf.noris.de>
Content-Type: text/plain; charset=utf-8
Organization: Real Softservice
Date: Sat, 12 Jan 2008 23:16:34 +0800
Message-Id: <1200150995.6525.14.camel@Cruella>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2008-01-08二的 07:27 +0100，Matthias Urlichs写道：
> Hi,
> > A lot of google searches reflect that, the latest kernel supporting
> > Huawei EC321 CDMA PCCARD is 2.6.17. My version (2.6.22-14 on Ubuntu)
> > doesn't work.
> > 
> This is probably because ...
> 
> > [ 3804.140000] /build/buildd/linux-source-2.6.22-2.6.22/drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
> 
> ... the card is in fact recognized by the pl2303 driver instead of the
> Option driver. This driver may do something stupid.

I am not sure if it's the case. I just managed to compile a kernel in
Ubuntu myself, and I used the config file of default Ubuntu kernel, only
with a slight twist:

# CONFIG_USB_SERIAL_PL2303 is not set

Using the new kernel, I got:

[  177.916000] ehci_hcd 0000:16:00.2: irq 20, io mem 0x50002000
[  178.016000] usb 6-1: new full speed USB device using ohci_hcd and address 2
[  178.016000] ehci_hcd 0000:16:00.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2
004
[  178.016000] usb usb8: configuration #1 chosen from 1 choice
[  178.016000] hub 8-0:1.0: USB hub found
[  178.016000] hub 8-0:1.0: 2 ports detected
[  178.888000] usb 6-1: new full speed USB device using ohci_hcd and address 3
[  180.120000] usb 6-1: new full speed USB device using ohci_hcd and address 4
[  180.388000] usb 6-1: configuration #1 chosen from 1 choice
[  180.392000] option 6-1:1.0: GSM modem (1-port) converter detected
[  180.392000] usb 6-1: GSM modem (1-port) converter now attached to ttyUSB0
[  180.396000] option 6-1:1.1: GSM modem (1-port) converter detected
[  180.396000] usb 6-1: GSM modem (1-port) converter now attached to ttyUSB1

Also 'lsmod' told me the module 'pl2303' is not loaded. Do the dialing I
got the same problem:

[snip]
WvDial<*1>: Carrier detected.  Waiting for prompt.
WvDial<Err>: Connected, but carrier signal lost!  Retrying...

Later I will try a Ubuntu 6.04 live CD to see if the same hardware works
for 6.04 myself (previous i only read that it worked for 6.04).

