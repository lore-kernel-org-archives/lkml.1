Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbZJHRJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbZJHRJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 13:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758982AbZJHRJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 13:09:19 -0400
Received: from lucidpixels.com ([75.144.35.66]:59867 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758976AbZJHRJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 13:09:18 -0400
Date: Thu, 8 Oct 2009 13:08:41 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: lftp@uniyar.ac.ru
Subject: 2.6.31/lftp: WARNING: at drivers/char/tty_io.c:1267
 tty_open+0x439/0x4f0()
Message-ID: <alpine.DEB.2.00.0910081304080.11551@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

First time I have ever seen this issue, I am running 2.6.31 x86_64 & lftp:

$ lftp --version
LFTP | Version 4.0.2 | Copyright (c) 1996-2009 Alexander V. Lukyanov

I ran: lftp -f script where script downloads some files and then this 
occurred:

[1628036.347248] WARNING: at drivers/char/tty_io.c:1267 tty_open+0x439/0x4f0()
[1628036.347250] Hardware name:
[1628036.347252] Pid: 23495, comm: lftp Not tainted 2.6.31 #3
[1628036.347254] Call Trace:
[1628036.347259]  [<ffffffff810b5733>] ? do_lookup+0x143/0x270
[1628036.347261]  [<ffffffff8126a8f9>] ? tty_open+0x439/0x4f0
[1628036.347265]  [<ffffffff8105473f>] ? warn_slowpath_common+0x6f/0xc0
[1628036.347267]  [<ffffffff8126a8f9>] ? tty_open+0x439/0x4f0
[1628036.347270]  [<ffffffff813af3c2>] ? sock_aio_read+0x142/0x150
[1628036.347274]  [<ffffffff810afd78>] ? chrdev_open+0x88/0x170
[1628036.347277]  [<ffffffff810c50a3>] ? mntput_no_expire+0x23/0xf0
[1628036.347279]  [<ffffffff810afcf0>] ? chrdev_open+0x0/0x170
[1628036.347282]  [<ffffffff810ab00a>] ? __dentry_open+0x9a/0x260
[1628036.347284]  [<ffffffff810b9ace>] ? do_filp_open+0x71e/0xac0
[1628036.347287]  [<ffffffff810bac3f>] ? vfs_ioctl+0x2f/0xb0
[1628036.347289]  [<ffffffff810bb143>] ? do_vfs_ioctl+0x3e3/0x570
[1628036.347302]  [<ffffffff810c357a>] ? alloc_fd+0x4a/0x140
[1628036.347304]  [<ffffffff810aae77>] ? do_sys_open+0x97/0x150
[1628036.347308]  [<ffffffff8102c42b>] ? system_call_fastpath+0x16/0x1b
[1628036.347309] ---[ end trace b69ffec827da9b40 ]---

The lftp process was running in a screened session.

Any thoughts as to the bug here?

Justin.
