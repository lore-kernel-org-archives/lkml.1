Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbXBWGYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbXBWGYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 01:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXBWGYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 01:24:22 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:52535 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbXBWGYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 01:24:21 -0500
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200702230624.l1N6OI9a017864@turbo.physics.adelaide.edu.au>
Subject: Transparent bridges, assign_busses and poweroff/tsc problems
To: linux-kernel@vger.kernel.org
Date: Fri, 23 Feb 2007 16:54:18 +1030 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe)
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I have previously posted regarding a message about a transparent
bridge message I get when booting my laptop.

  PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
  PCI quirk: region 1180-11bf claimed by ICH6 GPIO
  PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
  PCI: Transparent bridge - 0000:00:1e.0
  PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#07) (try
  'pci=assign-busses')
  Please report the result to linux-kernel to fix this permanently

There doesn't appear to be any ill-effects from this, but a permanent
fix is probably a good thing and so I'm reporting it.

I have however tried "pci=assign-busses" as suggested.  While this does
make the above complaint go away, it introduces two other things, one
a lot more serious.

The first thing I've noticed is that when "pci=assign-busses" has been
specified, I get the following in the dmesg:

  Clocksource tsc unstable (delta = -434140355 ns)

I don't seem to get this if assignbusses hasn't been given.

The second effect of "pci=assign-busses" is that it prevents Linux powering
the laptop off; pressing the power button triggers an ACPI event as it
should and Linux proceeds to close everything down.  However, when it comes
time to actually kill the power the screen goes blank and the backlight
gets turned off, but power remains on until I force it off by holding the
power button down for 4 seconds.

I have verified this with 2.6.18, 2.6.19 and 2.6.20.  Furthermore, the RT
patchset does not change the behaviour.

Something mighty odd seems to be going on here.  Does anyone have any ideas
or suggestions of things to try?

Regards
  jonathan
