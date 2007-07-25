Return-Path: <linux-kernel-owner+w=401wt.eu-S933808AbXGYQv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbXGYQv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764108AbXGYQvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:51:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:41578 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763981AbXGYQvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:51:14 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>
Subject: Re: Time Problems with 2.6.23-rc1-gf695baf2
Date: Wed, 25 Jul 2007 12:50:22 -0400
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070723221630.GA28951@alice> <6bffcb0e0707241614s7b563b5bu114d2ecb227b1557@mail.gmail.com> <20070725113349.GB5469@alice>
In-Reply-To: <20070725113349.GB5469@alice>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707251250.22469.lenb@kernel.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 07:33, Eric Sesterhenn / Snakebyte wrote:
> * Michal Piotrowski (michal.k.k.piotrowski@gmail.com) wrote:
> >  On 24/07/07, Eric Sesterhenn / Snakebyte <snakebyte@gmx.de> wrote:
> > > see second 13 to 510, after pressing it about ten
> > > times, it continues booting.
> > 
> >  Probing IDE interface...
> > 
> >  [   13.867939] VP_IDE: VIA vt82c686a (rev 22) IDE UDMA66 controller on
> >  pci0000:00:04.1
> >  [   13.868062]     ide0: BM-DMA at 0xd800-0xd807, BIOS settings:
> >  hda:DMA, hdb:pio
> >  [   13.868268]     ide1: BM-DMA at 0xd808-0xd80f, BIOS settings:
> >  hdc:DMA, hdd:DMA
> >  [   13.868574] Probing IDE interface ide0...
> >  [  387.279576] Clocksource tsc unstable (delta = 370195339890 ns)
> >  [  496.200082] hda: ST340823A, ATA DISK drive
> >  [  510.264511] hda: selected mode 0x44
> >  [  510.264826] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> > 
> >  Could you please try to revert these commits
> > 
> >  commit 4099d14322149c7a467e4997b87be4ba8eb78697
> >  commit 6a824c92db4d606c324272c4eed366fb71672440
> >  commit a5d8c5c834d3cabf4b7b477c3f6ee923c25026fc
> 
> reverting these commits didnt change anything at all,
> booting with acpi=off resolved the issue, so i guess it is
> an acpi problem after all.

Maybe yes, maybe no.

> > > > [   13.506890] ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
> > > > [   13.507101] ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]

Note that these are just noise -- new code being verbose when looking for an optional feature.

The fact that hitting the power button a bunch of times
to make the system move along suggests some sort of missing interrupt problem --
most likely the timer itself.

[   13.868574] Probing IDE interface ide0...
[  387.279576] Clocksource tsc unstable (delta = 370195339890 ns)

5-minutes -- a long probe:-)

> CONFIG_NO_HZ=y

does CONFIG_NO_HZ=n make a difference?

> CONFIG_HIGH_RES_TIMERS=y

does CONFIG_HIGH_RES_TIMERS=n make a difference?

does "irqpoll" make any difference?
does "notsc" make any difference?
does "idle=poll" make any difference?

cheers,
-Len
