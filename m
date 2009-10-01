Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbZJAOZC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbZJAOZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:25:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932649AbZJAOZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:25:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:16709 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbZJAOZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:25:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=dYO01aoP154vc4W4HR3mXA9uCOqjx1segB3ZB9cRlQGNR69OUpp8gadzdBJlcLvsMV
         xJ0N/XwcdtPm0CrsWF9AgPLfe2OZ/P7odQXo3udejqV6qO7wD8fIETqvx+BcvSs8uE28
         qBzqdWlvNsH+dK0zVV5t64fOyEmIBjs2RbFvE=
MIME-Version: 1.0
Date: Thu, 1 Oct 2009 16:25:03 +0200
Message-ID: <c4985c940910010725j6971b11aobb35b778f9c4c1eb@mail.gmail.com>
Subject: realtek rtl8185 freezes kernel
From: rosenfield.albert@gmail.com
To: linux-kernel@vger.kernel.org, wlanfae@realtek.com
Cc: bzolnier@gmail.com, a.beregalov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm a pretty ordinary user trying to get wifi on Linux to work.
I've had problems with it not working before, so this time I had a
moderately tech-savvy friend help me pick out something that should
work:

Go to Wikipedia's list of FOSS-friendly hardware:
http://en.wikipedia.org/wiki/Comparison_of_open_source_wireless_drivers

Find these popular chipsets:
 - Intel
 - Broadcom
 - Ralink

disliked by the FOSS community due to either a binary blob (first two)
or some unmentioned code dispute (the last one).

Leaving the following mass produced chipsets:
 - Atheros
 - Realtek

I couldn't find an Atheros anywhere, so I went with a Realtek RTL8185
PCI Wireless card.

Stuck it in the machine, and the Linux kernel promptly froze on startup.
No message or screen-of-death or anything, just a complete freeze.

At this point, my moderately tech-savvy compadre gave up and I called
in a hardware guru.

He first checked the BIOS, and moved the card to another slot so that
it is the only one on it's IRQ.
System still freezes on startup.

Then he booted the system in recovery/console mode.  This time it didn't freeze.
But as soon as "ifconfig wlan0 up" was entered on the console, the
system froze up again!

At this point, he gave up too. I found a hacker to help me out from here.

He checked the kernel mailing list for recent changes to the rtl8180
driver, and found something related to netdev_ops.  Reverted to a
2.6.28 kernel and tried again.
But the system still freezes on "ifconfig wlan0 up".

Then he went to RealTek and got their open source driver.  It doesn't
work out of the box, because it doesn't compile against kernel GIT
HEAD due to the netdev_ops change mentioned above.  So he hacked at it
a bit finally got it to compile.

With the mainline driver removed, and the RealTek driver installed,
"ifconfig wlan0 up" does not crash the system anymore!
However, "ifconfig wlan0" shows that:

wlan0     Link encap:Ethernet  HWaddr 00:18:e7:62:69:f0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:238 dropped:36 overruns:0 frame:0
          TX packets:1124 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:47208 (47.2 KB)
          Interrupt:21 Memory:f7f2a000-f7f2a100

Transmit seems to work, but all received packets either go into
"error" or "dropped".
Similarly, "iwlist wlan0 scan" doesn't show any of the wireless networks.

Wondering if it was something we did, we reverted to 2.6.28 where the
RealTek supplied open source driver compiles out of the box.
Same result.  The driver won't receive anything.

So at this point he's given up too, and now I'm involving you guys.

Is there anyone from RealTek here?  Could you please fix your r8180
driver so that it
 a) compiles against mainline
 b) can receive data

Is there someone who knows how the mainline realtek driver works?
Could you please fix it so that:
 a) it doesn't freeze the system on "ifconfig wlan0 up"

Either or both would be very helpful!

If someone wants to help but needs hardware or a log from my setup, we
can probably figure something out.  Let me know.

Personal suggestions (hardware or software or whatever) are very welcome too!

Here are various hardware information from the driver:
 rtl8180: MAC controller is a RTL8185 b/g (V. D)
 rtl8180: This is a CARDBUS NIC
 rtl8180: Reported EEPROM chip is a 93c56 (2Kbit)
 rtl8180: EEPROM version 105
 rtl8180: Card reports RF frontend Realtek 8225
 rtl8180: This seems a new V2 radio
 rtl8180: Energy threshold: b
 rtl8180: PAPE from CONFIG2: 6

Help, please...

--
Q: How many people does it approximately take to buy and install a
wireless networking card under Linux?
A: 5 and counting :-)
