Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbYA0SIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbYA0SIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYA0SIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:08:06 -0500
Received: from ppp-110-234.adsl.restena.lu ([158.64.110.234]:54950 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750997AbYA0SIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:08:04 -0500
X-Greylist: delayed 1520 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 13:08:04 EST
From: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Troubles waking up from suspend (S3) - how to debug?
Date: Sun, 27 Jan 2008 18:42:37 +0100
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801271842.38007.bonbons@linux-vserver.org>
X-VirusProbe: ClamAV, clean
X-SpamProbe: GOOD 0.0000021 808e1c41e0a733fb74d881596433c034
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm currently trying out suspend (S3) on a few machines but none of them wakes 
up completely/properly (I have a few more hosts I'm planning to try suspend 
on once I can get useful information out of those not waking up properly).

Tested kernels: 2.6.24(-rc8), on one 2.6.23.8

To suspend I enter the following from console:
  echo -n mem > /sys/power/state


Fujitsu-Siemens S7020 laptop (i915GM based):
  Works fine except backlight that remains asleep and Xorg vesa driver
  crashing Xorg.
  It looks like a suspend cycle discards the VideoBIOS shadow copy.
  Adjusting brightness using hotkeys or acpi-fujitsusiemens does not help
  waking up the backlight.
  At best backlight comes back when suspending from Xorg with
  xf86-video-intel-2.2.x but then mode is distorded. Any attempt to fix this
  using xrandr or switch to/from console puts backlight asleep.


Acer Travelmate 660 laptop (i855GM based):
  Laptop suspends as expected but hangs while waking up.


Desktop with MSI nforce based mainboard with Athlon CPU, onboard graphics and 
hdd on HighPoint RR1640 PCI card (USB mouse & keyboard):
  Suspends as expected but hangs while waking up.
  During wakeup I can ping the computer but userspace does not respond (e.g.
  no answer when trying to connect via ssh)
  The display remains off if using vga text console, display comes back with
  garbadge when using nvidiafb (no Xorg running), USB is powered but triggers
  no reactions on keyboard/mouse input


I tried using netconsole on the desktop computer to capture eventual printks 
during resume but I got not a line during wakup. (only suspend progress 
messages before actual suspend)

What can I do to get more information out of those two last machines and find 
out why they don't wake-up properly?


I can provide more details on each of those machines if it can help (lspci, 
kernel config, peripherials, acpidump)

Regards,
Bruno

