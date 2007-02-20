Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbXBTCsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbXBTCsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 21:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965591AbXBTCsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 21:48:45 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:31527 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806AbXBTCsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 21:48:45 -0500
Date: Mon, 19 Feb 2007 20:48:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Serial related oops
In-reply-to: <fa.IE91N03KQO01UZbOdcF6HewOdYc@ifi.uio.no>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Jose Goncalves <jose.goncalves@inov.pt>,
       Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Message-id: <45DA618B.6040603@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.0IigYYV566ZB0kBHCj88jOEJx1s@ifi.uio.no>
 <fa.IE91N03KQO01UZbOdcF6HewOdYc@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael K. Edwards wrote:
> Still open, though it's a pity you're more interested in my flawed
> understanding that in the possibility that the kernel could be
> systematically made more robust against hardware bugs and coding
> errors by the simple expedient of putting all the ISRs in before
> turning on any IRQ that might be shared.  Or are you telling me that's
> already been done?  (Yes, I am aware that this interacts
> entertainingly with hot-plug PCI.  Yes, I am aware that there is a
> limit to how much software can fix stupid hardware.  But surely there
> is room for an emergency IRQ suppressor to let chip initialization
> code kick in and force the hardware to a known state.)

How do you propose to do this? Drivers can get loaded and unloaded at any
time. If you have a device generating spurious interrupts on a shared IRQ
line, there's no way you can use any device on that line until that interrupt
is shut off. Requiring all drivers to be loaded before any of them can use
interrupts is simply not practical.

If a system has a device that generates interrupts before they're enabled,
and the firmware doesn't fix it, then some platform-specific quirk has to
handle it and shut off the interrupt before it allows any interrupts
to be enabled. (We have such a quirk for certain network controllers where
the boot ROM can leave the chip generating interrupts on bootup.)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

