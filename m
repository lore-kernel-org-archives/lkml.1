Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZI3WD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZI3WD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZI3WD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:03:27 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:60610 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbZI3WD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:03:27 -0400
Message-ID: <4AC3D5B1.3030708@msgid.tls.msk.ru>
Date: Thu, 01 Oct 2009 02:03:29 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: suspend vs usb and PS/2 ports
References: <4AC35F86.20405@msgid.tls.msk.ru> <200909302354.55673.rjw@sisk.pl>
In-Reply-To: <200909302354.55673.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wednesday 30 September 2009, Michael Tokarev wrote:
>> Hello.
>>
>> I've several PCs here which are able to wakeup -
>> among others - from PS/2 and/or USB keyboard.
>> Here for testing I'm using PS/2 keyboard and
>> Asus M3A78-EM motherboard.
>>
>> When I do poweroff from linux, the keyboard
>> stays powered up as it should (according to
>> the BIOS settings).  But when I do suspend,
>> keyboard is NOT powered anymore, and hence
>> the system can't be woken up from it but only
>> by using the power button.
>>
>> This happens consistently for many kernel
>> versions.  To be fair, I don't even know if
>> there was any kernel which does not show this
>> behaviour: old versions was unable to do
>> suspend/resume cycle on this platform at all.
>>
>> Any hints for this please?
> 
> With USB, I think keyboard wake-up is off by default as it causes some
> systems to wake up immediately after suspending.  Alan and Oliver can provide
> more info about that.

Actually I wasn't able to get any machine to resume based on
USB devices - notable keyboard, be it sleep/power button (on
the keyboards that have it) or any other combination of keys
configured in the BIOS.  Most motherboards I tried are from
Asus, one or two from Gigabyte and one more from Biostar.

That's why I use PS/2=>USB adaptor, to connect an USB keyboard
to a PS/2 port - this one works just fine, with all the mobos
I tried (provided the appropriate BIOS settings are turned on
and ever exists, to start with).

> I don't know about PS/2.
> 
> Can you post the contents of /proc/acpi/wakeup from one of these systems,
> please?

Hm.  That's.. curious.  Here we go, my home machine whihc I turn
on every day from a PS/2-connected keyboard:

Device	S-state	  Status   Sysfs node
PCE2	  S4	 disabled
PCE3	  S4	 disabled
PCE4	  S4	 disabled
PCE5	  S4	 disabled
PCE6	  S4	 disabled  pci:0000:00:06.0
RLAN	  S4	 disabled  pci:0000:02:00.0
PCE7	  S4	 disabled
PCE9	  S4	 disabled
PCEA	  S4	 disabled
PCEB	  S4	 disabled
PCEC	  S4	 disabled
SBAZ	  S4	 disabled  pci:0000:00:14.2
PS2K	  S4	 disabled  pnp:00:09
UAR1	  S4	 disabled  pnp:00:0a
P0PC	  S4	 disabled  pci:0000:00:14.4
UHC1	  S4	 disabled  pci:0000:00:12.0
UHC2	  S4	 disabled  pci:0000:00:12.1
UHC3	  S4	 disabled  pci:0000:00:12.2
USB4	  S4	 disabled  pci:0000:00:13.0
UHC5	  S4	 disabled  pci:0000:00:13.1
UHC6	  S4	 disabled  pci:0000:00:13.2
UHC7	  S4	 disabled  pci:0000:00:14.5

It's all disabled!  But I *know* it wakes up
from network and from ps/2 keyboard at least!
In the corresponding BIOS menu almost everything
is enabled (excluding RTC alarm, but including
USB events).  This is an Asus motherboard, M3A-78EM,
with latest BIOS.

Here's another one, Gigabyte's GA-MA74GM-S2H,
which definitely wakes on network:

Device	S-state	  Status   Sysfs node
PCI0	  S5	 disabled  no-bus:pci0000:00
USB0	  S3	 disabled  pci:0000:00:12.0
USB1	  S3	 disabled  pci:0000:00:12.1
USB2	  S3	 disabled  pci:0000:00:12.2
USB3	  S3	 disabled  pci:0000:00:13.0
USB4	  S3	 disabled  pci:0000:00:13.1
USB5	  S3	 disabled  pci:0000:00:13.2
USB6	  S3	 disabled  pci:0000:00:14.5
SBAZ	  S4	 disabled  pci:0000:00:14.2
P2P	  S5	 disabled  pci:0000:00:14.4
PCE2	  S4	 disabled
PCE3	  S4	 disabled
PCE4	  S4	 disabled
PCE5	  S4	 disabled
PCE6	  S4	 disabled  pci:0000:00:06.0
PCE7	  S4	 disabled
PCE8	  S4	 disabled

hmm.  Blaming BIOS, as usual? :)

But even if that's the case, why there's a difference
between "just" power-off and power-off when suspending?

The kernel is 2.6.31 vanilla.

Thanks!

/mjt
