Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbYC3BGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbYC3BGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 21:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbYC3BGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 21:06:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32781 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbYC3BGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 21:06:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Olver Eduardo Ramos <olver.ramos@gmail.com>
Subject: Re: kernel bug
Date: Sun, 30 Mar 2008 02:06:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       Reinette Chatre <reinette.chatre@intel.com>, Zhu Yi <yi.zhu@intel.com>
References: <47EE063D.3050000@gmail.com>
In-Reply-To: <47EE063D.3050000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803300306.06256.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing wierless developers.]

A couple of questions:
(1) Which kernel is this?
(2) Did that happen on any previous kernels?
(3) What was the last kernel on which it didn't happen?

On Saturday, 29 of March 2008, Olver Eduardo Ramos wrote:
> ------------[ cut here ]------------
> kernel BUG at net/mac80211/ieee80211.c:966!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: iwl3945 mac80211 cfg80211 cryptomgr ecb arc4
> blkcipher crypto_algapi snd_seq_oss snd_seq_device snd_seq_midi_event
> snd_seq snd_pcm_oss snd_mixer_oss nvidia(P) snd_hda_intel snd_pcm
> snd_timer snd snd_page_alloc
> 
> Pid: 4472, comm: insmod Tainted: P        (2.6.24 #4)
> EIP: 0060:[<f9982867>] EFLAGS: 00210246 CPU: 1
> EIP is at ieee80211_alloc_hw+0x5a/0x2af [mac80211]
> EAX: f3ea8d80 EBX: fc226d60 ECX: c029cd19 EDX: f3ea8040
> ESI: fc226c80 EDI: f3ea8180 EBP: f7cc58e4 ESP: f3ea5dbc
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process insmod (pid: 4472, ti=f3ea4000 task=f3c8d110 task.ti=f3ea4000)
> Stack: f78583d8 f3ea8040 fc226cb0 fc226c80 f7cc5800 f7cc58e4 fc2110cc
> f5772180
>        00000000 f7ccdc90 c019c69e f3c81780 f3c81780 00200296 c03eb51d
> f7ccdc90
>        f7cc5800 f7cc58c4 c021fb2d fc226cb0 fc226c80 f7cc5800 f7cc58e4
> c022d84d
> Call Trace:
>  [<fc2110cc>] iwl3945_pci_probe+0x9e/0xcfd [iwl3945]
>  [<c019c69e>] sysfs_create_link+0xb7/0xf9
>  [<c03eb51d>] netlink_broadcast+0x261/0x2a1
>  [<c021fb2d>] kobject_get+0xf/0x13
>  [<c022d84d>] pci_device_probe+0x36/0x57
>  [<c029f010>] driver_probe_device+0xde/0x15c
>  [<c02205ff>] kobject_uevent_env+0x350/0x374
>  [<c029f125>] __driver_attach+0x0/0x87
>  [<c029f177>] __driver_attach+0x52/0x87
>  [<c029e5c5>] bus_for_each_dev+0x33/0x55
>  [<c029ee77>] driver_attach+0x16/0x18
>  [<c029f125>] __driver_attach+0x0/0x87
>  [<c029e8ab>] bus_add_driver+0x6d/0x197
>  [<c022d989>] __pci_register_driver+0x48/0x74
>  [<f93c9030>] iwl3945_init+0x30/0x74 [iwl3945]
>  [<c014229f>] sys_init_module+0x14bd/0x15e0
>  [<c0169f8d>] do_sync_read+0xc7/0x10a
>  [<c0150936>] __alloc_pages+0x61/0x2cf
>  [<f998d2d1>] ieee80211_rx_irqsafe+0x0/0x4f [mac80211]
>  [<c017b7e4>] mntput_no_expire+0x11/0x56
>  [<c0104e5a>] syscall_call+0x7/0xb
>  [<c0450000>] rpc_sleep_on+0x11d/0x224
>  =======================
> Code: 4c 9f 99 f9 89 d7 89 42 08 89 d0 81 c7 40 01 00 00 05 40 0d 00 00
> 89 57 2c 89 47 38 83 3b 00 75 04 0f 0b eb fe 83 7b 04 00 75 04 <0f> 0b
> eb fe 83 7b 08 00 75 04 0f 0b eb fe 83 7b 14 00 75 04 0f
> EIP: [<f9982867>] ieee80211_alloc_hw+0x5a/0x2af [mac80211] SS:ESP
> 0068:f3ea5dbc
> ---[ end trace 0378acc020bdab15 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
