Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbXKFVIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbXKFVIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbXKFVIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:08:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57033 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbXKFVIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:08:35 -0500
Date: Tue, 6 Nov 2007 13:07:12 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded
Message-ID: <20071106210712.GA5993@kroah.com>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org> <4730CB42.4090106@googlemail.com> <20071106134052.71bf12d6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106134052.71bf12d6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 01:40:52PM -0800, Andrew Morton wrote:
> > On Tue, 06 Nov 2007 21:14:58 +0100 Gabriel C <nix.or.die@googlemail.com> wrote:
> > After some hours uptime I got the following Oops :
> > 
> > [15745.009673] BUG: unable to handle kernel paging request at virtual address 63383166
> 
> An all-ascii address: "c81f".
> 
> > [15745.009683] printing eip: c01c50a2 *pde = 00000000
> > [15745.009692] Oops: 0002 [#1] SMP
> > [15745.009699] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:04:0b.0/irq
> > [15745.009705] Modules linked in: fuse pc87360 hwmon_vid eeprom adm1021 ext4dev jbd2 crc16 loop lp intel_agp sr_mod agpgart 3c59x parport_pc iTCO_wdt mii parport iTCO_vendor_support cdrom i82860_edac watchdog_core edac_core dcdbas pcspkr i2c_i801 watchdog_dev shpchp evdev pci_hotplug
> > [15745.009742]
> > [15745.009746] Pid: 6277, comm: su Not tainted (2.6.24-rc1-mm1 #2)
> > [15745.009751] EIP: 0060:[<c01c50a2>] EFLAGS: 00210206 CPU: 1
> > [15745.009761] EIP is at kobject_add+0xae/0x160
> > [15745.009765] EAX: c186c300 EBX: cf81a0b0 ECX: 63383166 EDX: cf81a0b8
> > [15745.009769] ESI: cf81a0b0 EDI: cf81a0d0 EBP: c03b4bcc ESP: cfa37f40
> > [15745.009773]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > [15745.009778] Process su (pid: 6277, ti=cfa36000 task=c354c000 task.ti=cfa36000)
> > [15745.009781] Stack: fffffffe c186c30c cf81a080 cf81a0b0 cf81a0d0 c03b4bcc c011fba1 cf81a0b0
> > [15745.009793]        c0368fd1 00000013 cf81a080 cf81a080 00000013 00000000 c011fe94 00000013
> > [15745.009804]        00000013 00000001 00000000 c0122e0d 00000013 00000000 09756508 c0124688
> > [15745.009815] Call Trace:
> > [15745.009820]  [<c011fba1>] uids_user_create+0x41/0x5a
> > [15745.009833]  [<c011fe94>] alloc_uid+0xad/0x121
> > [15745.009840]  [<c0122e0d>] set_user+0x1d/0x93
> > [15745.009847]  [<c0124688>] sys_setuid+0x47/0xc5
> > [15745.009855]  [<c0103d32>] sysenter_past_esp+0x5f/0x85
> > [15745.009868]  =======================
> > [15745.009870] Code: d4 13 00 83 7c 24 04 00 75 0f 8b 43 14 83 c0 0c e8 fc fb ff ff 89 44 24 04 8b 43 14 8b 48 04 8d 53 08 89 50 04 89 43 08 89 4b 0c <89> 11 8b 43 14 83 c0 08 c6 00 01 8b 44 24 04 89 43 10 c7 04 24
> > [15745.009928] EIP: [<c01c50a2>] kobject_add+0xae/0x160 SS:ESP 0068:cfa37f40
> > 
> 
> Don't knowm sorry - we'll need to wait until someone can hit it more
> reliably :(

Ah, I have a fix for that, Kay found it.  Do you want an add-on to your
tree, or a whole new version of one of the patches?

And it's pretty easy to hit, just start printing a lot of individual
files with a local printer to cups.  My daughter showed me in painful
detail how easy it was... :)

thanks,

greg k-h
