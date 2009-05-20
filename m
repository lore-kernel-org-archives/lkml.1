Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbZETFrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbZETFrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 01:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZETFrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 01:47:41 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:56949 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZETFrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 01:47:41 -0400
Date: Wed, 20 May 2009 06:47:39 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, mingo@elte.hu
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Message-ID: <20090520054739.GA31552@sucs.org>
References: <20090511072135.GA4682@sucs.org> <20090513032053.GA29919@dtor-d630.eng.vmware.com> <20090513185356.GA20140@sucs.org> <20090513191953.GA10629@sucs.org> <20090516032754.GC12099@dtor-d630.eng.vmware.com> <20090516032924.GD12099@dtor-d630.eng.vmware.com> <20090518084146.GA25806@sucs.org> <20090518094209.GA21150@sucs.org> <20090520024658.GD17649@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520024658.GD17649@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 07:47:08PM -0700, Dmitry Torokhov wrote:
> 
> It is just unfortunate scheduling that messes us up:

The really frustrating thing is that for a time this was happening quite
consistently leading me to believe it was a kernel issue...

> > [    4.267050] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [113]
> > [    4.270440] drivers/input/serio/i8042.c: d4 -> i8042 (command) [116]
> > [    4.271016] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [116]
> > [    4.274883] ALSA device list:
> > [    4.274963]   #0: HDA Intel at 0xf7eb8000 irq 16
> > [    4.275258] TCP cubic registered
> > [    4.276597] NET: Registered protocol family 17
> > [    4.276802] Using IPI Shortcut mode
> > [    4.279191]   Magic number: 9:810:70
> > [    4.279548] rtc_cmos 00:03: setting system clock to 2009-05-18 09:03:27 UTC (1242637407)
> > [    4.281412] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [127]
> > [    4.283338] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [129]
> > [    5.406620] libps2: errorneously fail 754 command
> 
> As you can see the device responded to our command and interrupt fired
> at 4.28 but for some reason the thread did not get woken up until 5.40,
> second and a half later... Crazy if you ask me.

It's worth noting that this kernel is stuffed full of debugging options
as is running on an EeePC 900 with 900Mhz Celeron. I am also using the
following boot parameters:

root=/dev/sdb2 cfg80211.ieee80211_regdom=GB usb_storage.delay_use=0
cfg80211 pcie_aspm=force pcie_aspm.policy=powersave fastboot ro
rootfstype=ext2

> In the meantime, the patch below should fix work around that delay.

This one could be tough to test unless there is a way of forcing the
awkward scheduling...

-- 
Sitsofe | http://sucs.org/~sits/
