Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbXGVNTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbXGVNTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 09:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbXGVNTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 09:19:08 -0400
Received: from tim.rpsys.net ([194.106.48.114]:47946 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbXGVNTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 09:19:06 -0400
Subject: Re: MMC/SD Root filesystem suspend/resume problems
From: Richard Purdie <rpurdie@rpsys.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070719190309.28708be8@poseidon.drzeus.cx>
References: <1184860419.29634.10.camel@localhost.localdomain>
	 <20070719190309.28708be8@poseidon.drzeus.cx>
Content-Type: text/plain
Date: Sun, 22 Jul 2007 14:18:33 +0100
Message-Id: <1185110313.6819.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 19:03 +0200, Pierre Ossman wrote:
> On Thu, 19 Jul 2007 16:53:39 +0100
> Richard Purdie <rpurdie@rpsys.net> wrote:
> > Lots of Linux handhelds use MMC/SD devices as the root file system.
> > This has worked quite reliably for many kernel versions. In 2.6.22,
> > it seems that if you suspend such a system then resume it, the device
> > locks up. Trying to execute anything on the filesystem results in a
> > "Permission Denied" message. I did see a message from the MMC
> > subsystem saying it had redetected the card. There are also messages
> > on the console like "MMC: killing requests for dead queue" each time
> > you suspend/resume.
> 
> The card is removed when you suspend and readded when you resume.
> That's the only safe thing we can do until we get suspend support in
> the filesystems.
> 
> If you really want to shoot yourself in the foot, there is a Kconfig
> option that keeps the card around across the suspend.

I enabled the MMC_UNSAFE_RESUME option and the problems I was seeing was
"fixed". I think having this option is a bad idea (in its current form)
as it doesn't actually stop filesystem corruption.

With the option disabled, if a filesystem is mounted when you suspend my
tests show the filesystem is corrupted. At least if the option is
enabled, the filesystem is only corrupted if you remove the card whilst
suspended which is more preferable.

I guess the solution would be to abort the suspend if mounted systems
were detected and the option was disabled? Alternatively the option
could be "auto" enabled only for mounted systems maybe with a printk
warning?

Of course the best solution would be to have filesystems support
suspend/resume requests since other subsystems like pcmcia also suffer
this problem and would benefit from this but I accept that teaching
filesystems this is more difficult.

Regards,

Richard


