Return-Path: <linux-kernel-owner+w=401wt.eu-S1751582Ab0AHFTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab0AHFTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 00:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465Ab0AHFTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 00:19:01 -0500
Received: from science.horizon.com ([71.41.210.146]:58015 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751445Ab0AHFTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 00:19:00 -0500
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jan 2010 00:18:59 EST
Date: 8 Jan 2010 00:12:19 -0500
Message-ID: <20100108051219.3498.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org
Subject: Re: WARNING: at fs/notify/inotify/inotify_fsnotify.c:129
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like others, I've got this message, but with a more recent kernel:
2.6.33-rc2.  This is after almost 12 days of uptime, so it's not
exactly rapidly repeatable.

x86-64 quad-core kernel, 32-bit (Debian/unstable) userland.  8GiB RAM.

------------[ cut here ]------------
WARNING: at fs/notify/inotify/inotify_fsnotify.c:129 idr_callback+0x36/0x58()
Hardware name: MS-7376
inotify closing but id=0 for entry=ffff880009762a10 in group=ffff880221a4a700 still in idr.  Probably leaking memory
Pid: 4171, comm: imap Not tainted 2.6.33-rc2 #95
Call Trace:
 [<ffffffff8102f45a>] ? warn_slowpath_common+0x71/0x87
 [<ffffffff8102f4c2>] ? warn_slowpath_fmt+0x40/0x45
 [<ffffffff8102b6d5>] ? default_wake_function+0x0/0xf
 [<ffffffff810ab03f>] ? idr_callback+0x36/0x58
 [<ffffffff811551d8>] ? idr_for_each+0x64/0xa7
 [<ffffffff8107ed4e>] ? virt_to_head_page+0x9/0x2b
 [<ffffffff810aaff8>] ? inotify_free_group_priv+0x1a/0x2b
 [<ffffffff810a9b2c>] ? fsnotify_final_destroy_group+0x1b/0x24
 [<ffffffff810ab1c9>] ? inotify_release+0x24/0x2f
 [<ffffffff8108610c>] ? __fput+0xef/0x17b
 [<ffffffff8108389d>] ? filp_close+0x54/0x5f
 [<ffffffff81083939>] ? sys_close+0x91/0xc4
 [<ffffffff810233d4>] ? cstar_dispatch+0x7/0x2b
---[ end trace 5507e3370989315e ]---
entry->group=(null) inode=(null) wd=4096
