Return-Path: <linux-kernel-owner+w=401wt.eu-S1765003AbXHWQLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765003AbXHWQLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 12:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764057AbXHWQL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 12:11:28 -0400
Received: from alnrmhc12.comcast.net ([204.127.225.92]:61637 "EHLO
	alnrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764053AbXHWQL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 12:11:27 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2007 12:11:27 EDT
Date: Thu, 23 Aug 2007 09:06:24 -0700
From: Andrew Burgess <aab@cichlid.com>
Message-Id: <200708231606.l7NG6OPX017001@cichlid.com>
To: linux1394-devel@lists.sourceforge.net
Subject: Firewire lockup on 2.6.22.3 in SMP but not UP, old drivers
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I can pull video via firewire from a set top box using
test_mpeg2 for hours (97GB is my current record) if using a
UP kernel. The machine locks hard after about 500MB using an
SMP kernel. No messages, no altsysreq keys.  It seems to
lock faster if I make the machine busy (disk and cpu). One
time it locked up running firewire_tester and once when I
switched cables between cable tv set top boxes (I think
while test_mpeg2 was running)

kernel 2.6.22.3 x86_64. I enabled all the mutex debug stuff
that I could find and turned on the NMI softlock detection
stuff. Nada. I tried the driver debug stuff but that seems
more for development (tracing).

I did not try a serial console to catch any messages that
cannot make it through syslog.

The hardware is ASUS A8V Deluxe:

  00:07.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 80)

Google shows this to be common although there are two other
chip versions out there.

The PC is about two years old, runs alot of stuff (server,
compiles, etc) and runs fine SMP until I touch firewire.

I have ordered a PCI firewire card to eliminate that part of
the hardware. Its also a VIA chipset.

If that doesn't help, does that make it seem like a driver
issue? (The UP vs SMP seems an odd symptom for hardware) If
so, what's the best way to proceed? Debug old drivers or
switch to new ones?  I have decades of C experience but know
nothing of 1394.

I want to use firewire with mythtv. Libs used by myth:

  athlon:aab > ldd /usr/bin/myth*|grep 1394|sort|uniq
  libavc1394.so.0 => /usr/lib64/libavc1394.so.0 (0x0000003141200000)
  libraw1394.so.8 => /usr/lib64/libraw1394.so.8 (0x000000313f600000)
  librom1394.so.0 => /usr/lib64/librom1394.so.0 (0x0000003140600000)

How close are these libraries to working with a set top box
with the new drivers?

Any quick hacks come to mind? Wrap the existing drivers in
the big kernel lock just to see if that gets things to work?
(that probably makes it obvious that I'm a kernel newbie :-)

I'll cc lkml for any general debug hints.

Thanks for any help
Andrew
