Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0BOGVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:21:11 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:60672 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab0BOGVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:21:09 -0500
Date: Mon, 15 Feb 2010 07:21:05 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
	(2.6.33-rc6/7)
Message-ID: <20100215062105.GA8457@rhlx01.hs-esslingen.de>
References: <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain> <20100208093719.GA15428@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081038430.2811@localhost.localdomain> <20100208194734.GA20316@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002082117210.2811@localhost.localdomain> <alpine.LFD.2.00.1002082139360.2811@localhost.localdomain> <20100208205105.GA16990@rhlx01.hs-esslingen.de> <20100208210219.GA22039@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002091034500.2811@localhost.localdomain> <20100214182758.GA31849@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100214182758.GA31849@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 07:27:58PM +0100, Andreas Mohr wrote:
> Note that after reinstalling old custom kernel packages it does boot properly
> (all recent build tests done using -rc4, and with old package reinstalled
> -rc4 then did boot).

I don't know what happened, but -rc8 does boot on this system,
compiled using 4.4.3-2, _with_ acpi_pm lockup issues gone!
(and cat current_clocksource does work)

I've done (at least...) the following:
- make-kpkg kernel_image kernel_headers
  reduced to kernel_image only
  (a very likely candidate, since the kernel_headers part had been added
  pretty much right before all that awful trouble with acpi_pm and reboots started)
- disabled reportedly overly troublesome lilo.conf large-memory option
  (rerunning lilo did NOT manage to fix old -rc4 image boot, though)
- upgraded a couple unrelated packages

I'll try to get it nailed down some more.



Note that even with a rebooting kernel, vga=ask did manage to show
the menu successfully, and _after_ selection it did reboot, IMMEDIATELY.


BTW,
# ls -l /boot/vmlinu*
-rwxr-xr-x 1 root disk 1158634 2006-02-20 07:50 /boot/vmlinux
-rw-r--r-- 1 root disk 1181225 2006-01-18 10:51 /boot/vmlinuz
-rw-r--r-- 1 root root 1214128 2007-02-28 23:05 /boot/vmlinuz-2.6.20-ck1
-rw-r--r-- 1 root root 1703984 2010-01-07 23:38 /boot/vmlinuz-2.6.32.3
-rw-r--r-- 1 root root 1715232 2010-02-12 01:44 /boot/vmlinuz-2.6.33-rc4
-rw-r--r-- 1 root root 1761616 2010-02-09 00:44 /boot/vmlinuz-2.6.33-rc5
-rw-r--r-- 1 root root 1820704 2010-01-31 23:58 /boot/vmlinuz-2.6.33-rc6
-rw-r--r-- 1 root root 1762240 2010-02-07 23:15 /boot/vmlinuz-2.6.33-rc7
-rw-r--r-- 1 root root 1716080 2010-02-15 00:51 /boot/vmlinuz-2.6.33-rc8

One might be tempted to point at a possible boot loader image size issue,
but then working -rc8 is even a bit bigger than non-booting -rc4.

Andreas Mohr
