Return-Path: <linux-kernel-owner+w=401wt.eu-S1763926AbYCEI1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763926AbYCEI1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 03:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757894AbYCEI1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 03:27:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47566 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbYCEI1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 03:27:32 -0500
Date: Wed, 5 Mar 2008 09:27:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Diego Woitasen <diego@woitasen.com.ar>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: High resolution timer/dynticks bug
Message-ID: <20080305082731.GA24004@atrey.karlin.mff.cuni.cz>
References: <20080303010753.GB3512@motherbox.xtech.com.ar> <20080304110900.GA23227@elf.ucw.cz> <20080304230032.GA2967@motherbox.xtech.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304230032.GA2967@motherbox.xtech.com.ar>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > > Hi!
> > > 	I have problems when enable dynticks or hrtimers in kernel >=
> > > 	2.6.24. It's easy to reproduce for me, when I enable either,
> > > 	boots the machine, browse the web with Firefox or unplug the
> > > 	power cable (i'm using a notebook) and the kernel freezes. I
> > > 	could get a error message using NMI watchdog and netconsole.
> > > 
> > > 	Please, tell me if you need more information or testing.
> > 
> > 
> > 
> > > NMI Watchdog detected LOCKUP on CPU 0
> > 
> > Just turn off NMI watchdog?
> > 
> > Pulling the power cable causes the SMM trap, which takes _long_ to
> > execute, potentially tickling NMI watchdog?
> 
> The system freezes silently without NMI watchdog :)

Ok... next hint:

> > > CPU 0 
> > > Modules linked in: netconsole configfs fan ebtable_broute bridge llc ebtable_nat ebtable_filter ebtables dm_snapshot dm_mirror dm_mod powernow_k8 loop arc4 snd_hda_intel ecb crypto_blkcipher cryptomgr snd_pcm_oss snd_pcm snd_mixer_oss b43 mac80211 cfg80211 crc32 snd_seq_dummy snd_seq_oss firmware_class snd_seq_midi_event ieee80211softmac snd_seq ieee80211 ieee80211_crypt snd_timer snd_seq_device i2c_nforce2 sdhci rng_core ohci1394 snd i2c_core battery ac thermal processor forcedeth mmc_core psmouse ssb ieee1394 button soundcore snd_page_alloc ehci_hcd ohci_hcd usbcore
> > > Pid: 0, comm: swapper Not tainted 2.6.25-rc3-porti-00081-g7704a8b #18
> > > RIP: 0010:[<ffffffff80220799>]  [<ffffffff80220799>] hpet_readl+0x9/0x10

Is RIP always here? If so, can you pinpoint which part of hpet_readl
causes the problem?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
