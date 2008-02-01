Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYBAOxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYBAOxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 09:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYBAOxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 09:53:33 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40132 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754609AbYBAOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 09:53:31 -0500
Subject: Re: Are Section mismatches out of control?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080201104718.GA11717@uranus.ravnborg.org>
References: <20080201104718.GA11717@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 08:53:25 -0600
Message-Id: <1201877605.3134.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-01 at 11:47 +0100, Sam Ravnborg wrote:
> James said in a related posting that the Section mismatch
> warnings were getting out of control.

What I actually said was that the churn in the source base caused by
these sectional mismatches was getting out of hand.

What I questioned was the value of inspecting all the drivers and trying
to fix them all (and the effort involved) vs my proposed solution of
simply making 90% of them go away.

> So I decided to take a closer look at current
> status. Latest mainline with Adrian + mine fixes applied.
> 
> Target was x86 - an allyesconfig build.
> I looked at the reported Section mismatch warnings per
> directory so see where it was looking bad.
> 
> The list is here:
> 
> 
> Directory         Warnings
> ================= ========
> block/             0
> fs/                0
> init/              0
> lib/               0
> net/               2
> sound/             3
> crypto/            0
> ipc/               0
> kernel/            0
> mm/                0
> usr/               0
> security/          0
> drivers/net/      11
> drivers/ata/       2
> drivers/base/      0
> drivers/block/     0
> drivers/cdrom/     0
> drivers/crypto/    0
> drivers/hid/       0
> drivers/input/     0
> drivers/lguest/    0
> drivers/leds/      0
> drivers/media/     0
> drivers/pci/       0
> drivers/pcmcia/    9
> drivers/power/     0
> drivers/ps3/       0
> drivers/rtc/       1
> drivers/scsi/      3
> drivers/isdn/     34
> drivers/serial/   10
> drivers/spi/       0
> drivers/usb/       0
> drivers/video/    14
> drivers/telephony/ 0
> drivers/watchdog/  0
> drivers/w1/        0
> drivers/dca        0
> drivers/edac/      0
> drivers/acpi/      2
> drivers/char/      3
> drivers/cpufreq    3
> drivers/hwmon/     1
> drivers/infiniband/ 0
> drivers/md         0
> drivers/message/   0
> drivers/misc/      0
> drivers/mmc/       0
> drivers/mtd/       0
> drivers/parport/   0
> drivers/pnp/       0
> 
> As expected the majority is in drivers/
> And as is obvious from the above the warnings are
> concentrated on a few places:
> drivers/isdn/ has the top score.
> Then we have video/, net/ serial/ and pcmia.
> 
> With thos four directories clean we are down with
> 78 less warnings.
> 
> The total figure for this build is 106 warnings.
> In my book things are not out of control.
> So stop complaining and lets see some fixes.
> 
> I will look at drivers/isdn as next step.

But on your own estimate, that's around 50 patches to fix all of this,
isn't it?  Which all have to be inspected, tested and integrated.  Is
that really a worthwhile exercise for saving 5k of memory (also from
your own estimate).  Particularly as the people who care about extreme
memory configurations aren't going "goody sections saved us 5k", they're
going "&^*&^ me the kernel increased in size by 150k on my system from
2.6.15 to 2.6.24". 

James


