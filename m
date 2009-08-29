Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbZH2VCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbZH2VCn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 17:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZH2VCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 17:02:42 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:59868 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbZH2VCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 17:02:41 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Bart Hartgers <bart.hartgers@gmail.com>
Subject: Re: New ark3116 driver - testers needed
Date: Sat, 29 Aug 2009 23:02:31 +0200
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, ark3116_driver@auctionant.de,
       linux-kernel@vger.kernel.org
References: <7eb6a4d80908230546tc246dbdq33ffadcdce9a605a@mail.gmail.com>
In-Reply-To: <7eb6a4d80908230546tc246dbdq33ffadcdce9a605a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908292302.34282.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 August 2009 14:46:16 Bart Hartgers wrote:
> Hi All,
>
> I managed to write an improved ark3116 driver after I figured out that
> it is just an 16450 UART with some USB glue logic.
>
> Compared to the old ark3116 driver it offers the following improvements:
> - cts/rts handshake support
> - break signalling
> - line error detection
>
> Since it is a big step from the previous driver, it made little sense
> to modify that one, so I created new driver, named ark316new. Also
> this means that both could coexist if the new one doesn't work for
> someone.
>
> I have no datasheet, so the driver is entirely based on reverse
> engineering, and some testing by others would be a good idea.
>
> I also tried to include the IrDA fixes for the old ark3116.c driver
> that were posted on this list recently, but I could not test if
> these work, since I don't have the proper hardware.
>
> Because of this, I would appreciate reports of both success and
> failure in using this driver.

Tested the driver today with that Gembird UIR-22.

It did not compile neither in 2.6.30.1 nor in 2.6.31-rc8 with the following 
error:

ark3116new.c:790: error: unknown field shutdown specified in initializer
ark3116new/ark3116new.c:790: warning: initialization from incompatible pointer 
type

Commenting that line produced a module that worked:
usb 1-1: new full speed USB device using uhci_hcd and address 2
usb 1-1: configuration #0 chosen from 1 choice
usb 1-1: config 0 descriptor??
usbcore: registered new interface driver usbserial
usbserial: USB Serial Driver core
USB Serial support registered for ARK3116 RS232/IrDA
ark3116new 1-1:0.0: ARK3116 RS232/IrDA converter detected
usb 1-1: ark3116new using IrDA mode
usb 1-1: ARK3116 RS232/IrDA converter now attached to ttyUSB0
usbcore: registered new interface driver ark3116new
ark3116new:v0.1:USB ARK3116 serial/IrDA driver
usb 1-1: ark3116new don't know how to do software flow control
NET: Registered protocol family 23

Ran "irattach /dev/ttyUSB0 -s" and then "obexftp -i -l" to list files on Nokia 
6230i. It worked fine and file transfer too. So the IrDA mode works.

When I unplugged the device, irattach remained running and some error message 
was written to console every few seconds (sorry, I haven't recorded it). 
Killing irattach then resulted in oops. But this might be expected as the 
shutdown function was commented out.

I think that this driver should replace current ark3116 driver. Having two 
drivers for the same hardware is a bad thing.

-- 
Ondrej Zary
