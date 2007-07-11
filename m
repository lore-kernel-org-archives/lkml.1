Return-Path: <linux-kernel-owner+w=401wt.eu-S1763306AbXGKL31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763306AbXGKL31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762226AbXGKL3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:29:11 -0400
Received: from mail-1.epublica.de ([213.238.59.6]:44908 "EHLO
	mail-1.epublica.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761881AbXGKL3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:29:10 -0400
Message-ID: <4694BF03.5070508@hanno.de>
Date: Wed, 11 Jul 2007 13:29:07 +0200
From: Hanno Zulla <abos@hanno.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Slow IRQ handling? (was: Nova-T, cx88-dvb & "cx88_wakeup: 2 buffers
 handled (should be 1)")
References: <4693C318.8040105@hanno.de> <46949AFD.5030101@redhat.com>
In-Reply-To: <46949AFD.5030101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[ please cc me. Thanks. ]

> I've added the printk some years ago.  I stopped maintaining v4l/dvb
> bits two years ago, so it's a bit a shot into the dark because I have no
> idea what has changed recently in the driver.

Indeed, it appears that this driver has no maintainer right now. (Or the
maintainer is on holidays. I had no luck finding an active maintainer
via the linux-dvb mailing list or via email in the past weeks).

> The message is in no way critical, the driver should cope just fine with
> the situation, and as usually some more buffers are queued for dma it
> also doesn't imply dvb stream data got lost.  It seems in your case some
> data actually got lost though, otherwise the effect wouldn't be visible.
>
> Background:  The card raises an interrupt for each filled buffer, so in
> theory each time the irq handler runs it should handle a single buffer.
>  If it is more than one it means the irq handler wasn't called in time
> or wasn't called at all for some reason.

Thanks for clarifying this.

> Could be someone in the kernel blocked interrupts for a insane long
> time, so the hardware managed to fill the one more buffer before the irq
> handler was actually called.  Could be IRQ handling in the cx88 driver
> is screwed.  Could be a scheduling issue (Is this a core2 duo?  If so
> check the longish discussion on about that here in lkml, subject "long
> freezes on thinkpad t60").

Yes, it is a Core2Duo with an Intel chipset.

http://launchpadlibrarian.net/8283450/cpuinfo

However, a user with a single-core AMD cpu and a VIA chipset reports the
same problem.

http://launchpadlibrarian.net/8283450/cpuinfo

See
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/119115
for more info.

> Could also be the irq handler for the other device sharing the same irq
> being very slow.  Any pattern here that it is linked to some specific
> device sharing the irq?

No idea, I did not see any pattern here. Also, the problem on my system
appears with every PCI slot I tried.

What do you suggest? How can I debug this issue so that you kernel guys
can look into it?

Thanks,

Hanno
