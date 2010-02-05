Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab0BEQUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 11:20:19 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49643 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab0BEQUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 11:20:16 -0500
From: "Madhusudhan" <madhu.cr@ti.com>
To: "'Maxim Levitsky'" <maximlevitsky@gmail.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: <linux-mmc@vger.kernel.org>, "'Philip Langdale'" <philipl@overt.org>,
       "'linux-kernel'" <linux-kernel@vger.kernel.org>,
       "'Jorg Schummer'" <ext-jorg.2.schummer@nokia.com>,
       "'linux-pm'" <linux-pm@lists.linux-foundation.org>
References: <1265219241.12549.8.camel@maxim-laptop> <1265325495-4220-1-git-send-email-maximlevitsky@gmail.com> <20100204160957.1c51cc1b.akpm@linux-foundation.org> <1265358702.3424.8.camel@maxim-laptop> <20100205061335.b664aa20.akpm@linux-foundation.org> <1265379560.14522.2.camel@maxim-laptop> <20100205063911.05eca1c6.akpm@linux-foundation.org> <1265385120.16817.6.camel@maxim-laptop>
Subject: RE: [PATCH] MMC: fix hang if card was removed during suspend and unsafe resume was enabled
Date: Fri, 5 Feb 2010 10:19:54 -0600
Message-ID: <002501caa67f$0d8ef310$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acqme1T0nsGLzhxjSVGz2ZM2o2xlpAAAwYfw
In-Reply-To: <1265385120.16817.6.camel@maxim-laptop>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
> owner@vger.kernel.org] On Behalf Of Maxim Levitsky
> Sent: Friday, February 05, 2010 9:52 AM
> To: Andrew Morton
> Cc: linux-mmc@vger.kernel.org; Philip Langdale; linux-kernel; Jorg
> Schummer; linux-pm
> Subject: Re: [PATCH] MMC: fix hang if card was removed during suspend and
> unsafe resume was enabled
> 
> On Fri, 2010-02-05 at 06:39 -0800, Andrew Morton wrote:
> > On Fri, 05 Feb 2010 16:19:20 +0200 Maxim Levitsky
> <maximlevitsky@gmail.com> wrote:
> >
> > > >
> > > > There is no del_disk in the kernel.  Let's be more specific (and
> > > > accurate!) about the hang.  I assume it's
> > > > mmc_remove_card->device_del->kobject_uevent?
> > > Sorry!
> > > I was referring to del_gendisk.
> > >
> > > <4>[15241.042047]  [<ffffffff8106620a>] ? prepare_to_wait+0x2a/0x90
> > > <4>[15241.042159]  [<ffffffff810790bd>] ? trace_hardirqs_on+0xd/0x10
> > > <4>[15241.042271]  [<ffffffff8140db12>] ?
> _raw_spin_unlock_irqrestore+0x42/0x80
> > > <4>[15241.042386]  [<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
> > > <4>[15241.042496]  [<ffffffff8112a39e>] bdi_sched_wait+0xe/0x20
> > > <4>[15241.042606]  [<ffffffff8140af6f>] __wait_on_bit+0x5f/0x90
> > > <4>[15241.042714]  [<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
> > > <4>[15241.042824]  [<ffffffff8140b018>]
> out_of_line_wait_on_bit+0x78/0x90
> > > <4>[15241.042935]  [<ffffffff81065fd0>] ? wake_bit_function+0x0/0x40
> > > <4>[15241.043045]  [<ffffffff8112a2d3>] ? bdi_queue_work+0xa3/0xe0
> > > <4>[15241.043155]  [<ffffffff8112a37f>] bdi_sync_writeback+0x6f/0x80
> > > <4>[15241.043265]  [<ffffffff8112a3d2>] sync_inodes_sb+0x22/0x120
> > > <4>[15241.043375]  [<ffffffff8112f1d2>] __sync_filesystem+0x82/0x90
> > > <4>[15241.043485]  [<ffffffff8112f3db>] sync_filesystem+0x4b/0x70
> > > <4>[15241.043594]  [<ffffffff811391de>] fsync_bdev+0x2e/0x60
> > > <4>[15241.043704]  [<ffffffff812226be>] invalidate_partition+0x2e/0x50
> > > <4>[15241.043816]  [<ffffffff8116b92f>] del_gendisk+0x3f/0x140
> > > <4>[15241.043926]  [<ffffffffa00c0233>] mmc_blk_remove+0x33/0x60
> [mmc_block]
> > > <4>[15241.044043]  [<ffffffff81338977>] mmc_bus_remove+0x17/0x20
> > > <4>[15241.044152]  [<ffffffff812ce746>]
> __device_release_driver+0x66/0xc0
> > > <4>[15241.044264]  [<ffffffff812ce89d>]
> device_release_driver+0x2d/0x40
> > > <4>[15241.044375]  [<ffffffff812cd9b5>] bus_remove_device+0xb5/0x120
> > > <4>[15241.044486]  [<ffffffff812cb46f>] device_del+0x12f/0x1a0
> > > <4>[15241.044593]  [<ffffffff81338a5b>] mmc_remove_card+0x5b/0x90
> > > <4>[15241.044702]  [<ffffffff8133ac27>] mmc_sd_remove+0x27/0x50
> > > <4>[15241.044811]  [<ffffffff81337d8c>] mmc_resume_host+0x10c/0x140
> > > <4>[15241.044929]  [<ffffffffa00850e9>] sdhci_resume_host+0x69/0xa0
> [sdhci]
> > > <4>[15241.045044]  [<ffffffffa0bdc39e>] sdhci_pci_resume+0x8e/0xb0
> [sdhci_pci]
> >
> > So what's the hang?  del_gendisk is doing IO?  I'd assumed that it was
> > because it was calling kobject_uevent, but userspace is frozen.
> 
> This is a backtrace of a hang.
> 
> The patch I sent tries not to remove the card during suspend, by letting
> card presence logic to run after system is fully resumed.
> 

The assumption with CONFIG_MMC_UNSAFE_RESUME is that the card remains in the
slot during suspend. The controller driver can simply ignore a card removal
event if received in the suspended state. Wouldn't that solve your problem?

The system would resume because of the event and reinsertion of the card
would enumerate it again.

Regards,
Madhu

> However if CONFIG_MMC_UNSAFE_RESUME is not set, card would be removed at
> suspend time, again with userspace frozen.
> I will need to add some knobs to remove and add (if present) the card
> when system is fully resumed. It is possible, but I will need to dig the
> mmc code a bit deeper.
> 
> What I suggested is make del_gendisk suspend safe somehow.
> 
> Best regards,
> Maxim Levitsky
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

