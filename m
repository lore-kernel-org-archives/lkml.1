Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYBAKrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYBAKrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbYBAKrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:47:17 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55626 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbYBAKrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:47:15 -0500
Date: Fri, 1 Feb 2008 11:47:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Are Section mismatches out of control?
Message-ID: <20080201104718.GA11717@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James said in a related posting that the Section mismatch
warnings were getting out of control.

So I decided to take a closer look at current
status. Latest mainline with Adrian + mine fixes applied.

Target was x86 - an allyesconfig build.
I looked at the reported Section mismatch warnings per
directory so see where it was looking bad.

The list is here:


Directory         Warnings
================= ========
block/             0
fs/                0
init/              0
lib/               0
net/               2
sound/             3
crypto/            0
ipc/               0
kernel/            0
mm/                0
usr/               0
security/          0
drivers/net/      11
drivers/ata/       2
drivers/base/      0
drivers/block/     0
drivers/cdrom/     0
drivers/crypto/    0
drivers/hid/       0
drivers/input/     0
drivers/lguest/    0
drivers/leds/      0
drivers/media/     0
drivers/pci/       0
drivers/pcmcia/    9
drivers/power/     0
drivers/ps3/       0
drivers/rtc/       1
drivers/scsi/      3
drivers/isdn/     34
drivers/serial/   10
drivers/spi/       0
drivers/usb/       0
drivers/video/    14
drivers/telephony/ 0
drivers/watchdog/  0
drivers/w1/        0
drivers/dca        0
drivers/edac/      0
drivers/acpi/      2
drivers/char/      3
drivers/cpufreq    3
drivers/hwmon/     1
drivers/infiniband/ 0
drivers/md         0
drivers/message/   0
drivers/misc/      0
drivers/mmc/       0
drivers/mtd/       0
drivers/parport/   0
drivers/pnp/       0

As expected the majority is in drivers/
And as is obvious from the above the warnings are
concentrated on a few places:
drivers/isdn/ has the top score.
Then we have video/, net/ serial/ and pcmia.

With thos four directories clean we are down with
78 less warnings.

The total figure for this build is 106 warnings.
In my book things are not out of control.
So stop complaining and lets see some fixes.

I will look at drivers/isdn as next step.

	Sam
