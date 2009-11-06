Return-Path: <linux-kernel-owner+w=401wt.eu-S932971AbZKFXK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbZKFXK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 18:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760046AbZKFXKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 18:10:55 -0500
Received: from smtpout9.uol.com.br ([200.221.4.200]:40187 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760013AbZKFXKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 18:10:53 -0500
Date: Fri, 6 Nov 2009 21:10:49 -0200
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: 2.6.31-rc6: WARNING: at mm/page_alloc.c:1805 __alloc_pages_nodemas
Message-ID: <20091106231047.GA2045@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SIG5: b09aa3f6f30a0b167eb8733230bc5110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ted.

I am getting some stack traces (since the inclusion of commit
4b4f278c030aa4b6ee0915f396e9a9478d92d610) as follows:

,----
| [    6.449029] Adding 3903784k swap on /dev/hda2.  Priority:-1 extents:1 across:3903784k 
| [    6.638766] ------------[ cut here ]------------
| [    6.638842] WARNING: at mm/page_alloc.c:1805 __alloc_pages_nodemask+0x15e/0x57e()
| [    6.638913] Hardware name:  
| [    6.638962] Modules linked in: snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm firewire_ohci snd_timer firewire_core i2c_i801 snd e100 8139too mii uhci_hcd ehci_hcd fan usbcore parport_pc 8250_pnp crc_itu_t nls_base soundcore snd_page_alloc evdev psmouse rng_core parport 8250 thermal serial_core processor floppy
| [    6.640230] Pid: 898, comm: mount Not tainted 2.6.32-rc6-1-00026-g91d3f9b #1
| [    6.640282] Call Trace:
| [    6.640333]  [<ffffffff8107a169>] ? __alloc_pages_nodemask+0x15e/0x57e
| [    6.640387]  [<ffffffff8107a169>] ? __alloc_pages_nodemask+0x15e/0x57e
| [    6.640441]  [<ffffffff8103dbc8>] ? warn_slowpath_common+0x77/0xa3
| [    6.640495]  [<ffffffff8107a169>] ? __alloc_pages_nodemask+0x15e/0x57e
| [    6.640550]  [<ffffffff810b50d1>] ? alloc_inode+0x3d/0x74
| [    6.640602]  [<ffffffff810b329b>] ? __d_lookup+0x115/0x127
| [    6.640655]  [<ffffffff8107a59b>] ? __get_free_pages+0x12/0x4f
| [    6.640709]  [<ffffffff811396a8>] ? match_number+0x2a/0x8f
| [    6.640762]  [<ffffffff810fcb1f>] ? parse_options+0x474/0x4ed
| [    6.640815]  [<ffffffff810ff4d6>] ? ext4_remount+0xc9/0x34d
| [    6.640868]  [<ffffffff810a4e4c>] ? do_remount_sb+0x8e/0xc3
| [    6.640921]  [<ffffffff810b8f43>] ? do_mount+0x25d/0x777
| [    6.640973]  [<ffffffff810b75e2>] ? copy_mount_options+0xd8/0x13b
| [    6.641033]  [<ffffffff810b94e1>] ? sys_mount+0x84/0xc7
| [    6.641087]  [<ffffffff8100af6b>] ? system_call_fastpath+0x16/0x1b
| [    6.641139] ---[ end trace b9aacc99567ffbb9 ]---
| [    6.836225] iTCO_vendor_support: vendor-support=0
| [    6.842398] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
`----

This happens when I'm mounting an ext4 fs with the option auto_da_alloc,
but not when I mount without it.

My current mount options are the following:

    rw,relatime,nobarrier,delalloc,max_batch_time=50000,errors=remount-ro

and the filesystem has journal=writeback (I suspect that this may be the
bit that doesn't play nice with auto_da_alloc).

I don't really need auto_da_alloc (or, at least, think that I don't :-)
), but I just wanted to report this.

If any further information is needed, just let me know.


Regards,

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
