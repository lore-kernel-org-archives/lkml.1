Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbXGHAYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbXGHAYZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 20:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXGHAYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 20:24:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:46610 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752683AbXGHAYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 20:24:16 -0400
X-Authenticated: #27760234
X-Provags-ID: V01U2FsdGVkX18yvBwj5fAyOICtvTtHb7PQRD5IrTD9QxO/XkGZdq
	qavYQWKI1E2iXV
Date: Sun, 8 Jul 2007 02:24:12 +0200
From: Richard Mittendorfer <delist@gmx.net>
To: "Tim Hull" <thully@umich.edu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: MacBook makes whining noise when usb-uhci active
Message-Id: <20070708022412.564ceceb.delist@gmx.net>
In-Reply-To: <9a7c669e0707071645x69fef279q22cb8473c1f56e5b@mail.gmail.com>
References: <9a7c669e0707071551v2705320dn876ad208fa60a537@mail.gmail.com>
	<9a7c669e0707071554wcd74b59j94464c60f32f7ddd@mail.gmail.com>
	<9a7c669e0707071645x69fef279q22cb8473c1f56e5b@mail.gmail.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also sprach "Tim Hull" <thully@umich.edu> (Sat, 7 Jul 2007 19:45:48 -0400):
> [1.] One line summary of the problem: MacBook makes whining noise when
> usb-uhci loaded.
> [2.] Full description of the problem/report: On my MacBook (first
> generation Core Duo 1.83GHz), I can hear a faint whining noise that
> becomes audible when usb-uhci is loaded and remains audible except
> when the USB ports are in use ( i.e. the noise temporarily stops when
> I'm copying music to my iPod).  This problem occurs on both 2.6.21
> and 2.6.22-rc7, but does not occur on 2.6.18.  Unloading usb-uhci when
> booted in 2.6.22-rc7 makes the whining noise stop, but the system is
> useless in this state for obvious reasons.
> [...]
> [4.2.] Kernel .config file:
> [...]
> CONFIG_NO_HZ=y
> [...]
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> CONFIG_HZ_1000=y
> CONFIG_HZ=1000
> [...]
> CONFIG_X86_ACPI_CPUFREQ=y
> [...]

This sounds like a known problem w/ some laptops. Maybe powersupply,
noisy onboard conductors at 1000Hz, entering processor P-states and
I've heard about it in context with USB too, IIRC....

As you have tickless timer enabled, CONFIG_HZ shouldn't trigger it, but
you can check this with '$ vmstat 1' and watch the in(terrupts) field.
They should be quite low.

To disable P-states follow the instructions on the link below.

As you have set CONFIG_USB_SUSPEND and it's noisy only when nothing
is connected, unsetting it might be worth a try. But, AFAIK, 2.6.18
already had this feature?

Here's a link to a thinkpad related site talking about it:
http://www.thinkwiki.org/wiki/Problem_with_high_pitch_noises

Looks like there are quite some different reasons causing it.

HTH & good luck,
ritch
