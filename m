Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbYA1Ceh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbYA1Ceh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 21:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYA1Ce3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 21:34:29 -0500
Received: from mail.fuw.edu.pl ([193.0.80.14]:35663 "EHLO mail.fuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbYA1Ce1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 21:34:27 -0500
X-Greylist: delayed 3190 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 21:34:27 EST
From: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Organization: FUW
To: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: Re: Troubles waking up from suspend (S3) - how to debug?
Date: Mon, 28 Jan 2008 02:39:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200801271842.38007.bonbons@linux-vserver.org>
In-Reply-To: <200801271842.38007.bonbons@linux-vserver.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801280239.11581.Rafal.Wysocki@fuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 27 of January 2008, Bruno Prémont wrote:
> I'm currently trying out suspend (S3) on a few machines but none of them wakes 
> up completely/properly (I have a few more hosts I'm planning to try suspend 
> on once I can get useful information out of those not waking up properly).
> 
> Tested kernels: 2.6.24(-rc8), on one 2.6.23.8
> 
> To suspend I enter the following from console:
>   echo -n mem > /sys/power/state
> 

Please try s2ram (http://suspend.sf.net/s2ram-support.html).

> Fujitsu-Siemens S7020 laptop (i915GM based):
>   Works fine except backlight that remains asleep and Xorg vesa driver
>   crashing Xorg.
>   It looks like a suspend cycle discards the VideoBIOS shadow copy.
>   Adjusting brightness using hotkeys or acpi-fujitsusiemens does not help
>   waking up the backlight.
>   At best backlight comes back when suspending from Xorg with
>   xf86-video-intel-2.2.x but then mode is distorded. Any attempt to fix this
>   using xrandr or switch to/from console puts backlight asleep.

This one is on the s2ram whitelist, should work.

> Acer Travelmate 660 laptop (i855GM based):
>   Laptop suspends as expected but hangs while waking up.

This might work with "s2ram -f --vbe_post --vbe_save", please try.
 
> Desktop with MSI nforce based mainboard with Athlon CPU, onboard graphics

What kind?

> and hdd on HighPoint RR1640 PCI card (USB mouse & keyboard):
>   Suspends as expected but hangs while waking up.
>   During wakeup I can ping the computer but userspace does not respond (e.g.
>   no answer when trying to connect via ssh)
>   The display remains off if using vga text console, display comes back with
>   garbadge when using nvidiafb (no Xorg running), USB is powered but triggers
>   no reactions on keyboard/mouse input
> 
> 
> I tried using netconsole on the desktop computer to capture eventual printks 
> during resume but I got not a line during wakup. (only suspend progress 
> messages before actual suspend)
> 
> What can I do to get more information out of those two last machines and find 
> out why they don't wake-up properly?

Please apply the patches 01-11 from:
http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.24/patches/
on top of 2.6.24, compile the kernel and install it.  After booting, please do:

# echo core > /sys/power/pm_test
# echo mem > /sys/power/state

and see if the boxes survive it (this causes the suspend/resume sequence to
be executed without acutally suspending, but busy-waiting for 5 sec. instead).

Greetings,
Rafael
