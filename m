Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZIKR2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZIKR2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 13:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZIKR2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 13:28:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:9212 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZIKR2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 13:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=wMiYKfGrzv5jgnh0cmT2W5M1ZpUHPevQbL9HzRxJOjMJJuYohH5ymu8+/g2DrkIA7J
         PJYIa9WVn5+XxS3Ld8F1QtObbS06xmEVqMwpTem9Q9r8NyHEV6HA0aidLUZC0tc5LAzk
         nyql3H1hKsVB2nScul10qI+E35ZzmuAmsa+ng=
Date: Fri, 11 Sep 2009 19:28:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Warning with hda intel registration on sysfs
Message-ID: <20090911172829.GA4993@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's not a new warning, I got it for a while now, probably since
.29, but it's still there (2.6.31).

I've seen a report about it by the past so I didn't wonder
much. And eventually I've been used to see it.

Tell me if you need my config. I'm currently running a -tip
based kernel but if you need I can send you a config against
vanilla.

Here is the warning:

[    4.099038] WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0x11b/0x150()
[    4.108180] Hardware name: AMILO Li 2727                  
[    4.117320] sysfs: cannot create duplicate filename '/dev/char/14:4'
[    4.126374] Modules linked in:
[    4.135204] Pid: 1, comm: swapper Not tainted 2.6.31-tip #208
[    4.143943] Call Trace:
[    4.152754]  [<ffffffff81195f8b>] ? sysfs_add_one+0x11b/0x150
[    4.161639]  [<ffffffff81053da0>] warn_slowpath_common+0x80/0xd0
[    4.170492]  [<ffffffff81053e79>] warn_slowpath_fmt+0x69/0x70
[    4.179283]  [<ffffffff810909a5>] ? trace_hardirqs_on_caller+0x145/0x190
[    4.188073]  [<ffffffff81195e55>] ? sysfs_pathname+0x45/0x60
[    4.197040]  [<ffffffff81195e55>] ? sysfs_pathname+0x45/0x60
[    4.205636]  [<ffffffff81195e55>] ? sysfs_pathname+0x45/0x60
[    4.213781]  [<ffffffff81195f8b>] sysfs_add_one+0x11b/0x150
[    4.221959]  [<ffffffff81197113>] sysfs_do_create_link+0x103/0x170
[    4.230121]  [<ffffffff811971b3>] sysfs_create_link+0x13/0x20
[    4.238289]  [<ffffffff81385d6f>] device_add+0x2af/0x680
[    4.246362]  [<ffffffff812b0368>] ? __spin_lock_init+0x38/0x70
[    4.254451]  [<ffffffff8138615e>] device_register+0x1e/0x30
[    4.262375]  [<ffffffff813862c8>] device_create_vargs+0x158/0x180
[    4.269873]  [<ffffffff81386340>] device_create+0x50/0x60
[    4.276845]  [<ffffffff814980d7>] ? sound_insert_unit+0xc7/0x280
[    4.283515]  [<ffffffff8160b9e5>] ? _spin_unlock+0x35/0x60
[    4.289919]  [<ffffffff814980d7>] ? sound_insert_unit+0xc7/0x280
[    4.296353]  [<ffffffff814981b4>] sound_insert_unit+0x1a4/0x280
[    4.302743]  [<ffffffff81498415>] register_sound_special_device+0xa5/0x220
[    4.309028]  [<ffffffff814aba0f>] snd_register_oss_device+0x2cf/0x370
[    4.315297]  [<ffffffff814c2ce0>] register_oss_dsp+0x60/0x90
[    4.321431]  [<ffffffff810906ac>] ? mark_held_locks+0x6c/0x90
[    4.327392]  [<ffffffff81609565>] ? __mutex_unlock_slowpath+0x125/0x190
[    4.333194]  [<ffffffff810909a5>] ? trace_hardirqs_on_caller+0x145/0x190
[    4.339054]  [<ffffffff810909fd>] ? trace_hardirqs_on+0xd/0x10
[    4.344824]  [<ffffffff814c7427>] snd_pcm_oss_register_minor+0x167/0x260
[    4.350747]  [<ffffffff816095de>] ? mutex_unlock+0xe/0x10
[    4.356658]  [<ffffffff814ade73>] ? snd_timer_dev_register+0xf3/0x130
[    4.362555]  [<ffffffff814aaca5>] ? snd_device_register+0x65/0x80
[    4.368582]  [<ffffffff814bd54f>] ? snd_pcm_timer_init+0x14f/0x1a0
[    4.374867]  [<ffffffff814b20bd>] snd_pcm_dev_register+0x1ad/0x2c0
[    4.381167]  [<ffffffff814aac19>] snd_device_register_all+0x39/0x60
[    4.387505]  [<ffffffff814a50a5>] snd_card_register+0x25/0x180
[    4.393781]  [<ffffffff815fd181>] azx_probe+0x901/0xab0
[    4.400107]  [<ffffffff815039d0>] ? azx_send_cmd+0x0/0x1b0
[    4.406376]  [<ffffffff81503770>] ? azx_get_response+0x0/0x260
[    4.412679]  [<ffffffff81502bb0>] ? azx_attach_pcm_stream+0x0/0x240
[    4.419127]  [<ffffffff815026f0>] ? azx_bus_reset+0x0/0x90
[    4.425509]  [<ffffffff812c19e5>] ? pci_match_device+0x25/0xe0
[    4.431956]  [<ffffffff812c1897>] local_pci_probe+0x17/0x20
[    4.438338]  [<ffffffff812c29c8>] pci_device_probe+0x88/0xb0
[    4.444611]  [<ffffffff8138887b>] ? driver_sysfs_add+0x6b/0x90
[    4.450887]  [<ffffffff813889cd>] driver_probe_device+0x9d/0x1b0
[    4.457114]  [<ffffffff81388b7b>] __driver_attach+0x9b/0xb0
[    4.463236]  [<ffffffff81388ae0>] ? __driver_attach+0x0/0xb0
[    4.469246]  [<ffffffff813880c3>] bus_for_each_dev+0x73/0xa0
[    4.475388]  [<ffffffff81388801>] driver_attach+0x21/0x30
[    4.481453]  [<ffffffff81387928>] bus_add_driver+0x268/0x2e0
[    4.487467]  [<ffffffff819e5c1d>] ? alsa_card_azx_init+0x0/0x1b
[    4.493588]  [<ffffffff81388ed1>] driver_register+0x81/0x170
[    4.499698]  [<ffffffff819e5c1d>] ? alsa_card_azx_init+0x0/0x1b
[    4.505845]  [<ffffffff812c2eaf>] __pci_register_driver+0x6f/0xf0
[    4.511990]  [<ffffffff819e5c1d>] ? alsa_card_azx_init+0x0/0x1b
[    4.518042]  [<ffffffff819e5c36>] alsa_card_azx_init+0x19/0x1b
[    4.524055]  [<ffffffff8100904d>] do_one_initcall+0x3d/0x190
[    4.530000]  [<ffffffff819b6afd>] kernel_init+0x16a/0x1c2
[    4.535935]  [<ffffffff8100c7da>] child_rip+0xa/0x20
[    4.541918]  [<ffffffff810487ff>] ? finish_task_switch+0x7f/0xe0
[    4.547955]  [<ffffffff8160b90b>] ? _spin_unlock_irq+0x3b/0x60
[    4.554049]  [<ffffffff8100c140>] ? restore_args+0x0/0x30
[    4.560138]  [<ffffffff819b6993>] ? kernel_init+0x0/0x1c2
[    4.566135]  [<ffffffff8100c7d0>] ? child_rip+0x0/0x20
[    4.572366] ---[ end trace 36623c312af01a26 ]---


Thanks,
	Frederic.

