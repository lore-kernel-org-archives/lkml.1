Return-Path: <linux-kernel-owner+w=401wt.eu-S1762866AbXEPRB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762866AbXEPRB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758300AbXEPRBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:01:12 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:38741 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756959AbXEPRBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:01:10 -0400
From: Bernd Schubert <bs@q-leap.de>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: mkfs.ext2 triggered softlockup
Date: Wed, 16 May 2007 19:01:08 +0200
User-Agent: KMail/1.9.6
Cc: "Bernd Schubert" <bschubert@q-leap.de>, linux-kernel@vger.kernel.org
References: <f2fcc1$otm$2@sea.gmane.org> <6bffcb0e0705160949m7486705s1b2fc5bbe8a025df@mail.gmail.com>
In-Reply-To: <6bffcb0e0705160949m7486705s1b2fc5bbe8a025df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705161901.09072.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 18:49:57 Michal Piotrowski wrote:
> Hi Bernd,
>
> On 16/05/07, Bernd Schubert <bschubert@q-leap.de> wrote:
> > Maybe you still remember my report about an mkfs.ext2 triggered ram disk
> > corruption?
> >
> > http://lkml.org/lkml/2007/5/4/272
> >
> > Well, in principle I'm now doing the same stuff, only this time with
> > another initrd, which mounts the root-fs over nfs.
> >
> > [ 1596.928552] BUG: soft lockup detected on CPU#2!
> > [ 1596.933109]
> > [ 1596.933110] Call Trace:
> > [ 1596.933111]  <IRQ>  [<ffffffff8025167b>] softlockup_tick+0xd8/0xef
> > [ 1596.933129]  [<ffffffff802329f8>] run_local_timers+0x13/0x15
> > [ 1596.933132]  [<ffffffff80232a44>] update_process_times+0x4a/0x77
> > [ 1596.933138]  [<ffffffff8021434b>] smp_local_timer_interrupt+0x34/0x54
> > [ 1596.933143]  [<ffffffff802143cc>] smp_apic_timer_interrupt+0x61/0x78
> > [ 1596.933147]  [<ffffffff8020a29b>] apic_timer_interrupt+0x6b/0x70
> > [ 1596.933151]  <EOI>  [<ffffffff80299dff>] free_buffer_head+0x24/0x3e
> > [ 1596.933162]  [<ffffffff80272a63>] kmem_cache_free+0x1f4/0x201
> > [ 1596.933170]  [<ffffffff80299dff>] free_buffer_head+0x24/0x3e
> > [ 1596.933175]  [<ffffffff80299ea1>] try_to_free_buffers+0x88/0x9f
> > [ 1596.933181]  [<ffffffff802565a9>] try_to_release_page+0x39/0x40
> > [ 1596.933188]  [<ffffffff8025b76d>] invalidate_mapping_pages+0x9d/0x121
> > [ 1596.933196]  [<ffffffff8025b800>] invalidate_inode_pages+0xf/0x11
> > [ 1596.933200]  [<ffffffff80299053>] invalidate_bdev+0x3b/0x3f
> > [ 1596.933203]  [<ffffffff8029c9ee>] kill_bdev+0x13/0x29
> > [ 1596.933208]  [<ffffffff8029d6e8>] __blkdev_put+0x62/0x141
> > [ 1596.933213]  [<ffffffff8029db62>] blkdev_put+0xb/0xd
> > [ 1596.933218]  [<ffffffff8029dbf7>] blkdev_close+0x2e/0x33
> > [ 1596.933222]  [<ffffffff8027a3c3>] __fput+0xc3/0x172
> > [ 1596.933228]  [<ffffffff8027a486>] fput+0x14/0x16
> > [ 1596.933233]  [<ffffffff80278c4f>] filp_close+0x61/0x6d
> > [ 1596.933238]  [<ffffffff80278ce7>] sys_close+0x8c/0xce
> > [ 1596.933244]  [<ffffffff8020965e>] system_call+0x7e/0x83
> > [ 1596.933250]
>
> Can you tell me which kernel version you are using?

Sorry, forgot that. I think 2.6.20.6 or 2.6.20.7 (I always rename them to .3, 
for some reasons thats easier than to change our tftp-rembo config). The 
kernel is patches with lustre patches, hmm, one of them also adds a read-only 
test to the block device layer.
Probably I should test a vanilla kernel. Going to do that now...

Thanks,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
